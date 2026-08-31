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

class _ParsedShutterQr {
  _ParsedShutterQr({
    required this.salesOrder,
    required this.itemIndex,
    required this.seqNo,
    required this.totalQty,
  });

  final String salesOrder;
  final String itemIndex;
  final int seqNo;
  final int totalQty;


  String get groupKey => '$salesOrder/$itemIndex';

  static _ParsedShutterQr? tryParse(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\s+'), '').trim();
    final parts = cleaned.split('/').where((e) => e.isNotEmpty).toList();

    if (parts.length < 5) return null;

    final seqNo = int.tryParse(parts[3]);
    final totalQty = int.tryParse(parts[4]);
    if (seqNo == null || seqNo <= 0) return null;
    if (totalQty == null || totalQty <= 0) return null;

    return _ParsedShutterQr(
      salesOrder: parts[0],
      itemIndex: parts[1],
      seqNo: seqNo,
      totalQty: totalQty,
    );
  }
}

@injectable
class CreateFrameCubit extends AppBaseCubit<CreateFrameState> {
  CreateFrameCubit(this.repo) : super(CreateFrameState.initial());
  final FramePackingRepo repo;

  bool _isSyncingLine = false;

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
    String? salesOrder,
    String? palletCode,
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
      salesOrder: salesOrder ?? form.salesOrder,
      palletCode: palletCode ?? form.palletCode,
      modifiedBy: modifiedBy ?? form.modifiedBy,
      packingDate: packingDate ?? form.packingDate,
      shift: shift ?? form.shift,
      operator: operator ?? form.operator,
      remarks: remarks ?? form.remarks,
      palletNo: palletNo ?? form.palletNo,
      totalUnitsOnPallet: totalUnitsOnPallet ?? form.totalUnitsOnPallet,
      palletQrPrinted: palletQrPrinted ?? form.palletQrPrinted,
      palletPhotoImg: palletPhotos,
    );
    emitSafeState(state.copyWith(form: newForm, isModified: true));
  }

  void initDetails(Object? entry) {
    shouldAskForConfirmation.value = false;
    if (entry is FramePacking) {
      DFU.toDateTime(entry.packingDate.valueOrEmpty, 'yyyy-MM-dd');
      final form = state.form;
      final updatedForm = form.copyWith(
        docStatus: entry.docStatus,
        name: entry.name,
        remarks: entry.remarks,
        packingDate: entry.packingDate,
        shift: entry.shift,
        operator: entry.operator,
        salesOrder: entry.salesOrder,
        palletCode: entry.palletCode,
        palletNo: entry.palletNo,
        palletPhoto: entry.palletPhoto,
        totalUnitsOnPallet: entry.totalUnitsOnPallet,
        palletQrPrinted: entry.palletQrPrinted,
        freezeQuantity: entry.freezeQuantity,
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
          (isSubmitted || isCancelled) ? FrameView.completed : FrameView.edit;
      emitSafeState(
        state.copyWith(
          form: updatedForm,
          view: mode,
          isModified: false,
          isFrozen: entry.freezeQuantity == 1,
        ),
      );
      final canSelectPallet =
          mode != FrameView.completed &&
          (entry.name == null || entry.name!.isEmpty);
      if (canSelectPallet && entry.salesOrder?.isNotEmpty == true) {
        getPalletCodes(entry.salesOrder!);
      }
    }
  }

  void addAllLines(List<FrameLines> lines) {
    emitSafeState(state.copyWith(lines: lines));
    final docName = state.form.name;
    if (docName != null && docName.isNotEmpty) {
      _mergeAttachmentsIntoLines(docName);
    }
  }

  Future<void> _mergeAttachmentsIntoLines(String docName) async {
    final response = await repo.fetchAttachments(docName);
    response.fold(
      (l) => null,
      (attachments) {
        final Map<String, List<String>> byLineName = {};
        for (final att in attachments) {
          final lineName = att.attchedName;
          final url = att.fileUrl;
          if (lineName == null || url == null || url.isEmpty) continue;
          byLineName.putIfAbsent(lineName, () => []).add(url);
        }

        final updatedLines = state.lines.map((line) {
          final urls = byLineName[line.name];
          if (urls == null || urls.isEmpty) return line;
          return line.copyWith(shutterPhoto: urls);
        }).toList();

        emitSafeState(state.copyWith(lines: updatedLines));
      },
    );
  }

  void createDocHandled() {
    emitSafeState(state.copyWith(createSuccessMsg: null));
  }

  Future<void> _refreshLinesFromServer() async {
    final docName = state.form.name;
    if (docName == null || docName.isEmpty) return;

    final response = await repo.fetchFrameLines(docName);
    final lines = response.fold<List<FrameLines>?>(
      (_) => null,
      (data) => data,
    );
    if (lines == null) return;

    emitSafeState(
      state.copyWith(
        lines: lines,
        newLines: [],
      ),
    );
    await _mergeAttachmentsIntoLines(docName);
  }

  Future<void> getPalletCodes(String salesOrder) async {
    emitSafeState(
      state.copyWith(
        isLoading: true,
        palletCodes: [],
      ),
    );

    final result = await repo.getFramePalletCode(salesOrder);

    result.fold(
      (failure) {
        emitSafeState(
          state.copyWith(
            isLoading: false,
            palletCodes: [],
            error: failure,
          ),
        );
      },
      (codes) {
        emitSafeState(state.copyWith(isLoading: false, palletCodes: codes));
      },
    );
  }
  Future<void> createDocument() async {
    final form = state.form;

    if (form.salesOrder == null ||
        form.salesOrder!.isEmpty ||
        form.palletCode == null ||
        form.palletCode!.isEmpty) {
      _emitError(
        const Pair('Please select Sales Order and Pallet Code', null),
      );
      return;
    }
    if (form.name != null && form.name!.isNotEmpty) return;

    emitSafeState(state.copyWith(isCreatingDoc: true));

    final response = await repo.createFrame(form, state.lines);

    response.fold(
      (failure) {
        emitSafeState(state.copyWith(isCreatingDoc: false, error: failure));
      },
      (r) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            form: form.copyWith(
              name: r.second,
              status: 'In Packing',
              allocationStatus: 'Unallocated',
              currentZone: '',
              docStatus: 0,
            ),
            isCreatingDoc: false,
            isModified: false,
            view: FrameView.edit,
            createSuccessMsg: '${r.first}\n${r.second}',
          ),
        );
      },
    );
  }

  Future<bool> printSticker() async {
    final docName = state.form.name;
    if (docName == null || docName.isEmpty) {
      _emitError(const Pair('No document found to print.', null));
      return false;
    }
    if (state.form.palletQrPrinted == 1 || state.form.docStatus == 1) {
      return false;
    }

    emitSafeState(state.copyWith(isPrinting: true));

    final response = await repo.printFrameSticker(docName);

    return response.fold(
      (failure) {
        emitSafeState(state.copyWith(isPrinting: false, error: failure));
        return false;
      },
      (message) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            isPrinting: false,
            printSuccessMsg: message,
            form: state.form.copyWith(palletQrPrinted: 1, docStatus: 0),
            isModified: false,
          ),
        );
        return true;
      },
    );
  }

  void printHandled() {
    emitSafeState(state.copyWith(printSuccessMsg: null));
  }

  Future<void> onQrScanned(String rawQr, {List<String>? imagePath}) async {
    final parsed = _ParsedShutterQr.tryParse(rawQr);
    if (parsed == null) {
      _emitError(Pair('Invalid QR format: $rawQr', null));
      return;
    }
     final selectedSalesOrder = state.form.salesOrder;
  if (selectedSalesOrder != null &&
      selectedSalesOrder.isNotEmpty &&
      parsed.salesOrder != selectedSalesOrder) {
    _emitError(
      Pair(
        'This item belongs to Sales Order ${parsed.salesOrder}, but the pallet is set to $selectedSalesOrder.',
        null,
      ),
    );
    return;
  }


    final salesOrder = parsed.salesOrder;
    final itemIndex = parsed.itemIndex;
    final totalQty = parsed.totalQty;
    final seqNo = parsed.seqNo;
    final scannedSeqNos =
        state.lines
            .map((line) {
              final existing =
                  line.shutterBarcodeQr == null
                      ? null
                      : _ParsedShutterQr.tryParse(line.shutterBarcodeQr!);
              if (existing == null || existing.groupKey != parsed.groupKey) {
                return null;
              }
              return existing.seqNo;
            })
            .whereType<int>()
            .toSet();

    if (scannedSeqNos.contains(seqNo)) {
      _emitError(
        Pair('Frame $seqNo of $totalQty has already been scanned.', null),
      );
      return;
    }
    if (seqNo > totalQty) {
      _emitError(
        Pair(
          'Frame $seqNo is out of range for total quantity $totalQty.',
          null,
        ),
      );
      return;
    }

    if (scannedSeqNos.length >= totalQty) {
      _emitError(
        Pair(
          'Maximum quantity of $totalQty already scanned for this item.',
          null,
        ),
      );
      return;
    }
    emitSafeState(state.copyWith(isProcessingScan: true));

    final result = await repo.fetchItems(salesOrder, itemIndex);

    await result.fold(
      (failure) async {
        emitSafeState(
          state.copyWith(isProcessingScan: false, error: failure),
        );
      },
      (items) async {
        if (items.isEmpty) {
          emitSafeState(state.copyWith(isProcessingScan: false));
          _emitError(
            Pair(
              'No item found for SO: $salesOrder at index $itemIndex',
              null,
            ),
          );
          return;
        }
        final item = items.first;

        final photos = (imagePath ?? []).map((path) => File(path)).toList();

        final newLine = FrameLines(
          salesOrder: salesOrder,
          itemCode: item.itemCode,
          shutterBarcodeQr: rawQr,
          shutterPhotoImg: photos.isEmpty ? null : photos,
        );
        final updated = [...state.lines, newLine];
        final newItems = [...state.newLines, newLine];

        emitSafeState(
          state.copyWith(
            lines: updated,
            isProcessingScan: false,
            isModified: true,
            newLines: newItems,
          ),
        );

        await _syncLineToServer();
      },
    );
  }
  Future<void> _syncLineToServer() async {
  if (_isSyncingLine) return;
  _isSyncingLine = true;

  try {
    final form = state.form;
    final docExists = form.name != null && form.name!.isNotEmpty;

    if (!docExists) {
      _emitError(
        const Pair(
          'Please save the Sales Order and Pallet Code before scanning items.',
          null,
        ),
      );
      return;
    }

    final pending = state.newLines;
    final allItems = state.lines;
    if (allItems.isEmpty) return;

    final response = await repo.updateFrame(form, allItems);
    final didUpdate = response.fold(
      (failure) {
        final failedQrs = pending
            .map((l) => l.shutterBarcodeQr)
            .whereType<String>()
            .toSet();

        final rolledBackLines = state.lines
            .where((l) => !failedQrs.contains(l.shutterBarcodeQr))
            .toList();

        emitSafeState(
          state.copyWith(
            lines: rolledBackLines,
            newLines: [],
            error: failure,
          ),
        );
        return false;
      },
      (_) {
        emitSafeState(state.copyWith(newLines: []));
        return true;
      },
    );
    if (didUpdate) {
      await _refreshLinesFromServer();
    }
  } finally {
    _isSyncingLine = false;
  }
}


  void addLinePhotos(int index, List<String> localPaths) {
    final lines = [...state.lines];
    final existing = <File>[...(lines[index].shutterPhotoImg ?? <File>[])];
    existing.addAll(localPaths.map((p) => File(p)));

    lines[index] = lines[index].copyWith(shutterPhotoImg: existing);
    emitSafeState(state.copyWith(lines: lines, isModified: true));
  }

  void removeLinePhoto(int lineIndex, int photoIndex) {
    final lines = [...state.lines];
    final photos = <File>[...(lines[lineIndex].shutterPhotoImg ?? <File>[])];
    if (photoIndex < 0 || photoIndex >= photos.length) return;

    photos.removeAt(photoIndex);
    lines[lineIndex] = lines[lineIndex].copyWith(
      shutterPhotoImg: photos.isEmpty ? null : photos,
    );
    emitSafeState(state.copyWith(lines: lines, isModified: true));
  }

  /// Removes a whole line item from the draft and syncs it for saved docs.
  Future<void> removeLine(int lineIndex) async {
    if (lineIndex < 0 || lineIndex >= state.lines.length) return;

    final previousLines = [...state.lines];
    final previousNewLines = [...state.newLines];
    final removed = state.lines[lineIndex];
    final updatedLines = [...state.lines]..removeAt(lineIndex);

    final updatedNewLines = [...state.newLines];
    final qr = removed.shutterBarcodeQr;
    if (qr != null && qr.isNotEmpty) {
      updatedNewLines.removeWhere((l) => l.shutterBarcodeQr == qr);
    } else {
      if (lineIndex >= 0 && lineIndex < updatedNewLines.length) {
        updatedNewLines.removeAt(lineIndex);
      }
    }

    final docExists = state.form.name != null && state.form.name!.isNotEmpty;
    emitSafeState(
      state.copyWith(
        lines: updatedLines,
        newLines: docExists ? updatedLines : updatedNewLines,
        isModified: true,
      ),
    );

    if (!docExists) return;

    emitSafeState(state.copyWith(isLoading: true));

    final response = await repo.updateFrame(state.form, updatedLines);
    final didUpdate = response.fold(
      (failure) {
        emitSafeState(
          state.copyWith(
            isLoading: false,
            lines: previousLines,
            newLines: previousNewLines,
            error: failure,
          ),
        );
        return false;
      },
      (_) {
        emitSafeState(
          state.copyWith(
            isLoading: false,
            newLines: [],
            isModified: false,
          ),
        );
        return true;
      },
    );
    if (didUpdate) {
      await _refreshLinesFromServer();
    }
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
                form: form.copyWith(
                  status: 'In Packing',
                  allocationStatus: 'Unallocated',
                  currentZone: '',
                  name: docstatus,
                  docStatus: 0,
                ),
                successMsg: '${r.first}\n${r.second}',
                view: FrameView.edit,
                isModified: false,
                newLines: [],
              ),
            );
          },
        );
      } else if (isDraft && hasNewItems) {
        final response = await repo.updateFrame(form, state.lines);
        final didUpdate = response.fold(
          (l) {
            emitSafeState(state.copyWith(isLoading: false, error: l));
            return false;
          },
          (r) {
            shouldAskForConfirmation.value = false;
            final updatedName =
                (r.second.isNotEmpty) ? r.second : form.name;
            emitSafeState(
              state.copyWith(
                isLoading: false,
                form: form.copyWith(
                  status: 'In Packing',
                  allocationStatus: form.allocationStatus ?? 'Unallocated',
                  name: updatedName,
                ),
                isSuccess: true,
                successMsg: '${r.first}\n${updatedName ?? ''}',
                isModified: false,
                view: FrameView.edit,
                newLines: [],
              ),
            );
            return true;
          },
        );
        if (didUpdate) {
          await _refreshLinesFromServer();
        }
        return;
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
                form: form.copyWith(
                  docStatus: 1,
                  status: 'Frozen',
                  allocationStatus: form.allocationStatus ?? 'Unallocated',
                ),
                successMsg: '${r.first}\n${r.second}',
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
    emitSafeState(
      state.copyWith(error: failure, isLoading: false, isProcessingScan: false),
    );
  }

  Future<void> freezeFrameQuantity() async {
    final docName = state.form.name;
    if (docName == null || docName.isEmpty) {
      _emitError(
        const Pair('Please save the document before freezing quantity.', null),
      );
      return;
    }

    emitSafeState(state.copyWith(isFreezing: true));

    final response = await repo.freezeFrame(docName);
    response.fold(
      (failure) {
        emitSafeState(state.copyWith(isFreezing: false, error: failure));
      },
      (r) {
        shouldAskForConfirmation.value = false;
        emitSafeState(
          state.copyWith(
            form: state.form.copyWith(freezeQuantity: 1),
            isFreezing: false,
            isFrozen: true,
            isModified: false,
            freezeSuccessMsg: r.first,
          ),
        );
      },
    );
  }

  void freezeHandled() {
    emitSafeState(state.copyWith(freezeSuccessMsg: null));
  }

  void errorHandled() {
    emitSafeState(
      state.copyWith(
        error: null,
        isLoading: false,
        isProcessingScan: false,
        isSuccess: false,
        successMsg: null,
      ),
    );
  }

  Option<Pair<String, int?>> _validate() {
    final form = state.form;
    final isSubmit = state.view == FrameView.edit && !state.isModified;
 if (form.salesOrder == null || form.salesOrder!.isEmpty) {
      return optionOf(const Pair('Sales Order is required', 0));
    }
    else if (form.palletCode == null || form.palletCode!.isEmpty) {
      return optionOf(const Pair('Pallet Code is required', 0));
    }

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
    @Default([]) List<String> palletCodes,
    required FrameView view,
    @Default(false) bool isPrinting,
    String? printSuccessMsg,
    @Default(false) bool isModified,
    @Default(false) bool isFreezing,
    @Default(false) bool isFrozen,
    @Default(false) bool isCreatingDoc,
    @Default(false) bool isProcessingScan,
    String? freezeSuccessMsg,
    String? successMsg,
    String? createSuccessMsg,
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