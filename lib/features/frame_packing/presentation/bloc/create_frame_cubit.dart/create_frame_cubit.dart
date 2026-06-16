
import 'dart:io';
import 'package:shakti_hormann/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/frame_packing/data/frame_packing_repo.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_lines.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';

part 'create_frame_cubit.freezed.dart';

enum FrameView { create, edit, completed }

extension ActionType on FrameView {
  String toName({bool isModified = false}) {
    return switch (this) {
      FrameView.create => 'Save',
      FrameView.edit => isModified ? 'Update' : 'Submit',
      FrameView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateFrameCubit extends AppBaseCubit<CreateFrameState> {
  CreateFrameCubit(this.repo) : super(CreateFrameState.initial());
  final FramePackingRepo repo;

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
    int? totalUnitsOnPallet,
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
      totalUnitsOnPallet:
          totalUnitsOnPallet ?? form.totalUnitsOnPallet,
      palletQrPrinted: palletQrPrinted ?? form.palletQrPrinted,
      palletPhotoImg: palletPhotos,
    );
    emitSafeState(state.copyWith(form: newForm, isModified: true));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is FramePacking) {
      DFU.toDateTime(entry.packingDate.valueOrEmpty, 'yyyy-MM-dd');
      // DFU.toDateTime(entry.gateEntryDate.valueOrEmpty, 'dd-MM-yyyy');
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
        totalUnitsOnPallet: entry.totalUnitsOnPallet,
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
              ? FrameView.completed
              : FrameView.edit;
      emitSafeState(
        state.copyWith(form: updatedForm, view: mode, isModified: false),
      );
    }
    if (entry == null) return;
  }

  void addAllLines(List<FrameLines> lines) {
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

        final newLine = FrameLines(
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
        FrameView.create => 'Draft',
        FrameView.edit => 'Draft',
        FrameView.completed => 'Submitted',
      };

      if (isNew) {
        final response = await repo.createFrame(form, state.lines);
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
                view: FrameView.edit,
                isModified: false,
              ),
            );
          },
        );
      } else if (isDraft && hasNewItems) {
        final response = await repo.updateFrame(form, state.newLines);
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
                view: FrameView.edit,
              ),
            );
          },
        );
      } else {
        final response = await repo.submitFrame(form);
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
                view: FrameView.completed,
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
    final isSubmit = state.view == FrameView.edit && !state.isModified;

    if (isSubmit &&
        form.palletPhotoImg == null &&
        (form.palletPhoto == null || form.palletPhoto!.isEmpty)) {
      return optionOf(const Pair('Pallet Image is Required before Submit', 0));
    }
    return const None();
  }
}

@freezed
class CreateFrameState with _$CreateFrameState {
  const factory CreateFrameState({
    required FramePacking form,
    required bool isLoading,
    required List<FrameLines> lines,
    required bool isSuccess,
    @Default([]) List<FrameLines> newLines,
    required FrameView view,
    @Default(false) bool isModified,

    String? successMsg,
    Failure? error,
  }) = _CreateFrameState;

  factory CreateFrameState.initial() {
    return const CreateFrameState(
      form: FramePacking(),
      lines: [],
      view: FrameView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}
