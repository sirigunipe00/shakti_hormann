import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/core/utils/string_utils.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';

class VisionPanelWidget extends StatelessWidget {
  const VisionPanelWidget({
    super.key,
    required this.vision,
    required this.onTap,
  });

  final VisionModel vision;
  final VoidCallback onTap;

  String get _palletDisplayNumber {
    final raw = vision.name;
    if (raw == null || raw.isEmpty) return '---';

    final digits =
        RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) {
      return raw.substring(0, raw.length.clamp(0, 3)).toUpperCase();
    }

    final last = digits.last;
    return last.length > 4 ? last.substring(last.length - 4) : last.padLeft(4, '0');
  }

  int get _qty => vision.totalBoxes ?? 0;

  String get _qtyLabel {
    final n = _qty;
    return n == 1 ? '1 Box' : '$n Boxes';
  }

  @override
  Widget build(BuildContext context) {
    final so = vision.salesOrderNo?.trim() ?? '';
    final customer = vision.customerName?.trim() ?? '';
    final date = DFU.ddMMyyyyFromStr(vision.packingDate ?? '');

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
                                  vision.name ?? '',
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
                              if (customer.isNotEmpty) customer,
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
                    const Spacer(),
                    DocStatusWidget(
                      status: StringUtils.docStatus(vision.docStatus ?? 0),
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
