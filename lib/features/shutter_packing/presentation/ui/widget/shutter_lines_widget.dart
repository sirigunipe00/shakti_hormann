import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_lines.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/create_shutter_cubit.dart/create_shutter_cubit.dart';
import 'package:shakti_hormann/widgets/packing_record_preview.dart';
import 'package:shakti_hormann/widgets/table_page_controls.dart';

class ShutterLinesWidget extends StatefulWidget {
  const ShutterLinesWidget({super.key});

  @override
  State<ShutterLinesWidget> createState() => _ShutterLinesWidgetState();
}

class _ShutterLinesWidgetState extends State<ShutterLinesWidget> {
  int _page = 0;

  List<String> resolvePhotoUrls(
    List<String>? shutterPhoto,
    List<File>? shutterPhotoImg,
  ) {
    final urls = <String>[];

    if (shutterPhotoImg != null) {
      urls.addAll(shutterPhotoImg.map((f) => f.path));
    }

    if (shutterPhoto != null) {
      final base = Urls.baseUrl.replaceAll('/api', '');
      for (final photo in shutterPhoto) {
        if (photo.isEmpty) continue;
        urls.add(photo.startsWith('http') ? photo : '$base$photo');
      }
    }

    return urls;
  }

  PackingRecordPreviewData _previewData({
    required ShutterLines item,
    required int absoluteIndex,
    required List<String> photoUrls,
    required bool canDelete,
  }) {
    final barcode = item.shutterBarcodeQr ?? '';
    final itemCode = item.itemCode ?? '';
    final addedOn = DFU.ddMMyyyyAmPmFromStr(
      item.scanTime ?? item.creation ?? '',
    );
    return PackingRecordPreviewData(
      recordNo: '# ${(absoluteIndex + 1).toString().padLeft(2, '0')}',
      chipSecondary: barcode,
      chipTertiary: itemCode,
      canDelete: canDelete,
      photoUrls: photoUrls,
      details: [
        PackingRecordDetailRow(label: 'Shutter Barcode', value: barcode),
        PackingRecordDetailRow(label: 'Item Code', value: itemCode),
        if ((item.boxSerial ?? '').isNotEmpty)
          PackingRecordDetailRow(label: 'Box Serial', value: item.boxSerial!),
        PackingRecordDetailRow(label: 'Added On', value: addedOn),
        PackingRecordDetailRow(
          label: 'Added By',
          value: item.owner ?? item.modifiedBy ?? '',
        ),
      ],
    );
  }

  Future<void> _openPreview({
    required BuildContext context,
    required ShutterLines item,
    required int absoluteIndex,
    required List<String> photoUrls,
    required bool canDelete,
  }) {
    return showPackingRecordPreview(
      context,
      data: _previewData(
        item: item,
        absoluteIndex: absoluteIndex,
        photoUrls: photoUrls,
        canDelete: canDelete,
      ),
      onDelete: canDelete
          ? () async {
              await context.read<CreateShutterCubit>().removeLine(absoluteIndex);
            }
          : null,
    );
  }

  Future<void> _deleteLine(BuildContext context, int absoluteIndex) {
    return confirmAndDeletePackingRecord(
      context,
      onConfirm: () async {
        await context.read<CreateShutterCubit>().removeLine(absoluteIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShutterCubit, CreateShutterState>(
      builder: (_, state) {
        final itemLines = state.lines.toList();
        final locked = state.isFrozen ||
            state.form.freezeQuantity == 1 ||
            state.form.palletQrPrinted == 1;
        final canDelete = state.form.docStatus != 1 &&
            !state.isFrozen &&
            state.form.freezeQuantity != 1 &&
            !locked &&
            state.view != ShutterView.completed;

        final page = TablePageControls.clampPage(_page, itemLines.length);
        if (page != _page) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _page = page);
          });
        }
        final start = page * TablePageControls.defaultPageSize;
        final pageItems = itemLines
            .skip(start)
            .take(TablePageControls.defaultPageSize)
            .toList();

        // Fixed widths for # / photos / actions so eye+delete never overflow
        // on narrow phones. Barcode + item code share the remaining space.
        final columnWidths = <int, TableColumnWidth>{
          0: const FixedColumnWidth(34),
          1: const FlexColumnWidth(2.4),
          2: const FlexColumnWidth(1.2),
          3: const FixedColumnWidth(42),
          4: const FixedColumnWidth(PackingRowActions.columnWidth),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8ECF4)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0E1446).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: itemLines.isEmpty
                  ? const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 32,
                            color: Color(0xFF9CA3AF),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No shutter items yet',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0E1446),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Scan a sticker or upload an image to add lines.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    )
                  : Table(
                      columnWidths: columnWidths,
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                          color: Color(0xFFE6EAF2),
                          width: 1,
                        ),
                        verticalInside: BorderSide(
                          color: Color(0xFFE6EAF2),
                          width: 1,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFF0E2A5C),
                          ),
                          children: [
                            _headerCell('#'),
                            _headerCell('Shutter\nBarcode'),
                            _headerCell('Item\nCode'),
                            _headerCell('Photos'),
                            _headerCell('Actions'),
                          ],
                        ),
                        ...List.generate(pageItems.length, (index) {
                          final absoluteIndex = start + index;
                          final item = pageItems[index];
                          final slNo =
                              (absoluteIndex + 1).toString().padLeft(2, '0');
                          final photoUrls = resolvePhotoUrls(
                            item.shutterPhoto,
                            item.shutterPhotoImg,
                          );
                          final rowColor = absoluteIndex.isEven
                              ? Colors.white
                              : const Color(0xFFF8FAFD);

                          void openPreview() {
                            _openPreview(
                              context: context,
                              item: item,
                              absoluteIndex: absoluteIndex,
                              photoUrls: photoUrls,
                              canDelete: canDelete,
                            );
                          }

                          return TableRow(
                            decoration: BoxDecoration(color: rowColor),
                            children: [
                              _tappableCell(
                                onTap: openPreview,
                                child: Center(
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF4FB),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      slNo,
                                      style: const TextStyle(
                                        color: Color(0xFF2957A4),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _tappableCell(
                                onTap: openPreview,
                                child: _bodyText(item.shutterBarcodeQr ?? '—'),
                              ),
                              _tappableCell(
                                onTap: openPreview,
                                child: _bodyText(item.itemCode ?? '—'),
                              ),
                              _tappableCell(
                                onTap: openPreview,
                                child: PackingPhotoThumbCell(
                                  photoUrls: photoUrls,
                                  onTap: openPreview,
                                ),
                              ),
                              _dataCell(
                                PackingRowActions(
                                  onPreview: openPreview,
                                  canDelete: canDelete,
                                  onDelete: canDelete
                                      ? () => _deleteLine(
                                            context,
                                            absoluteIndex,
                                          )
                                      : null,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
            ),
            TablePageControls(
              page: page,
              pageSize: TablePageControls.defaultPageSize,
              totalCount: itemLines.length,
              onPrevious: () => setState(() => _page = page - 1),
              onNext: () => setState(() => _page = page + 1),
            ),
          ],
        );
      },
    );
  }

  static Widget _headerCell(String label) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Urbanist',
            height: 1.2,
          ),
        ),
      ),
    );
  }

  static Widget _dataCell(Widget child) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: child,
      ),
    );
  }

  static Widget _tappableCell({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: child,
        ),
      ),
    );
  }

  static Widget _bodyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 11,
        color: Color(0xFF0E1446),
        fontWeight: FontWeight.w600,
        fontFamily: 'Urbanist',
      ),
    );
  }
}
