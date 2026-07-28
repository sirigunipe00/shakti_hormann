import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/installation/data/installation_repo.dart';
import 'package:shakti_hormann/features/installation/model/installation_line_items.dart';
import 'package:shakti_hormann/features/installation/model/installation_model.dart';

part 'create_installation_entry_cubit.freezed.dart';

enum InstallationView { create, edit, completed }

extension ActionType on InstallationView {
  String toName() {
    return switch (this) {
      InstallationView.create => 'Save',
      InstallationView.edit => 'Submit',
      InstallationView.completed => 'Submitted',
    };
  }
}

@injectable
class CreateInstallationEntryCubit extends AppBaseCubit<CreateInstallationState> {
  CreateInstallationEntryCubit(this.repo) : super(CreateInstallationState.initial());
  final InstallationRepo repo;

  void onValueChanged({
    String? name,
    String? creation,
    String? owner,
    int? docStatus,
    String? modified,
    String? modifiedBy,
    String? salesOrderNo,
    String? customerName,
    String? packingDate,
    String? shift,
    int? noOfBoxes,
    int? isStickerPrinted,
    String? remarks,
  }) async {
    // Once stickers are printed, Sales Order / No. of Boxes are locked.
    if (state.form.isStickerPrinted == 1) return;

    shouldAskForConfirmation.value = true;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final form = state.form;

    final newForm = form.copyWith(
      name: name ?? form.name,
      creation: today,
      owner: owner ?? form.owner,
      docStatus: docStatus ?? form.docStatus,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      salesOrderNo: salesOrderNo ?? form.salesOrderNo,
      customerName: customerName ?? form.customerName,
      shift: shift ?? form.shift,
      noOfBoxes: noOfBoxes ?? form.noOfBoxes,
      remarks: remarks ?? form.remarks,
      isStickerPrinted: isStickerPrinted ?? form.isStickerPrinted,
    );

    emitSafeState(state.copyWith(form: newForm, isModified: true));
  }

void initDetails(Object? entry) async {
    shouldAskForConfirmation.value = false;
    if (entry is InstallationModel) {
      final parsedDate = DFU.toDateTime(
        entry.creation.valueOrEmpty,
        'yyyy-MM-dd',
      );
      final formattedStr = DFU.friendlyFormat(parsedDate);
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        salesOrderNo: entry.salesOrderNo,
        packingDate: entry.packingDate,
        customerName: entry.customerName,
        noOfBoxes: entry.noOfBoxes,
        creation: formattedStr,
        isStickerPrinted: entry.isStickerPrinted,
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

      final mode = (isSubmitted || isCancelled)
          ? InstallationView.completed
          : InstallationView.edit;

      emitSafeState(
        state.copyWith(
          form: updatedForm,
          view: mode,
          isModified: false,
          isLoading: true,
        ),
      );

      if (entry.name != null && entry.name!.isNotEmpty) {
        final response = await repo.fetchInstallationLines(entry.name!);
        response.fold(
          (failure) {
            final fallbackLines = entry.isStickerPrinted == 1
                ? List.generate(
                    entry.noOfBoxes ?? 0,
                    (i) => InstallationLineItems(idx: i + 1),
                  )
                : <InstallationLineItems>[];
            emitSafeState(
              state.copyWith(
                isLoading: false, 
                lines: fallbackLines,
                isUpdated: false,
              ),
            );
          },
          (fetchedLines) {
            final bool hasPrintedStickers = entry.isStickerPrinted == 1 || updatedForm.isStickerPrinted == 1;
            final int boxCount = entry.noOfBoxes ?? updatedForm.noOfBoxes ?? 0;

            final lines = fetchedLines.isEmpty && hasPrintedStickers && boxCount > 0
                ? List.generate(
                    boxCount,
                    (i) => InstallationLineItems(idx: i + 1),
                  )
                : fetchedLines;
            final isFullyCaptured = lines.isNotEmpty &&
                lines.every(
                  (l) =>
                      (l.image != null && l.image!.isNotEmpty) ||
                      l.installtionPhotoImg != null,
                );

            emitSafeState(
              state.copyWith(
                isLoading: false,
                lines: lines,
                isUpdated: isFullyCaptured,
              ),
            );
          },
        );
      } else {
        emitSafeState(state.copyWith(isLoading: false));
      }
    }
  }

void addAllLines(List<InstallationLineItems> lines) {
  emitSafeState(state.copyWith(lines: lines));
}


void ensureLinePlaceholders(int boxCount) {
  if (state.lines.isNotEmpty || boxCount <= 0) return;
  emitSafeState(
    state.copyWith(
      lines: List.generate(boxCount, (i) => InstallationLineItems(idx: i + 1)),
    ),
  );
}

Future<void> createEntry() async {
  final form = state.form;

  if (form.salesOrderNo.isNull || form.salesOrderNo!.trim().isEmpty) {
    return _emitError(const Pair('Select Sales Order', 0));
  }
  final boxCount = form.noOfBoxes;
  if (boxCount == null || boxCount <= 0) {
    return _emitError(const Pair('Enter No of Boxes', 0));
  }
  if (form.name.isNotNull) return;

  emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

  final createResponse = await repo.createInstallation(form);

  createResponse.fold(
    (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
    (r) {
      final docNo = r.second;
      shouldAskForConfirmation.value = false;
      emitSafeState(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          successMsg: r.first,
          form: form.copyWith(name: docNo,docStatus: 0),
        ),
      );
    },
  );
}

Future<void> printSticker() async {
  final form = state.form;
  final docNo = form.name;

  if (docNo.isNull || docNo!.trim().isEmpty) {
    return _emitError(const Pair('Save the entry before printing', 0));
  }
  final boxCount = form.noOfBoxes ?? 0;
  if (boxCount <= 0) {
    return _emitError(const Pair('Enter No of Boxes', 0));
  }

  emitSafeState(state.copyWith(isPrintLoading: true, isSuccess: false));

  final printResponse = await repo.printinstallationSticker(docNo);

  printResponse.fold(
    (l) => emitSafeState(state.copyWith(isPrintLoading: false, error: l)),
    (printMsg) {
      final generatedLines = List.generate(
        boxCount,
        (i) => InstallationLineItems(idx: i + 1),
      );

      shouldAskForConfirmation.value = false;
      emitSafeState(
        state.copyWith(
          isPrintLoading: false,
          isSuccess: true,
          successMsg: printMsg,
          lines: generatedLines,
          form: form.copyWith(isStickerPrinted: 1),
          view: InstallationView.edit,
        ),
      );
    },
  );
}

  // Future<void> printSticker() async {
  //   final form = state.form;

  //   if (form.salesOrderNo.isNull || form.salesOrderNo!.trim().isEmpty) {
  //     return _emitError(const Pair('Select Sales Order', 0));
  //   }
  //   final boxCount = form.noOfBoxes;
  //   if (boxCount == null || boxCount <= 0) {
  //     return _emitError(const Pair('Enter No of Boxes', 0));
  //   }

  //   emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

  //   final createResponse = await repo.createInstallation(form);

  //   await createResponse.fold(
  //     (l) async => emitSafeState(state.copyWith(isLoading: false, error: l)),
  //     (r) async {
  //       final docNo = r.second;

  //       final printResponse = await repo.printinstallationSticker(docNo);

  //       printResponse.fold(
  //         (l) => emitSafeState(
  //           state.copyWith(
  //             isLoading: false,
  //             error: l,
  //             form: form.copyWith(name: docNo),
  //           ),
  //         ),
  //         (printMsg) {
  //           final generatedLines = List.generate(
  //             boxCount,
  //             (i) => InstallationLineItems(idx: i + 1),
  //           );

  //           shouldAskForConfirmation.value = false;
  //           emitSafeState(
  //             state.copyWith(
  //               isLoading: false,
  //               isSuccess: true,
  //               successMsg: printMsg,
  //               lines: generatedLines,
  //               form: form.copyWith(name: docNo, isStickerPrinted: 1),
  //               view: InstallationView.edit,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void onBoxNoChanged(int index, String boxNo) {
    if (index < 0 || index >= state.lines.length) return;
    final updated = [...state.lines];
    updated[index] = updated[index].copyWith(boxNo: boxNo);
    emitSafeState(state.copyWith(lines: updated, isModified: true));
  }

  Future<void> onBoxPhotoCaptured(int index, File file) async {
    if (state.form.isStickerPrinted != 1) return;
    if (index < 0 || index >= state.lines.length) return;

    final updated = [...state.lines];
    updated[index] = updated[index].copyWith(installtionPhotoImg: file);
    emitSafeState(state.copyWith(lines: updated, isModified: true));

    if (_allBoxesCaptured(updated) && !state.isUpdated) {
      await _autoUpdateInstallation();
    }
  }

  bool _allBoxesCaptured(List<InstallationLineItems> lines) =>
      lines.isNotEmpty && lines.every((l) => l.installtionPhotoImg != null);

  bool get allBoxesCaptured => _allBoxesCaptured(state.lines);

Future<void> _autoUpdateInstallation() async {
  final name = state.form.name;
  if (name.isNull) return;

  emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

  final images = <String>[];
  for (final line in state.lines) {
    final file = line.installtionPhotoImg;
    if (file == null) continue;

    if (!await file.exists()) {
      $logger.error('Box photo missing before compression: ${file.path}');
      continue;
    }

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 50,
      minWidth: 1280,
      minHeight: 1280,
    );

    if (compressedBytes != null) {
      images.add('data:image/png;base64,${base64Encode(compressedBytes)}');
    } else {
      final bytes = await file.readAsBytes();
      images.add('data:image/png;base64,${base64Encode(bytes)}');
    }
  }

  final response = await repo.updateInstallation(name!, images);

  response.fold(
    (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
    (msg) => emitSafeState(
      state.copyWith(
        isLoading: false,
        isSuccess: true,
        isUpdated: true,
        successMsg: msg,
      ),
    ),
  );
}

  Future<void> submit() async {
    final name = state.form.name;
    if (name.isNull) return;
    if (!state.isUpdated) {
      return _emitError(
        const Pair('Capture and upload all box photos first', 0),
      );
    }

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.submitInstallation(name!);

    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (msg) => emitSafeState(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          isModified: false,
          successMsg: msg,
          form: state.form.copyWith(docStatus: 1),
          view: InstallationView.completed,
        ),
      ),
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
}

@freezed
class CreateInstallationState with _$CreateInstallationState {
  const factory CreateInstallationState({
    required InstallationModel form,
    required bool isLoading,
    required bool isSuccess,
    @Default([]) List<InstallationLineItems> newLines,
    required List<InstallationLineItems> lines,
    required InstallationView view,
    @Default(false) bool isModified,
    @Default(false) bool isUpdated,
     @Default(false) bool isPrintLoading,

    String? successMsg,
    Failure? error,
  }) = _CreateInstallationState;

  factory CreateInstallationState.initial() {
    return const CreateInstallationState(
      form: InstallationModel(),
      lines: [],
      view: InstallationView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}