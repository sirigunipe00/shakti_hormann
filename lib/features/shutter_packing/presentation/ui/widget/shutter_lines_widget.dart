import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/consts/urls.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/create_shutter_cubit.dart/create_shutter_cubit.dart';
import 'package:shakti_hormann/widgets/packing_sticker_image_preview.dart';

class ShutterLinesWidget extends StatefulWidget {
  const ShutterLinesWidget({super.key});

  @override
  State<ShutterLinesWidget> createState() => _ShutterLinesWidgetState();
}

class _ShutterLinesWidgetState extends State<ShutterLinesWidget> {
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
    return BlocBuilder<CreateShutterCubit, CreateShutterState>(
      builder: (_, state) {
        final itemLines = state.lines.toList();
        final locked = state.isFrozen ||
            state.form.freezeQuantity == 1 ||
            state.form.palletQrPrinted == 1;
        final showDeleteColumn =
            state.form.docStatus != 1 &&
            !state.isFrozen &&
            state.form.freezeQuantity != 1;
        final canDelete = showDeleteColumn && !locked && state.view != ShutterView.completed;

        final columnWidths = <int, TableColumnWidth>{
          0: const FlexColumnWidth(0.8), // Sl No.
          1: const FlexColumnWidth(2.0), // Barcode
          2: const FlexColumnWidth(1.5), // Item Code
          3: const FlexColumnWidth(1.5), // Photos
          if (showDeleteColumn) 4: const FlexColumnWidth(1.0), 
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Table(
                columnWidths: columnWidths,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                children: [
                  // Header row.
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A3C6B),
                    ),
                    children: [
                      _headerCell('#'),
                      _headerCell('Shutter Barcode'),
                      _headerCell('Item Code'),
                      _headerCell('Photos'),
                      if (showDeleteColumn) _headerCell('Delete'),
                    ],
                  ),
                  // Data rows.
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
                        : (index.isEven ? Colors.white : const Color(0xFFF8FAFC));

                    return TableRow(
                      decoration: BoxDecoration(color: rowColor),
                      children: [
                        _dataCell(
                          Text(
                            slNo,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
                                    onTap: () =>
                                        _showPhotoDialog(context, photoUrls),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'N/A',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                        if (showDeleteColumn)
                          _dataCell(
                            Center(
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: canDelete
                                    ? () {
                                        context
                                            .read<CreateShutterCubit>()
                                            .removeLine(index);
                                        setState(() => selectedRows = []);
                                      }
                                    : null,
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget _dataCell(Widget child) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: child,
      ),
    );
  }

  static Widget _bodyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      softWrap: true,
      style: const TextStyle(fontSize: 12, color: Colors.black87),
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