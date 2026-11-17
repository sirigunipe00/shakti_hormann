import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/packing_sticker_image_preview.dart';

class PackingRecordDetailRow {
  const PackingRecordDetailRow({required this.label, required this.value});

  final String label;
  final String value;
}

class PackingRecordPreviewData {
  const PackingRecordPreviewData({
    required this.recordNo,
    required this.details,
    this.chipSecondary,
    this.chipTertiary,
    this.photoUrls = const [],
    this.canDelete = false,
    this.photosTitle = 'Photos',
  });

  final String recordNo;
  final String? chipSecondary;
  final String? chipTertiary;
  final List<PackingRecordDetailRow> details;
  final List<String> photoUrls;
  final bool canDelete;
  final String photosTitle;
}

/// Compact eye + optional delete actions for packing line tables.
class PackingRowActions extends StatelessWidget {
  const PackingRowActions({
    super.key,
    required this.onPreview,
    this.onDelete,
    this.canDelete = false,
  });

  final VoidCallback onPreview;
  final VoidCallback? onDelete;
  final bool canDelete;

  /// Width reserved for eye + delete in packing tables (avoids flex overflow).
  static const double columnWidth = 72;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionIcon(
            color: const Color(0xFFE8F0FE),
            iconColor: const Color(0xFF2563EB),
            icon: Icons.visibility_outlined,
            onTap: onPreview,
          ),
          if (canDelete && onDelete != null) ...[
            const SizedBox(width: 4),
            _ActionIcon(
              color: const Color(0xFFFDECEC),
              iconColor: const Color(0xFFD64545),
              icon: Icons.delete_outline_rounded,
              onTap: onDelete!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  final Color color;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, color: iconColor, size: 16),
        ),
      ),
    );
  }
}

Future<void> confirmAndDeletePackingRecord(
  BuildContext context, {
  required Future<void> Function() onConfirm,
  String title = 'Delete Record?',
  String content =
      'This record will be removed from the packing list. This cannot be undone.',
}) async {
  final ok = await AppDialog.confirm(
    context,
    title: title,
    content: content,
    cancelText: 'Cancel',
    confirmText: 'Delete',
    icon: Icons.delete_outline_rounded,
    iconBackground: const Color(0xFFFDECEC),
    iconColor: const Color(0xFFD64545),
    confirmIcon: Icons.delete_outline_rounded,
    confirmColor: const Color(0xFFD64545),
  );
  if (ok == true) {
    await onConfirm();
  }
}

Future<void> showPackingRecordPreview(
  BuildContext context, {
  required PackingRecordPreviewData data,
  Future<void> Function()? onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _PackingRecordPreviewSheet(
        data: data,
        onDelete: onDelete == null
            ? null
            : () async {
                Navigator.of(sheetContext).pop();
                await confirmAndDeletePackingRecord(
                  context,
                  onConfirm: onDelete,
                );
              },
      );
    },
  );
}

class _PackingRecordPreviewSheet extends StatelessWidget {
  const _PackingRecordPreviewSheet({
    required this.data,
    this.onDelete,
  });

  final PackingRecordPreviewData data;
  final Future<void> Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final photos = data.photoUrls;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Record Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        color: Color(0xFF0E1446),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Chip(
                          label: data.recordNo,
                          bg: const Color(0xFFE8F0FE),
                          fg: const Color(0xFF2563EB),
                        ),
                        if ((data.chipSecondary ?? '').isNotEmpty)
                          _Chip(
                            label: data.chipSecondary!,
                            bg: const Color(0xFFF3F4F6),
                            fg: const Color(0xFF374151),
                          ),
                        if ((data.chipTertiary ?? '').isNotEmpty)
                          _Chip(
                            label: data.chipTertiary!,
                            bg: const Color(0xFFFFF4E4),
                            fg: const Color(0xFFC97800),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFD),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8ECF4)),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < data.details.length; i++) ...[
                            _DetailLine(
                              label: data.details[i].label,
                              value: data.details[i].value,
                            ),
                            if (i != data.details.length - 1)
                              const Divider(height: 18, color: Color(0xFFE6EAF2)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '${data.photosTitle} (${photos.length})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Urbanist',
                            color: Color(0xFF0E1446),
                          ),
                        ),
                        const Spacer(),
                        if (photos.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => PackingStickerGalleryPage(
                                    photoUrls: photos,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'View Fullscreen',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (photos.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE8ECF4)),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFF9CA3AF),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'No photos uploaded',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: 88,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: photos.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => PackingStickerGalleryPage(
                                      photoUrls: photos,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 88,
                                  height: 88,
                                  child: PackingStickerPreviewImage(
                                    path: photos[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12 + bottom),
              child: Row(
                children: [
                  if (data.canDelete && onDelete != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onDelete?.call(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD64545),
                          side: const BorderSide(color: Color(0xFFD64545)),
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Delete Record',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ),
                  if (data.canDelete && onDelete != null)
                    const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E7EB),
                        foregroundColor: const Color(0xFF111827),
                        elevation: 0,
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.bg,
    required this.fg,
  });

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(
              color: Color(0xFF0E1446),
              fontWeight: FontWeight.w700,
              fontSize: 13,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ],
    );
  }
}

/// Small photo cell used in compact packing tables.
class PackingPhotoThumbCell extends StatelessWidget {
  const PackingPhotoThumbCell({
    super.key,
    required this.photoUrls,
    this.onTap,
  });

  final List<String> photoUrls;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 18,
          color: Color(0xFF9CA3AF),
        ),
      );
    }

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 28,
                height: 28,
                child: PackingStickerPreviewImage(
                  path: photoUrls.first,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (photoUrls.length > 1)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${photoUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
