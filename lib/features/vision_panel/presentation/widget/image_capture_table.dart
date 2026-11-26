import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/packing_record_preview.dart';
import 'package:shakti_hormann/widgets/table_page_controls.dart';

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
          if (hasPhoto) {
            validEntries.add(MapEntry(i, line));
          } else if (line.itemIndex != null &&
              !uploaded.contains(line.itemIndex)) {
            validEntries.add(MapEntry(i, line));
          }
        }
        return _BoxDetailsTable(
          entries: validEntries,
          activeIndex: activeIndex,
          isSubmitted: isSubmitted,
          isUpdating: state.isLoading && !state.isUpdated && state.isModified,
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
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 90,
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
        builder: (_) => _ImageViewerPage(
          localFile: localFile,
          imageUrl: resolvedUrl,
          boxLabel: 'Box No: ${line.boxNo}',
        ),
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

class _BoxDetailsTable extends StatefulWidget {
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

  static const _headerBlue = Color(0xFF0E2A5C);
  static const _line = Color(0xFFE6EAF2);

  @override
  State<_BoxDetailsTable> createState() => _BoxDetailsTableState();
}

class _BoxDetailsTableState extends State<_BoxDetailsTable> {
  int _page = 0;

  bool _hasPhoto(VisionPanelEntryLines line) =>
      line.visionPhotoImg != null ||
      (line.image != null && line.image!.isNotEmpty);

  String _allocLabel(VisionPanelEntryLines line) {
    final status = (line.allocationStatus ?? 'Unallocated').trim();
    final zone = line.currentZone?.trim() ?? '';
    if (zone.isEmpty || zone == '-') return status;
    return '$status · $zone';
  }

  bool _isUnallocated(VisionPanelEntryLines line) {
    final s = (line.allocationStatus ?? 'Unallocated').toLowerCase();
    return s.contains('unallocated');
  }

  List<String> _photoUrls(VisionPanelEntryLines line) {
    final urls = <String>[];
    final local = line.visionPhotoImg;
    if (local != null) urls.add(local.path);
    final remote = line.image;
    if (remote != null && remote.isNotEmpty) {
      if (remote.startsWith('http://') || remote.startsWith('https://')) {
        urls.add(remote);
      } else {
        final uri = Uri.parse(Urls.baseUrl);
        final base =
            '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
        urls.add(remote.startsWith('/') ? '$base$remote' : '$base/$remote');
      }
    }
    return urls;
  }

  void _openPreview(VisionPanelEntryLines line, int absoluteIndex) {
    showPackingRecordPreview(
      context,
      data: PackingRecordPreviewData(
        recordNo: '# ${(absoluteIndex + 1).toString().padLeft(2, '0')}',
        chipSecondary: line.boxNo,
        chipTertiary: line.productType ?? line.boxCode,
        photoUrls: _photoUrls(line),
        details: [
          PackingRecordDetailRow(label: 'Box No.', value: line.boxNo ?? ''),
          PackingRecordDetailRow(label: 'Box Code', value: line.boxCode ?? ''),
          PackingRecordDetailRow(
            label: 'Product Type',
            value: line.productType ?? '',
          ),
          PackingRecordDetailRow(
            label: 'Allocation',
            value: line.allocationStatus ?? 'Unallocated',
          ),
          PackingRecordDetailRow(
            label: 'Zone',
            value: (line.currentZone ?? '').trim().isEmpty
                ? '-'
                : line.currentZone!.trim(),
          ),
          PackingRecordDetailRow(
            label: 'Added On',
            value: DFU.ddMMyyyyAmPmFromStr(line.creation ?? ''),
          ),
          PackingRecordDetailRow(
            label: 'Added By',
            value: line.owner ?? line.modifiedBy ?? '',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;
    final page = TablePageControls.clampPage(_page, entries.length);
    if (page != _page) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _page = page);
      });
    }
    final start = page * TablePageControls.defaultPageSize;
    final pageEntries = entries
        .skip(start)
        .take(TablePageControls.defaultPageSize)
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderRow(),
              if (entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Text(
                    'No box rows yet. Add a product item to capture photos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      fontFamily: 'Urbanist',
                    ),
                  ),
                )
              else
                for (var i = 0; i < pageEntries.length; i++)
                  _DataRow(
                    serial: (start + i + 1).toString().padLeft(2, '0'),
                    line: pageEntries[i].value,
                    isAlt: (start + i).isOdd,
                    isLast: i == pageEntries.length - 1,
                    allocLabel: _allocLabel(pageEntries[i].value),
                    isUnallocated: _isUnallocated(pageEntries[i].value),
                    photo: _buildPhotoCell(pageEntries[i]),
                    onPreview: () => _openPreview(
                      pageEntries[i].value,
                      start + i,
                    ),
                  ),
            ],
          ),
        ),
        TablePageControls(
          page: page,
          pageSize: TablePageControls.defaultPageSize,
          totalCount: entries.length,
          onPrevious: () => setState(() => _page = page - 1),
          onNext: () => setState(() => _page = page + 1),
        ),
      ],
    );
  }

  Widget _buildPhotoCell(MapEntry<int, VisionPanelEntryLines> entry) {
    final globalIndex = entry.key;
    final line = entry.value;

    if (_hasPhoto(line)) {
      return Material(
        color: const Color(0xFF16A34A),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => widget.onViewImage(line),
          borderRadius: BorderRadius.circular(8),
          child: const SizedBox(
            height: 32,
            width: 48,
            child: Center(
              child: Text(
                'View',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (widget.isSubmitted) {
      return const Text(
        '—',
        style: TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w700,
        ),
      );
    }

    final isRowActive =
        widget.activeIndex != null && line.itemIndex == widget.activeIndex;

    return SizedBox(
      width: 40,
      height: 34,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 34),
        icon: Icon(
          Icons.camera_alt_rounded,
          size: 20,
          color: isRowActive ? AppColors.darkBlue : Colors.grey.shade400,
        ),
        onPressed: isRowActive && !widget.isUpdating
            ? () => widget.onCapture(globalIndex)
            : null,
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _BoxDetailsTable._headerBlue,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: const Row(
        children: [
          SizedBox(width: 28, child: _HCell('#')),
          SizedBox(width: 48, child: _HCell('Box')),
          Expanded(flex: 3, child: _HCell('Box Code')),
          Expanded(flex: 2, child: _HCell('Alloc.')),
          SizedBox(width: 56, child: _HCell('Photo')),
          SizedBox(width: PackingRowActions.columnWidth, child: _HCell('')),
        ],
      ),
    );
  }
}

class _HCell extends StatelessWidget {
  const _HCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        fontFamily: 'Urbanist',
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.serial,
    required this.line,
    required this.isAlt,
    required this.isLast,
    required this.allocLabel,
    required this.isUnallocated,
    required this.photo,
    required this.onPreview,
  });

  final String serial;
  final VisionPanelEntryLines line;
  final bool isAlt;
  final bool isLast;
  final String allocLabel;
  final bool isUnallocated;
  final Widget photo;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAlt ? const Color(0xFFF8FAFD) : Colors.white,
      child: InkWell(
        onTap: onPreview,
        child: Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: _BoxDetailsTable._line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              serial,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2957A4),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              line.boxNo ?? '—',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E1446),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                line.boxCode ?? '—',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E1446),
                  fontFamily: 'Urbanist',
                  height: 1.25,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isUnallocated
                        ? const Color(0xFFFFF4E4)
                        : const Color(0xFFE8F8EF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    allocLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isUnallocated
                          ? const Color(0xFFC97800)
                          : const Color(0xFF15803D),
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Center(child: photo),
          ),
          SizedBox(
            width: PackingRowActions.columnWidth,
            child: PackingRowActions(onPreview: onPreview),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

class _ImageViewerPage extends StatelessWidget {
  const _ImageViewerPage({
    this.localFile,
    this.imageUrl,
    required this.boxLabel,
  });

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
        title: Text(boxLabel, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(minScale: 0.8, maxScale: 5, child: content),
      ),
    );
  }
}
