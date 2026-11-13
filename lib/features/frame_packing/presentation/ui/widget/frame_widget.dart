import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/core/utils/string_utils.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';

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

    final digits =
        RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) {
      return raw.substring(0, raw.length.clamp(0, 3)).toUpperCase();
    }

    final last = digits.last;
    return last.length > 4 ? last.substring(last.length - 4) : last.padLeft(4, '0');
  }

  bool get _isFreezed => frame.freezeQuantity == 1;

  int get _qty => frame.totalUnitsOnPallet ?? 0;

  String get _qtyLabel {
    final n = _qty;
    return n == 1 ? '1 Unit' : '$n Units';
  }

  String get _palletLabel {
    final code = frame.palletCode?.trim() ?? '';
    if (code.isNotEmpty) return code;
    return frame.palletNo?.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isUnallocated =
        (frame.allocationStatus ?? '').trim().toLowerCase() == 'unallocated';
    final so = frame.salesOrder?.trim() ?? '';
    final pallet = _palletLabel;
    final date = DFU.ddMMyyyyFromStr(frame.packingDate ?? '');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E1446).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2957A4).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _palletDisplayNumber,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2957A4),
                            letterSpacing: 0.5,
                            fontFamily: 'Urbanist',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  frame.name ?? '',
                                  style:
                                      AppTextStyles.titleLarge(context).copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (date.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 12,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (so.isNotEmpty) 'SO: $so',
                              if (pallet.isNotEmpty) pallet,
                            ].join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          if (_isFreezed) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.ac_unit_rounded,
                                    size: 11,
                                    color: Color(0xFF16A34A),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Quantity Freezed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF16A34A),
                                      fontFamily: 'Urbanist',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.5,
                    dashLength: 6,
                    dashColor: Color(0xFFD0D4DD),
                    dashGapLength: 4,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _qtyLabel,
                        style: const TextStyle(
                          color: Color(0xFFC97800),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if ((frame.allocationStatus ?? '').isNotEmpty)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isUnallocated
                                ? const Color(0xFFFFF7E0)
                                : const Color(0xFFF0F5FF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isUnallocated
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
                                size: 13,
                                color: isUnallocated
                                    ? const Color(0xFFB77900)
                                    : const Color(0xFF2957A4),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  frame.allocationStatus ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Urbanist',
                                    color: isUnallocated
                                        ? const Color(0xFF9A6700)
                                        : const Color(0xFF2957A4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Spacer(),
                    DocStatusWidget(
                      status: StringUtils.docStatus(frame.docStatus ?? 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
