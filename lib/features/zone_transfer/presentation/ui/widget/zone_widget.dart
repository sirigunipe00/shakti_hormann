import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class ZoneWidget extends StatelessWidget {
  const ZoneWidget({
    super.key,
    required this.gateEntry,
    required this.onTap,
  });
  final Storage gateEntry;
  final VoidCallback onTap;
  String get _palletDisplayNumber {
    final raw = gateEntry.name;
    if (raw == null || raw.isEmpty) return '---';

    final digits =
        RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) {
      return raw.substring(0, raw.length.clamp(0, 3)).toUpperCase();
    }

    final last = digits.last;
    return last.length >= 3
        ? last.substring(last.length - 3)
        : last.padLeft(3, '0');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        elevation: 0.5,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Color(0xFFE8ECF4)),
        ),
        child: SpacedColumn(
          defaultHeight: 0,
          margin: const EdgeInsets.fromLTRB(10, 9, 10, 8),
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
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2957A4),
                        letterSpacing: 0.5,
                      ),
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
                              gateEntry.name ?? '',
                              style: AppTextStyles.titleLarge(context).copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DocStatusWidget(
                            status: StringUtils.framePackingStatus(
                              gateEntry.docStatus ?? 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Total Qty : ${gateEntry.totalQty.toString()}',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Color(0xFF163A6B),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            DFU.ddMMyyyyFromStr(gateEntry.creation ?? ''),
                            style: const TextStyle(
                              color: Color(0xFF163A6B),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    gateEntry.salesOrders ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
