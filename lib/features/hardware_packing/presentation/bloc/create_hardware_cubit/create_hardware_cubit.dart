import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/hardware_packing/data/hardware_repo.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing.dart';

part 'create_hardware_cubit.freezed.dart';

enum HardwareView { create, edit, completed }

extension ActionType on HardwareView {
  String toName() {
    return switch (this) {
      HardwareView.create => 'Save',
      HardwareView.edit => 'Submit',
      HardwareView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateHardwareCubit extends AppBaseCubit<CreateHardwareState> {
  CreateHardwareCubit(this.repo) : super(CreateHardwareState.initial());
  final HardWareRepo repo;

  /// Lines already synced via create/update; only newer lines go in update API.
  int _syncedLineCount = 0;

  void onValueChanged({
    String? name,
    String? creationDate,
    String? owner,
    int? docStatus,
    int? boxCount,
    String? modifiedBy,
    String? modifiedDate,
    String? salesOrderNo,
    int? totalBoxCount,
    List<int>? scannedBoxNumbers,
    String? customerName,
    String? captueDate,
    String? operator,
    String? mesSystem,
    String? remarks,
    File? mesImage,
  }) async {
    shouldAskForConfirmation.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;

    final newForm = form.copyWith(
      name: name ?? form.name,
      creation: today,
      owner: owner ?? form.owner,
      docStatus: docStatus ?? form.docStatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      modified: modifiedDate ?? form.modified,
      salesOrderNo: salesOrderNo ?? form.salesOrderNo,
      customerName: customerName ?? form.customerName,
      captueDate: captueDate ?? form.captueDate,
      operator: operator ?? form.operator,
      mesSystem: mesSystem ?? form.mesSystem,
      boxCount: boxCount ?? form.boxCount,
      totalBoxCount: totalBoxCount ?? form.totalBoxCount,
      scannedBoxNumbers: scannedBoxNumbers ?? form.scannedBoxNumbers,
      remarks: remarks ?? form.remarks,
      mesStickerImage: mesImage ?? form.mesStickerImage,
    );

    emitSafeState(state.copyWith(form: newForm, isModified: true));
  }

  void addHardwareItems(List<HardwareItem> newItems) {
    emitSafeState(
      state.copyWith(
        lines: [...state.lines, ...newItems],
        isModified: true,
      ),
    );
  }

  void initDetails(Object? entry) async {
    shouldAskForConfirmation.value = false;
    if (entry is HardwarePacking) {
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        creation: entry.creation,
        salesOrderNo: entry.salesOrderNo,
        customerName: entry.customerName,
        captueDate: entry.captueDate,
        operator: entry.operator,
        mesSystem: entry.mesSystem,
        boxCount: entry.boxCount,
      );

      final status = entry.docStatus ?? 0;
      final isSubmitted = status == 1;
      final isCancelled = status == 2;
      final mode =
          (isSubmitted || isCancelled)
              ? HardwareView.completed
              : HardwareView.edit;

      emitSafeState(
        state.copyWith(
          form: updatedForm,
          view: mode,
          isModified: false,
        ),
      );
    }
    if (entry == null) return;
  }

  void updateHardwareItems(List<HardwareItem> items) {
    emitSafeState(
      state.copyWith(
        lines: items,
        isModified: true,
      ),
    );
  }

  void addAllLines(List<HardwareItem> lines) {
    _syncedLineCount = lines.length;
    emitSafeState(
      state.copyWith(lines: lines, isModified: false),
    );
  }

  Future<void> save() async {
    final validation = _validate();
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

      if (state.view == HardwareView.create) {
        final response = await repo.createHardware(state.form, state.lines);

        return response.fold(
          (l) => emitSafeState(
            state.copyWith(isLoading: false, error: l, isSuccess: false),
          ),
          (r) {
            shouldAskForConfirmation.value = false;
            _syncedLineCount = state.lines.length;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                isModified: false,
                form: state.form.copyWith(
                  status: 'Draft',
                  name: r.second,
                  docStatus: 0,
                ),
                successMsg: '${r.first}\n${r.second}',
                view: HardwareView.edit,
              ),
            );
          },
        );
      }
      emitSafeState(state.copyWith(isLoading: false));
    }, _emitError);
  }

  Future<void> update() async {
    final name = state.form.name;
    if (name == null || name.isEmpty) {
      return _emitError(const Pair('Document ID missing for update', 0));
    }

    final pendingLines = state.lines.skip(_syncedLineCount).toList();
    if (pendingLines.isEmpty && !state.isModified) {
      return _emitError(const Pair('No new MES sticker items to update', 0));
    }

    final linesToSend =
        pendingLines.isNotEmpty ? pendingLines : state.lines;

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.updateHardware(state.form, linesToSend);

    response.fold(
      (l) => emitSafeState(
        state.copyWith(isLoading: false, error: l, isSuccess: false),
      ),
      (r) {
        shouldAskForConfirmation.value = false;
        _syncedLineCount = state.lines.length;
        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            isModified: false,
            successMsg: '${r.first}\n${r.second}',
            view: HardwareView.edit,
            form: state.form.copyWith(docStatus: 0, status: 'Draft'),
          ),
        );
      },
    );
  }

  Future<void> submit() async {
    final name = state.form.name;
    if (name == null || name.isEmpty) {
      return _emitError(const Pair('Document ID missing for submit', 0));
    }

    if (state.isModified || state.lines.length > _syncedLineCount) {
      return _emitError(
        const Pair('Update new MES sticker items before submit', 0),
      );
    }

    if (state.lines.isEmpty) {
      return _emitError(const Pair('Add at least one MES sticker item', 0));
    }

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.submitHardware(name);

    response.fold(
      (l) => emitSafeState(
        state.copyWith(isLoading: false, error: l, isSuccess: false),
      ),
      (msg) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            isModified: false,
            successMsg: '${msg.first}\n${msg.second}',
            form: state.form.copyWith(docStatus: 1, status: 'Submitted'),
            view: HardwareView.completed,
          ),
        );
      },
    );
  }

  void _emitError(Pair<String, int?> error) {
    final failure = Failure(
      error: error.first,
      title: 'Missing Fields',
      status: error.second,
    );
    emitSafeState(state.copyWith(error: failure, isLoading: false));
  }

  void errorHandled() {
    emitSafeState(
      state.copyWith(
        error: null,
        isLoading: false,
        isSuccess: false,
        successMsg: null,
      ),
    );
  }

  Option<Pair<String, int?>> _validate() {
    final form = state.form;
    if (form.salesOrderNo == null || form.salesOrderNo!.isEmpty) {
      return optionOf(const Pair('Select Sales Order', 0));
    }

    if (state.lines.isEmpty) {
      return optionOf(const Pair('Capture at least one MES sticker', 0));
    }

    return const None();
  }
}

@freezed
class CreateHardwareState with _$CreateHardwareState {
  const factory CreateHardwareState({
    required HardwarePacking form,
    required List<HardwareItem> lines,
    required bool isLoading,
    required bool isSuccess,
    required HardwareView view,
    @Default(false) bool isModified,
    String? successMsg,
    Failure? error,
  }) = _CreateHardwareState;

  factory CreateHardwareState.initial() {
    return const CreateHardwareState(
      form: HardwarePacking(),
      lines: [],
      view: HardwareView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
