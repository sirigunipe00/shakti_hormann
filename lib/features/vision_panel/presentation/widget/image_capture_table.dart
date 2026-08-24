import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class ImageCaptureTable extends StatefulWidget {
  const ImageCaptureTable({super.key});

  @override
  State<ImageCaptureTable> createState() => _ImageCaptureTableState();
}

class _ImageCaptureTableState extends State<ImageCaptureTable> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVisionPanelCubit, CreateVisionPanelState>(
      builder: (context, state) {
        final cubit = context.cubit<CreateVisionPanelCubit>();
        final newform = state.form;
        final isSubmitted = newform.docStatus == 1;

        final activeIndex = cubit.activeItemIndex;
        final uploaded = state.uploadedItemIndexes;

        final validEntries = <MapEntry<int, VisionPanelEntryLines>>[];
        for (var i = 0; i < state.imageLines.length; i++) {
          final line = state.imageLines[i];
          final hasPhoto = line.visionPhotoImg != null ||
              (line.image != null && line.image!.isNotEmpty);

          // Keep captured photos; drop blank leftover rows for uploaded items.
          if (hasPhoto) {
            validEntries.add(MapEntry(i, line));
          } else if (line.itemIndex != null &&
              !uploaded.contains(line.itemIndex)) {
            validEntries.add(MapEntry(i, line));
          }
        }

        // if (validEntries.isEmpty) {
        //   return const SizedBox.shrink();
        // }

        return _BoxDetailsTable(
          entries: validEntries,
          activeIndex: activeIndex,
          isSubmitted: isSubmitted,
          isUpdating:
              state.isLoading && cubit.allBoxesCaptured && !state.isUpdated,
          onCapture: (globalIndex) =>
              _captureBoxPhoto(context, cubit, globalIndex),
          onViewImage: (line) => _previewImage(context, line),
        );
      },
    );
  }

  Future<void> _captureBoxPhoto(
    BuildContext context,
    CreateVisionPanelCubit cubit,
    int globalIndex,
  ) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (picked != null) {
      await cubit.onBoxPhotoCaptured(globalIndex, File(picked.path));
    }
  }

  void _previewImage(BuildContext context, VisionPanelEntryLines line) {
    final localFile = line.visionPhotoImg;
    final remoteUrl = line.image;

    final String? resolvedUrl = (remoteUrl != null && remoteUrl.isNotEmpty)
        ? _resolveImageUrl(remoteUrl)
        : null;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            _ImageViewerPage(localFile: localFile, imageUrl: resolvedUrl,boxLabel: 'Box No: ${line.boxNo}'),
      ),
    );
  }

  String _resolveImageUrl(String raw) {
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    final uri = Uri.parse(Urls.baseUrl);
    final base =
        '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    return raw.startsWith('/') ? '$base$raw' : '$base/$raw';
  }
}

class _BoxDetailsTable extends StatelessWidget {
  const _BoxDetailsTable({
    required this.entries,
    required this.activeIndex,
    required this.isSubmitted,
    required this.isUpdating,
    required this.onCapture,
    required this.onViewImage,
  });

  final List<MapEntry<int, VisionPanelEntryLines>> entries;
  final int? activeIndex;
  final bool isSubmitted;
  final bool isUpdating;
  final void Function(int globalIndex) onCapture;
  final void Function(VisionPanelEntryLines line) onViewImage;

  bool _hasPhoto(VisionPanelEntryLines line) =>
      line.visionPhotoImg != null ||
      (line.image != null && line.image!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade300),
          verticalInside: BorderSide(color: Colors.grey.shade300),
        ),
        columnWidths: const {
          0: FixedColumnWidth(44),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.6),
        },
        children: [
          const TableRow(
            decoration: BoxDecoration(color: AppColors.darkBlue),
            children: [
              _HeaderCell('#'),
              _HeaderCell('Box No.'),
              _HeaderCell('Photo'),
            ],
          ),
          for (var displayIndex = 0;
              displayIndex < entries.length;
              displayIndex++)
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF3F4F8)),
              children: [
                _Cell(
                  child: Text(
                    (displayIndex + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C4A9E),
                    ),
                  ),
                ),
                _Cell(
                  child: Text(
                    entries[displayIndex].value.boxNo ?? '',
                  ),
                ),
                _Cell(child: _buildPhotoCell(entries[displayIndex])),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoCell(MapEntry<int, VisionPanelEntryLines> entry) {
    final globalIndex = entry.key;
    final line = entry.value;

    if (_hasPhoto(line)) {
      return InkWell(
        onTap: () => onViewImage(line),
        child: Container(
          width: double.infinity,
          color: const Color(0xFF5CB88F),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: const Text(
            'View Image',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (isSubmitted) {
      return const SizedBox();
    }
    final isRowActive = activeIndex != null && line.itemIndex == activeIndex;

    return IconButton(
      icon: Icon(
        Icons.camera_alt,
        color: isRowActive ? AppColors.black : Colors.grey.shade400,
      ),
      onPressed:
          isRowActive && !isUpdating ? () => onCapture(globalIndex) : null,
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Center(child: child),
    );
  }
}

class _ImageViewerPage extends StatelessWidget {
  const _ImageViewerPage({this.localFile, this.imageUrl, required this.boxLabel});

  final File? localFile;
  final String? imageUrl;
  final String boxLabel;

  @override
  Widget build(BuildContext context) {
    final String? url = imageUrl;

    Widget content;
    if (localFile != null) {
      content = Image.file(localFile!);
    } else if (url != null && url.isNotEmpty) {
      content = Image.network(
        url,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const CircularProgressIndicator(color: Colors.white),
        errorBuilder: (_, __, ___) => const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Unable to load image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      content = const Text(
        'No image available',
        style: TextStyle(color: Colors.white),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  Text(boxLabel, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(minScale: 0.8, maxScale: 5, child: content),
      ),
    );
  }
}