// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:injectable/injectable.dart';
// import 'package:shakti_hormann/core/core.dart';
// import 'package:shakti_hormann/features/vision_panel/data/vision_panel_repo.dart';
// import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
// import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
// import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';

// part 'create_vision_panel.freezed.dart';

// enum VisionView { create, edit, completed }

// @injectable
// class CreateVisionPanelCubit extends AppBaseCubit<CreateVisionPanelState> {
//   CreateVisionPanelCubit(this.repo) : super(CreateVisionPanelState.initial());
//   final VisionPanelRepo repo;

//   void onSalesOrderSelected(String salesOrderNo) {
//     shouldAskForConfirmation.value = true;
//     final form = state.form.copyWith(salesOrderNo: salesOrderNo);
//     emitSafeState(state.copyWith(form: form, isModified: true));
//   }

//   void updateItemField(int index, {String? productType, int? noOfBoxes}) {
//     if (index < 0 || index >= state.items.length) return;
//     final updated = [...state.items];
//     var current = updated[index];

//     updated[index] = current.copyWith(
//       productType: productType ?? current.productType,
//       noOfBoxes: noOfBoxes ?? current.noOfBoxes,
//     );

//     emitSafeState(state.copyWith(items: updated, isModified: true));
//   }

//   void addAllLines(List<VisionItems> lines) {
//     emitSafeState(state.copyWith(items: lines));
//   }

//   void addAllEntryLines(List<VisionPanelEntryLines> lines) {
//     emitSafeState(state.copyWith(imageLines: lines));
//   }

//   List<VisionPanelEntryLines> _buildLinesFromPrintedItems(
//     List<VisionItems> items,
//   ) {
//     final lines = <VisionPanelEntryLines>[];
//     for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
//       final item = items[itemIndex];
//       if (item.printCheck != 1) continue;
//       final boxCount = item.noOfBoxes ?? 0;
//       for (var i = 0; i < boxCount; i++) {
//         lines.add(
//           VisionPanelEntryLines(
//             idx: lines.length + 1,
//             productType: item.productType,
//             itemIndex: itemIndex,
//           ),
//         );
//       }
//     }
//     return lines;
//   }

//   void initDetails(Object? entry) async {
//     shouldAskForConfirmation.value = false;

//     if (entry is VisionModel) {
//       final parsedDate = DFU.toDateTime(
//         entry.creation.valueOrEmpty,
//         'yyyy-MM-dd',
//       );
//       final formattedStr = DFU.friendlyFormat(parsedDate);
//       final form = state.form;

//       final updatedForm = form.copyWith(
//         docStatus: entry.docStatus,
//         name: entry.name,
//         remarks: entry.remarks,
//         salesOrderNo: entry.salesOrderNo,
//         packingDate: entry.packingDate,
//         customerName: entry.customerName,
//         totalBoxes: entry.totalBoxes,
//         creation: formattedStr,
//       );

//       final status = entry.docStatus;
//       final isSubmitted = StringUtils.equalsIgnoreCase(
//         StringUtils.docStatus(status ?? 0),
//         'Submitted',
//       );
//       final isCancelled = StringUtils.equalsIgnoreCase(
//         StringUtils.docStatus(status ?? 0).trim(),
//         'Cancelled',
//       );

//       final mode = (isSubmitted || isCancelled)
//           ? VisionView.completed
//           : VisionView.edit;

//       emitSafeState(
//         state.copyWith(
//           form: updatedForm,
//           view: mode,
//           isModified: false,
//           isLoading: true,
//         ),
//       );

//       if (entry.name != null && entry.name!.isNotEmpty) {
//         // Fetch Items (Product Type & Box Count)
//         final linesResponse = await repo.fetchVisionLines(entry.name!);
//         List<VisionItems> fetchedItems = state.items;
//         linesResponse.fold(
//           (failure) => null,
//           (items) {
//             fetchedItems = items;
//             emitSafeState(state.copyWith(items: items));
//           },
//         );

//         final entryLinesResponse =
//             await repo.fetchVisionEntryLines(entry.name!);
//             entryLinesResponse.fold(
//   (failure) {
//     emitSafeState(state.copyWith(isLoading: false));
//   },
//   (imageLines) {
//     // Start with whatever the server actually has.
//     final resolvedLines = [...imageLines];

//     // For every printed item, if the server returned NO lines for that
//     // specific item yet (e.g. it was printed externally/on the web and
//     // no photos have been uploaded for it), synthesize placeholder rows
//     // locally so its capture UI still shows up.
//     for (var itemIndex = 0; itemIndex < fetchedItems.length; itemIndex++) {
//       final item = fetchedItems[itemIndex];
//       if (item.printCheck != 1) continue;

//       final hasServerLinesForItem =
//           imageLines.any((l) => l.itemIndex == itemIndex);
//       if (hasServerLinesForItem) continue;

//       final boxCount = item.noOfBoxes ?? 0;
//       for (var i = 0; i < boxCount; i++) {
//         resolvedLines.add(
//           VisionPanelEntryLines(
//             idx: resolvedLines.length + 1,
//             productType: item.productType,
//             itemIndex: itemIndex,
//           ),
//         );
//       }
//     }

//     // Recompute which items already have every box captured on
//     // the server, so canAddNewItem/isUpdated reflect reality
//     // after a fresh load (not just what happened this session).
//     final uploaded = <int>{};
//     for (var i = 0; i < fetchedItems.length; i++) {
//       final itemLines =
//           resolvedLines.where((l) => l.itemIndex == i).toList();
//       final done = itemLines.isNotEmpty &&
//           itemLines.every(
//             (l) => (l.image != null && l.image!.isNotEmpty),
//           );
//       if (done) uploaded.add(i);
//     }

//     final printedIndexes = [
//       for (var i = 0; i < fetchedItems.length; i++)
//         if (fetchedItems[i].printCheck == 1) i,
//     ];
//     final isFullyCaptured = printedIndexes.isNotEmpty &&
//         printedIndexes.every(uploaded.contains);

//     emitSafeState(
//       state.copyWith(
//         isLoading: false,
//         imageLines: resolvedLines,
//         isUpdated: isFullyCaptured,
//         uploadedItemIndexes: uploaded,
//       ),
//     );
//   },
// );
//         // entryLinesResponse.fold(
//         //   (failure) {
//         //     emitSafeState(state.copyWith(isLoading: false));
//         //   },
//         //   (imageLines) {
//         //     final resolvedLines = imageLines.isNotEmpty
//         //         ? imageLines
//         //         : _buildLinesFromPrintedItems(fetchedItems);
//         //     final uploaded = <int>{};
//         //     for (var i = 0; i < fetchedItems.length; i++) {
//         //       final itemLines =
//         //           resolvedLines.where((l) => l.itemIndex == i).toList();
//         //       final done = itemLines.isNotEmpty &&
//         //           itemLines.every(
//         //             (l) => (l.image != null && l.image!.isNotEmpty),
//         //           );
//         //       if (done) uploaded.add(i);
//         //     }

//         //     final printedIndexes = [
//         //       for (var i = 0; i < fetchedItems.length; i++)
//         //         if (fetchedItems[i].printCheck == 1) i,
//         //     ];
//         //     final isFullyCaptured = printedIndexes.isNotEmpty &&
//         //         printedIndexes.every(uploaded.contains);

//         //     emitSafeState(
//         //       state.copyWith(
//         //         isLoading: false,
//         //         imageLines: resolvedLines,
//         //         isUpdated: isFullyCaptured,
//         //         uploadedItemIndexes: uploaded,
//         //       ),
//         //     );
//         //   },
//         // );
//       } else {
//         emitSafeState(state.copyWith(isLoading: false));
//       }
//     }
//   }

//   void ensureLinePlaceholders(int boxCount) {
//     if (state.imageLines.isNotEmpty || boxCount <= 0) return;
//     emitSafeState(
//       state.copyWith(
//         imageLines: List.generate(
//           boxCount,
//           (i) => VisionPanelEntryLines(idx: i + 1),
//         ),
//       ),
//     );
//   }

//   /// Step 1: Create Document API
//   Future<void> createEntry() async {
//     final salesOrder = state.form.salesOrderNo;
//     if (salesOrder.isNull || salesOrder!.isEmpty) {
//       return _emitError(const Pair('Select Sales Order No.', 0));
//     }
//     if (state.items.isEmpty) {
//       return _emitError(
//         const Pair('Select Product Type and No. of Boxes', 0),
//       );
//     }

//     emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

//     final response = await repo.createVision(state.form, state.items);

//     response.fold(
//       (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
//       (r) {
//         final docNo = r.second;
//         shouldAskForConfirmation.value = false;

//         emitSafeState(
//           state.copyWith(
//             isLoading: false,
//             isSuccess: true,
//             successMsg: r.first,
//             form: state.form.copyWith(name: docNo, docStatus: 0),
//             view: VisionView.edit,
//           ),
//         );
//       },
//     );
//   }

//   Future<void> printItemSticker(int index) async {
//     final docNo = state.form.name;
//     if (docNo.isNull || docNo!.isEmpty) {
//       return _emitError(const Pair('Document ID missing for print', 0));
//     }
//     if (index < 0 || index >= state.items.length) {
//       return _emitError(const Pair('Invalid item selected for print', 0));
//     }

//     emitSafeState(
//       state.copyWith(isPrintLoading: true, error: null, isSuccess: false),
//     );

//     try {
//       final response = await repo.printVisionSticker(docNo);

//       response.fold(
//         (failure) {
//           emitSafeState(state.copyWith(isPrintLoading: false, error: failure));
//         },
//         (msg) {
//           final updatedItems = [...state.items];
//           final currentItem = updatedItems[index];


//           if (currentItem.printCheck == 1) {
//             emitSafeState(
//               state.copyWith(isPrintLoading: false, isSuccess: true, successMsg: msg),
//             );
//             return;
//           }

//           final boxCount = currentItem.noOfBoxes ?? 0;
//           updatedItems[index] = currentItem.copyWith(printCheck: 1);


//           final existingLines = [...state.imageLines];
//           final newLines = List.generate(
//             boxCount,
//             (i) => VisionPanelEntryLines(
//               idx: existingLines.length + i + 1,
//               productType: currentItem.productType,
//               itemIndex: index,
//             ),
//           );
//           final combinedLines = [...existingLines, ...newLines];

//           emitSafeState(
//             state.copyWith(
//               isPrintLoading: false,
//               isSuccess: true,
//               successMsg: msg,
//               items: updatedItems,
//               imageLines: combinedLines,
//               uploadedItemIndexes: {...state.uploadedItemIndexes}
//                 ..remove(index),
//               isUpdated: false,
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       final failure = e is Failure
//           ? e
//           : Failure(error: e.toString(), title: 'Print Failed', status: 0);
//       emitSafeState(state.copyWith(isPrintLoading: false, error: failure));
//     }
//   }

//   Future<void> onBoxPhotoCaptured(int index, File file) async {
//     if (index < 0 || index >= state.imageLines.length) return;

//     final updatedLines = [...state.imageLines];
//     updatedLines[index] = updatedLines[index].copyWith(visionPhotoImg: file);
//     emitSafeState(state.copyWith(imageLines: updatedLines, isModified: true));

//     final itemIndex = updatedLines[index].itemIndex;
//     if (itemIndex == null) return;
//     if (state.uploadedItemIndexes.contains(itemIndex)) return;
//     if (!_itemFullyCaptured(updatedLines, itemIndex)) return;

//     await _autoUpdateVisionForItem(itemIndex);
//   }

//   bool _itemFullyCaptured(List<VisionPanelEntryLines> lines, int itemIndex) {
//     final itemLines = lines.where((l) => l.itemIndex == itemIndex).toList();
//     return itemLines.isNotEmpty &&
//         itemLines.every(
//           (l) =>
//               l.visionPhotoImg != null ||
//               (l.image != null && l.image!.isNotEmpty),
//         );
//   }

//   bool get allBoxesCaptured {
//     final printedIndexes = [
//       for (var i = 0; i < state.items.length; i++)
//         if (state.items[i].printCheck == 1) i,
//     ];
//     return printedIndexes.isNotEmpty &&
//         printedIndexes.every(state.uploadedItemIndexes.contains);
//   }

//   Future<void> _autoUpdateVisionForItem(int itemIndex) async {
//     final name = state.form.name;
//     if (name.isNull) return;
//     if (itemIndex < 0 || itemIndex >= state.items.length) return;

//     emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

//     final images = <String>[];
//     for (final line
//         in state.imageLines.where((l) => l.itemIndex == itemIndex)) {
//       final file = line.visionPhotoImg;
//       if (file == null || !await file.exists()) continue;

//       final compressedBytes = await FlutterImageCompress.compressWithFile(
//         file.path,
//         quality: 50,
//         minWidth: 1280,
//         minHeight: 1280,
//       );

//       images.add(
//         compressedBytes != null
//             ? 'data:image/png;base64,${base64Encode(compressedBytes)}'
//             : 'data:image/png;base64,${base64Encode(await file.readAsBytes())}',
//       );
//     }
//     final response = await repo.updateVision(name!, images: images);

//     response.fold(
//       (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
//       (msg) {
//         final updatedUploaded = {...state.uploadedItemIndexes, itemIndex};
//         final printedIndexes = [
//           for (var i = 0; i < state.items.length; i++)
//             if (state.items[i].printCheck == 1) i,
//         ];
//         final allDone = printedIndexes.every(updatedUploaded.contains);

//         emitSafeState(
//           state.copyWith(
//             isLoading: false,
//             isSuccess: true,
//             isUpdated: allDone,
//             uploadedItemIndexes: updatedUploaded,
//             successMsg: msg,
//           ),
//         );
//       },
//     );
//   }

//   bool get canAddNewItem => state.isUpdated;

//   void addItemRow() {
//     if (!canAddNewItem) return;
//     final updated = [...state.items, const VisionItems()];
//     emitSafeState(state.copyWith(items: updated, isModified: true));
//   }

//   Future<void> addItemFromDialog({
//     required String productType,
//     required int noOfBoxes,
//   }) async {
//     final isFirstItem = state.items.isEmpty;
//     if (!isFirstItem && !canAddNewItem) return;

//     final newItem = VisionItems(
//       productType: productType,
//       noOfBoxes: noOfBoxes,
//     );
//     final updatedItems = [...state.items, newItem];
//     emitSafeState(state.copyWith(items: updatedItems, isModified: true));


//     if (isFirstItem) return;

//     final name = state.form.name;
//     if (name.isNull || name!.isEmpty) return;

//     emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

//     final response = await repo.updateVision(
//       name,
//       productType: productType,
//       noOfBoxes: noOfBoxes,
//       images: const [],
//     );

//     response.fold(
//       (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
//       (msg) => emitSafeState(
//         state.copyWith(isLoading: false, isSuccess: true, successMsg: msg),
//       ),
//     );
//   }

//   Future<void> submit() async {
//     final name = state.form.name;
//     if (name.isNull) return;
//     if (!state.isUpdated) {
//       return _emitError(
//         const Pair('Capture and upload all box photos first', 0),
//       );
//     }

//     emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

//     final response = await repo.submitVision(name!);

//     response.fold(
//       (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
//       (msg) => emitSafeState(
//         state.copyWith(
//           isLoading: false,
//           isSuccess: true,
//           isModified: false,
//           successMsg: msg,
//           form: state.form.copyWith(docStatus: 1),
//           view: VisionView.completed,
//         ),
//       ),
//     );
//   }

//   void _emitError(Pair<String, int?> error) {
//     final failure = Failure(
//       error: error.first,
//       title: 'Missing Fields',
//       status: error.second,
//     );
//     emitSafeState(state.copyWith(error: failure, isLoading: false));
//   }

//   void errorHandled() {
//     emitSafeState(
//       state.copyWith(
//         error: null,
//         isLoading: false,
//         isSuccess: false,
//         successMsg: null,
//       ),
//     );
//   }
// }

// @freezed
// class CreateVisionPanelState with _$CreateVisionPanelState {
//   const factory CreateVisionPanelState({
//     required VisionModel form,
//     required bool isLoading,
//     required bool isSuccess,
//     @Default([]) List<VisionItems> items,
//     @Default([]) List<VisionPanelEntryLines> imageLines,
//     required VisionView view,
//     @Default(false) bool isModified,
//     @Default(false) bool isUpdated,
//     @Default(false) bool isPrintLoading,
//     @Default(<int>{}) Set<int> uploadedItemIndexes,
//     String? successMsg,
//     Failure? error,
//   }) = _CreateVisionPanelState;

//   factory CreateVisionPanelState.initial() {
//     return const CreateVisionPanelState(
//       form: VisionModel(),
//       items: [],
//       imageLines: [],
//       view: VisionView.create,
//       isLoading: false,
//       isSuccess: false,
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/data/vision_panel_repo.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';

part 'create_vision_panel.freezed.dart';

enum VisionView { create, edit, completed }

@injectable
class CreateVisionPanelCubit extends AppBaseCubit<CreateVisionPanelState> {
  CreateVisionPanelCubit(this.repo) : super(CreateVisionPanelState.initial());
  final VisionPanelRepo repo;

  void onSalesOrderSelected(String salesOrderNo) {
    shouldAskForConfirmation.value = true;
    final form = state.form.copyWith(salesOrderNo: salesOrderNo);
    emitSafeState(state.copyWith(form: form, isModified: true));
  }

  void updateItemField(int index, {String? productType, int? noOfBoxes}) {
    if (index < 0 || index >= state.items.length) return;
    final updated = [...state.items];
    var current = updated[index];

    updated[index] = current.copyWith(
      productType: productType ?? current.productType,
      noOfBoxes: noOfBoxes ?? current.noOfBoxes,
    );

    emitSafeState(state.copyWith(items: updated, isModified: true));
  }

  void addAllLines(List<VisionItems> lines) {
    emitSafeState(state.copyWith(items: lines));
  }

  void addAllEntryLines(List<VisionPanelEntryLines> lines) {
    emitSafeState(state.copyWith(imageLines: lines));
  }

  bool _lineHasPhoto(VisionPanelEntryLines line) =>
      line.visionPhotoImg != null ||
      (line.image != null && line.image!.isNotEmpty);

  /// Keep photo rows, and blank capture slots only for items not yet uploaded.
  bool _shouldKeepImageLine(
    VisionPanelEntryLines line,
    Set<int> uploaded,
  ) {
    if (_lineHasPhoto(line)) return true;
    if (line.itemIndex == null) return false;
    if (uploaded.contains(line.itemIndex)) return false;
    return true;
  }

  /// Map server entry lines onto printed items and only synthesize missing
  /// blank capture slots (never duplicate rows that already have photos).
  List<VisionPanelEntryLines> _resolveImageLinesForItems(
    List<VisionPanelEntryLines> serverLines,
    List<VisionItems> items,
  ) {
    final unassigned = [...serverLines]..sort((a, b) {
        final idxCompare = (a.idx ?? 0).compareTo(b.idx ?? 0);
        if (idxCompare != 0) return idxCompare;
        return (a.creation ?? '').compareTo(b.creation ?? '');
      });

    final resolved = <VisionPanelEntryLines>[];

    for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
      final item = items[itemIndex];
      if (item.printCheck != 1) continue;

      final boxCount = item.noOfBoxes ?? 0;
      var assigned = 0;

      for (var i = 0; i < unassigned.length && assigned < boxCount;) {
        final line = unassigned[i];
        final type = line.productType;
        final matchesType = type == null ||
            type.isEmpty ||
            type == item.productType;

        if (!matchesType) {
          i++;
          continue;
        }

        resolved.add(line.copyWith(itemIndex: itemIndex));
        unassigned.removeAt(i);
        assigned++;
      }

      while (assigned < boxCount) {
        resolved.add(
          VisionPanelEntryLines(
            idx: resolved.length + 1,
            productType: item.productType,
            itemIndex: itemIndex,
          ),
        );
        assigned++;
      }
    }

    for (final leftover in unassigned) {
      if (_lineHasPhoto(leftover)) {
        resolved.add(leftover);
      }
    }

    return resolved;
  }

  void initDetails(Object? entry) async {
    shouldAskForConfirmation.value = false;

    if (entry is VisionModel) {
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
        totalBoxes: entry.totalBoxes,
        creation: formattedStr,
      );

      final status = entry.docStatus;
      final isSubmitted = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status ?? 0),
        'Submitted',
      );
      final isCancelled = StringUtils.equalsIgnoreCase(
        StringUtils.docStatus(status ?? 0).trim(),
        'Cancelled',
      );

      final mode = (isSubmitted || isCancelled)
          ? VisionView.completed
          : VisionView.edit;

      emitSafeState(
        state.copyWith(
          form: updatedForm,
          view: mode,
          isModified: false,
          isLoading: true,
        ),
      );

      if (entry.name != null && entry.name!.isNotEmpty) {
        final linesResponse = await repo.fetchVisionLines(entry.name!);
        List<VisionItems> fetchedItems = state.items;
        linesResponse.fold(
          (failure) => null,
          (items) {
            fetchedItems = items;
            emitSafeState(state.copyWith(items: items));
          },
        );

        final entryLinesResponse =
            await repo.fetchVisionEntryLines(entry.name!);
        entryLinesResponse.fold(
          (failure) {
            emitSafeState(state.copyWith(isLoading: false));
          },
          (imageLines) {
            final resolvedLines =
                _resolveImageLinesForItems(imageLines, fetchedItems);

            final uploaded = <int>{};
            for (var i = 0; i < fetchedItems.length; i++) {
              final itemLines =
                  resolvedLines.where((l) => l.itemIndex == i).toList();
              final done = itemLines.isNotEmpty &&
                  itemLines.every(
                    (l) => (l.image != null && l.image!.isNotEmpty),
                  );
              if (done) uploaded.add(i);
            }

            final visibleLines = resolvedLines
                .where((l) => _shouldKeepImageLine(l, uploaded))
                .toList();

            emitSafeState(
              state.copyWith(
                isLoading: false,
                imageLines: visibleLines,
                isUpdated: _areAllItemsComplete(
                  items: fetchedItems,
                  uploaded: uploaded,
                ),
                uploadedItemIndexes: uploaded,
              ),
            );
          },
        );
      } else {
        emitSafeState(state.copyWith(isLoading: false));
      }
    }
  }

  void ensureLinePlaceholders(int boxCount) {
    if (state.imageLines.isNotEmpty || boxCount <= 0) return;
    emitSafeState(
      state.copyWith(
        imageLines: List.generate(
          boxCount,
          (i) => VisionPanelEntryLines(idx: i + 1),
        ),
      ),
    );
  }

  Future<void> createEntry() async {
    final salesOrder = state.form.salesOrderNo;
    if (salesOrder.isNull || salesOrder!.isEmpty) {
      return _emitError(const Pair('Select Sales Order No.', 0));
    }
    if (state.items.isEmpty) {
      return _emitError(
        const Pair('Select Product Type and No. of Boxes', 0),
      );
    }

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.createVision(state.form, state.items);

    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (r) {
        final docNo = r.second;
        shouldAskForConfirmation.value = false;

        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            successMsg: '${r.first}\n${r.second}',
            form: state.form.copyWith(name: docNo, docStatus: 0),
            view: VisionView.edit,
          ),
        );
      },
    );
  }

 Future<void> printItemSticker(int index) async {
    final docNo = state.form.name;
    if (docNo.isNull || docNo!.isEmpty) {
      return _emitError(const Pair('Document ID missing for print', 0));
    }
    if (index < 0 || index >= state.items.length) {
      return _emitError(const Pair('Invalid item selected for print', 0));
    }

    emitSafeState(
      state.copyWith(isPrintLoading: true, error: null, isSuccess: false),
    );

    try {
      final response = await repo.printVisionSticker(docNo);

      response.fold(
        (failure) {
          emitSafeState(
            state.copyWith(isPrintLoading: false, error: failure),
          );
        },
        (msg) {
          final updatedItems = [...state.items];
          final currentItem = updatedItems[index];

          if (currentItem.printCheck == 1) {
            emitSafeState(
              state.copyWith(
                isPrintLoading: false,
                isSuccess: true,
                successMsg: msg,
              ),
            );
            return;
          }

          final boxCount = currentItem.noOfBoxes ?? 0;
          updatedItems[index] = currentItem.copyWith(printCheck: 1);
          final uploaded = {...state.uploadedItemIndexes}..remove(index);
          final cleanExistingLines = state.imageLines
              .where((l) => _shouldKeepImageLine(l, uploaded))
              .toList();

          final newLines = List.generate(
            boxCount,
            (i) => VisionPanelEntryLines(
              idx: cleanExistingLines.length + i + 1,
              productType: currentItem.productType,
              itemIndex: index,
            ),
          );

          final combinedLines = [...cleanExistingLines, ...newLines];

          emitSafeState(
            state.copyWith(
              isPrintLoading: false,
              isSuccess: true,
              successMsg: msg,
              items: updatedItems,
              imageLines: combinedLines,
              uploadedItemIndexes: uploaded,
              isUpdated: false,
            ),
          );
        },
      );
    } catch (e) {
      final failure = e is Failure
          ? e
          : Failure(error: e.toString(), title: 'Print Failed', status: 0);
      emitSafeState(state.copyWith(isPrintLoading: false, error: failure));
    }
  }

  Future<void> onBoxPhotoCaptured(int index, File file) async {
    if (index < 0 || index >= state.imageLines.length) return;

    final updatedLines = [...state.imageLines];
    updatedLines[index] = updatedLines[index].copyWith(visionPhotoImg: file);
    emitSafeState(state.copyWith(imageLines: updatedLines, isModified: true));

    final itemIndex = updatedLines[index].itemIndex;
    if (itemIndex == null) return;
    if (state.uploadedItemIndexes.contains(itemIndex)) return;
    if (!_itemFullyCaptured(updatedLines, itemIndex)) return;

    await _autoUpdateVisionForItem(itemIndex);
  }

  bool _itemFullyCaptured(List<VisionPanelEntryLines> lines, int itemIndex) {
    final itemLines = lines.where((l) => l.itemIndex == itemIndex).toList();
    return itemLines.isNotEmpty &&
        itemLines.every(
          (l) =>
              l.visionPhotoImg != null ||
              (l.image != null && l.image!.isNotEmpty),
        );
  }

  bool get allBoxesCaptured {
    return _areAllItemsComplete();
  }

  int? get activeItemIndex {
    for (var i = state.items.length - 1; i >= 0; i--) {
      final item = state.items[i];
      if (item.printCheck == 1 && !state.uploadedItemIndexes.contains(i)) {
        return i;
      }
    }
    return null;
  }

  bool _areAllItemsComplete({
    List<VisionItems>? items,
    Set<int>? uploaded,
  }) {
    final currentItems = items ?? state.items;
    final currentUploaded = uploaded ?? state.uploadedItemIndexes;
    if (currentItems.isEmpty) return false;
    for (var i = 0; i < currentItems.length; i++) {
      if (currentItems[i].printCheck != 1) return false;
      if (!currentUploaded.contains(i)) return false;
    }
    return true;
  }

  Future<void> _autoUpdateVisionForItem(int itemIndex) async {
    final name = state.form.name;
    if (name.isNull) return;
    if (itemIndex < 0 || itemIndex >= state.items.length) return;

    final currentItem = state.items[itemIndex];
    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final images = <String>[];
    for (final line
        in state.imageLines.where((l) => l.itemIndex == itemIndex)) {
      final file = line.visionPhotoImg;
      if (file == null || !await file.exists()) continue;

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 50,
        minWidth: 1280,
        minHeight: 1280,
      );

      images.add(
        compressedBytes != null
            ? 'data:image/png;base64,${base64Encode(compressedBytes)}'
            : 'data:image/png;base64,${base64Encode(await file.readAsBytes())}',
      );
    }
    final response = await repo.updateVision(
      name!,
      productType: currentItem.productType,
      noOfBoxes: currentItem.noOfBoxes,
      images: images,
    );

    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (msg) {
        final updatedUploaded = {...state.uploadedItemIndexes, itemIndex};
        final allDone = _areAllItemsComplete(uploaded: updatedUploaded);
        final prunedLines = state.imageLines
            .where((l) => _shouldKeepImageLine(l, updatedUploaded))
            .toList();

        emitSafeState(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            isUpdated: allDone,
            uploadedItemIndexes: updatedUploaded,
            imageLines: prunedLines,
            successMsg: msg,
          ),
        );
      },
    );
  }

  bool get canAddNewItem {
    if (state.items.isEmpty) return true;
    final name = state.form.name;
    if (name == null || name.isEmpty) return false;
    return _areAllItemsComplete();
  }

  void addItemRow() {
    if (!canAddNewItem) return;
    final updated = [...state.items, const VisionItems()];
    emitSafeState(
      state.copyWith(items: updated, isModified: true, isUpdated: false),
    );
  }

  Future<void> addItemFromDialog({
    required String productType,
    required int noOfBoxes,
  }) async {
    final isFirstItem = state.items.isEmpty;
    if (!isFirstItem && !canAddNewItem) return;

    final newItem = VisionItems(
      productType: productType,
      noOfBoxes: noOfBoxes,
    );
    final updatedItems = [...state.items, newItem];
    emitSafeState(
      state.copyWith(
        items: updatedItems,
        isModified: true,
        isUpdated: false,
      ),
    );

    if (isFirstItem) return;

    final name = state.form.name;
    if (name.isNull || name!.isEmpty) return;

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.updateVision(
      name,
      productType: productType,
      noOfBoxes: noOfBoxes,
      images: const [],
    );

    response.fold(
      (l) => emitSafeState(
        state.copyWith(isLoading: false, error: l, isUpdated: false),
      ),
      (msg) => emitSafeState(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          successMsg: msg,
          isUpdated: false,
        ),
      ),
    );
  }

  Future<void> submit() async {
    final name = state.form.name;
    if (name.isNull) return;
    if (!_areAllItemsComplete()) {
      return _emitError(
        const Pair(
          'Print sticker and capture/upload all box photos first',
          0,
        ),
      );
    }

    emitSafeState(state.copyWith(isLoading: true, isSuccess: false));

    final response = await repo.submitVision(name!);

    response.fold(
      (l) => emitSafeState(state.copyWith(isLoading: false, error: l)),
      (msg) => emitSafeState(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          isModified: false,
          successMsg: '${msg.first}\n${msg.second}',
          form: state.form.copyWith(docStatus: 1),
          view: VisionView.completed,
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
class CreateVisionPanelState with _$CreateVisionPanelState {
  const factory CreateVisionPanelState({
    required VisionModel form,
    required bool isLoading,
    required bool isSuccess,
    @Default([]) List<VisionItems> items,
    @Default([]) List<VisionPanelEntryLines> imageLines,
    required VisionView view,
    @Default(false) bool isModified,
    @Default(false) bool isUpdated,
    @Default(false) bool isPrintLoading,
    @Default(<int>{}) Set<int> uploadedItemIndexes,
    String? successMsg,
    Failure? error,
  }) = _CreateVisionPanelState;

  factory CreateVisionPanelState.initial() {
    return const CreateVisionPanelState(
      form: VisionModel(),
      items: [],
      imageLines: [],
      view: VisionView.create,
      isLoading: false,
      isSuccess: false,
    );
  }
}