
import 'dart:io';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/shutter_packing/data/shutter_packaging_repo.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_lines.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_packing.dart';

part 'create_shutter_cubit.freezed.dart';

enum ShutterView { create, edit, completed }

extension ActionType on ShutterView {
  String toName({bool isModified = false}) {
    return switch (this) {
      ShutterView.create => 'Save',
      ShutterView.edit => isModified ? 'Update' : 'Submit',
      ShutterView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateShutterCubit extends AppBaseCubit<CreateShutterState> {
  CreateShutterCubit(this.repo) : super(CreateShutterState.initial());
  final ShutterPackingRepo repo;

  void onValueChanged({
    String? owner,
    String? name,
    String? creation,
    String? modified,
    String? modifiedBy,
    int? docStatus,
    String? packingDate,
    String? shift,
    String? operator,
    String? palletNo,
    int? palletQrPrinted,
    int? totalShuttersOnPallet,
    int? totalBoxesOnPallet,
    String? remarks,
    File? palletPhoto,
  }) {
    shouldAskForConfirmation.value = true;

    final form = state.form;
    final palletPhotos = palletPhoto ?? form.palletPhotoImg;
    final newForm = form.copyWith(
      owner: owner ?? form.owner,
      name: name ?? form.name,
      creation: creation ?? form.creation,
      docStatus: docStatus ?? form.docStatus,
      modified: modified ?? form.modified,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      packingDate: packingDate ?? form.packingDate,
      shift: shift ?? form.shift,
      operator: operator ?? form.operator,
      remarks: remarks ?? form.remarks,
      palletNo: palletNo ?? form.palletNo,
      totalShuttersOnPallet:
          totalShuttersOnPallet ?? form.totalShuttersOnPallet,
      totalBoxesOnPallet: totalBoxesOnPallet ?? form.totalBoxesOnPallet,
      palletQrPrinted: palletQrPrinted ?? form.palletQrPrinted,
      palletPhotoImg: palletPhotos,
    );
    emitSafeState(state.copyWith(form: newForm, isModified: true));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is ShutterPacking) {
      DFU.toDateTime(entry.packingDate.valueOrEmpty, 'yyyy-MM-dd');

      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        packingDate: entry.packingDate,
        shift: entry.shift,
        operator: entry.operator,
        palletNo: entry.palletNo,
        palletPhoto: entry.palletPhoto,
        totalShuttersOnPallet: entry.totalShuttersOnPallet,
        totalBoxesOnPallet: entry.totalBoxesOnPallet,
        palletQrPrinted: entry.palletQrPrinted,
        creation: entry.creation,
      );
      final status = entry.docStatus;
      final isSubmitted = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status!),
        'Submitted',
      );
      final isCancelled = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status).trim(),
        'Cancelled',
      );
      final mode =
          (isSubmitted || isCancelled)
              ? ShutterView.completed
              : ShutterView.edit;
      emitSafeState(
        state.copyWith(form: updatedForm, view: mode, isModified: false),
      );
    }
    if (entry == null) return;
  }

  void addAllLines(List<ShutterLines> lines) {
    emitSafeState(state.copyWith(lines: lines));
  }

  Future<void> onQrScanned(String rawQr, {String? imagePath}) async {
    final cleaned = rawQr.replaceAll(RegExp(r'\s+'), '').trim();

    final parts = cleaned.split('/').where((e) => e.isNotEmpty).toList();

    if (parts.length < 5) {
      _emitError(Pair('Invalid QR format: $cleaned', null));
      return;
    }
    final salesOrder = parts[0];
    final itemIndex = parts[1];

    emitSafeState(state.copyWith(isLoading: true));

    final result = await repo.fetchItems(salesOrder, itemIndex);

    result.fold(
      (failure) =>
          emitSafeState(state.copyWith(isLoading: false, error: failure)),
      (items) async {
        if (items.isEmpty) {
          _emitError(
            Pair('No item found for SO: $salesOrder at index $itemIndex', null),
          );
          return;
        }
        final item = items.first;
        File? photo;
        if (imagePath != null) {
          photo = File(imagePath);
        }

        final newLine = ShutterLines(
          salesOrder: salesOrder,
          itemCode: item.itemCode,
          shutterBarcodeQr: rawQr,
          shutterPhotoImg: photo,
        );
        final updated = [...state.lines, newLine];
        final newItems = [...state.newLines, newLine];

        emitSafeState(
          state.copyWith(
            lines: updated,
            isLoading: false,
            isModified: true,
            newLines: newItems,
          ),
        );
      },
    );
  }

  void updateLinePhoto(int index, String localPath) {
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(shutterPhotoImg: File(localPath));
    emitSafeState(state.copyWith(lines: lines, isModified: true));
  }

  void removeLineAt(int index) {
    final lines = [...state.lines]
    ..removeAt(index);
    emit(state.copyWith(lines: lines, isModified: true));
  }

  void clearVehiclePhoto() {
    final form = state.form.copyWith(palletPhoto: null);
    emitSafeState(state.copyWith(form: form));
  }

  void save() async {
    final validation = _validate();
    final hasNewItems = state.newLines.isNotEmpty;
    return validation.fold(() async {
      emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

      final form = state.form;
      final isNew = form.name == null || form.name!.isEmpty;
      final isDraft = form.docStatus == null || form.docStatus == 0;
      final status = switch (state.view) {
        ShutterView.create => 'Draft',
        ShutterView.edit => 'Draft',
        ShutterView.completed => 'Submitted',
      };

      if (isNew) {
        final response = await repo.createShutter(form, state.lines);
        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            final docstatus = r.second;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: form.copyWith(status: status, name: docstatus),
                successMsg: '${r.first}\n${r.second}',
                view: ShutterView.edit,
                isModified: false,
              ),
            );
          },
        );
      } else if (isDraft && hasNewItems) {
        final response = await repo.updateShutter(form, state.newLines);
        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                form: form.copyWith(status: status, name: r.second),
                isSuccess: true,
                successMsg: r.first,
                isModified: false,
                view: ShutterView.edit,
              ),
            );
          },
        );
      } else {
        final response = await repo.submitShutter(form);
        return response.fold(
          (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
          (r) {
            shouldAskForConfirmation.value = false;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                isSuccess: true,
                form: form.copyWith(docStatus: 1),
                successMsg: r.first,
                view: ShutterView.completed,
                isModified: false,
              ),
            );
          },
        );
      }
    }, _emitError);
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
    final isSubmit = state.view == ShutterView.edit && !state.isModified;

    if (isSubmit &&
        form.palletPhotoImg == null &&
        (form.palletPhoto == null || form.palletPhoto!.isEmpty)) {
      return optionOf(const Pair('Pallet Image is Required before Submit', 0));
    }
    return const None();
  }
}

@freezed
class CreateShutterState with _$CreateShutterState {
  const factory CreateShutterState({
    required ShutterPacking form,
    required bool isLoading,
    required List<ShutterLines> lines,
    required bool isSuccess,
    @Default([]) List<ShutterLines> newLines,
    required ShutterView view,
    @Default(false) bool isModified,

    String? successMsg,
    Failure? error,
  }) = _CreateShutterState;

  factory CreateShutterState.initial() {
    return const CreateShutterState(
      form: ShutterPacking(),
      lines: [],
      view: ShutterView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
