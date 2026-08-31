import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/core/utils/string_utils.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class FrameWidget extends StatelessWidget {
  const FrameWidget({
    super.key,
    required this.frame,
    required this.onTap,
  });

  final FramePacking frame;
  final VoidCallback onTap;

  String get _palletDisplayNumber {
    final raw = frame.name;
    if (raw == null || raw.isEmpty) return '---';

    final digits = RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) {
      return raw.substring(0, raw.length.clamp(0, 3)).toUpperCase();
    }

    return digits.last;
  }

  bool get _isFreezed => frame.freezeQuantity == 1;

  @override
  Widget build(BuildContext context) {
     final isUnallocated =
        (frame.allocationStatus ?? '').trim().toLowerCase() == 'unallocated';
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: AppColors.white),
        ),
        child: SpacedColumn(
          defaultHeight: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2957A4).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _palletDisplayNumber,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2957A4),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              frame.name ?? '',
                              style: AppTextStyles.titleLarge(context).copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_isFreezed) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF16A34A).withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.ac_unit_rounded,
                                    size: 12,
                                    color: Color(0xFF16A34A),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Quantity is Freezed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Sales Order: ${frame.salesOrder ?? ''}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 14,
                                color: Color(0xFF163A6B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DFU.ddMMyyyyFromStr(frame.packingDate ?? ''),
                                style: const TextStyle(
                                  color: Color(0xFF163A6B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if ((frame.palletNo ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          frame.palletNo!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                         Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isUnallocated
                                  ? const Color(0xFFFFF7E0)
                                  : const Color(0xFFF0F5FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isUnallocated
                                    ? const Color(0xFFFFD166)
                                    : const Color(0xFFD6E2F5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUnallocated
                                  ? Icons.info_outline_rounded
                                  : Icons.location_on_outlined,
                              size: 15,
                              color:
                                  isUnallocated
                                      ? const Color(0xFFB77900)
                                      : const Color(0xFF2957A4),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              frame.allocationStatus ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color:
                                    isUnallocated
                                        ? const Color(0xFF9A6700)
                                        : const Color(0xFF2957A4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 0.5,
                dashLength: 6.0,
                dashColor: Color.fromARGB(255, 184, 184, 192),
                dashGapLength: 4.0,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity : ${frame.totalUnitsOnPallet} Units',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                DocStatusWidget(
                  status: StringUtils.docStatus(frame.docStatus ?? 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}