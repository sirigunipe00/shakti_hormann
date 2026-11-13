import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/widgets/packing_sticker_image_preview.dart';

class FrameLinesWidget extends StatefulWidget {
  const FrameLinesWidget({super.key});

  @override
  State<FrameLinesWidget> createState() => _FrameLinesWidgetState();
}

class _FrameLinesWidgetState extends State<FrameLinesWidget> {
  List<int> selectedRows = [];

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFrameCubit, CreateFrameState>(
      builder: (_, state) {
        final itemLines = state.lines.toList();
        final locked = state.isFrozen ||
            state.form.freezeQuantity == 1 ||
            state.form.palletQrPrinted == 1;
        final showDeleteColumn =
            state.form.docStatus != 1 &&
            !state.isFrozen &&
            state.form.freezeQuantity != 1;
        final canDelete = showDeleteColumn && !locked && state.view != FrameView.completed;

        final columnWidths = <int, TableColumnWidth>{
          0: const FlexColumnWidth(0.8), // Sl No.
          1: const FlexColumnWidth(2.0), // Frame Barcode
          2: const FlexColumnWidth(1.5), // Item Code
          3: const FlexColumnWidth(1.5), // Photos
          if (showDeleteColumn) 4: const FlexColumnWidth(1.0),
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
                      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 32,
                            color: Color(0xFF9CA3AF),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No frame items yet',
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
                            _headerCell('Frame\nBarcode'),
                            _headerCell('Item\nCode'),
                            _headerCell('Photos'),
                            if (showDeleteColumn) _headerCell('Delete'),
                          ],
                        ),
                        ...List.generate(itemLines.length, (index) {
                          final item = itemLines[index];
                          final slNo = (index + 1).toString().padLeft(2, '0');
                          final photoUrls = resolvePhotoUrls(
                            item.shutterPhoto,
                            item.shutterPhotoImg,
                          );
                          final hasPhoto = photoUrls.isNotEmpty;
                          final isSelected = selectedRows.contains(index);
                          final rowColor = isSelected
                              ? const Color(0xFFEFF6FF)
                              : (index.isEven
                                  ? Colors.white
                                  : const Color(0xFFF8FAFD));

                          return TableRow(
                            decoration: BoxDecoration(color: rowColor),
                            children: [
                              _dataCell(
                                Center(
                                  child: Container(
                                    width: 26,
                                    height: 26,
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
                                        fontSize: 11,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _dataCell(_bodyText(item.shutterBarcodeQr ?? '—')),
                              _dataCell(_bodyText(item.itemCode ?? '—')),
                              _dataCell(
                                hasPhoto
                                    ? Center(
                                        child: _ViewButton(
                                          count: photoUrls.length,
                                          onTap: () => _showPhotoDialog(
                                            context,
                                            photoUrls,
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                          'N/A',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9CA3AF),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Urbanist',
                                          ),
                                        ),
                                      ),
                              ),
                              if (showDeleteColumn)
                                _dataCell(
                                  Center(
                                    child: Material(
                                      color: const Color(0xFFFDECEC),
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: canDelete
                                            ? () {
                                                context
                                                    .read<CreateFrameCubit>()
                                                    .removeLine(index);
                                                setState(
                                                  () => selectedRows = [],
                                                );
                                              }
                                            : null,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Color(0xFFD64545),
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
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
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        child: child,
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

  void _showPhotoDialog(BuildContext context, List<String> photoUrls) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PackingStickerGalleryPage(photoUrls: photoUrls),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.onTap, required this.count});
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          count > 1 ? 'View ($count)' : 'View',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
