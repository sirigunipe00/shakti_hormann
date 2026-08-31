import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class StorageWidget extends StatelessWidget {
  const StorageWidget({
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

    return digits.last;
  }

  @override
  Widget build(BuildContext context) {
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
          defaultHeight: 6,
          // margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          margin: const EdgeInsets.fromLTRB(4, 14, 4, 4),
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
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            gateEntry.name ?? '',
                            style: AppTextStyles.titleLarge(context).copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Color(0xFF163A6B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DFU.ddMMyyyyFromStr(gateEntry.creation ?? ''),
                                style: AppTextStyles.titleMedium(
                                  context,
                                  const Color(0xFF163A6B),
                                ).copyWith(color: const Color(0xFF163A6B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Qty : ${gateEntry.totalQty.toString()}',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Sales Order + Doc Status now sit right below
                      // Total Qty, aligned with the rest of the text
                      // column instead of spanning the full card width.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Sales Order: ${gateEntry.salesOrders ?? ''}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DocStatusWidget(
                            status: StringUtils.framePackingStatus(
                              gateEntry.docStatus ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ],
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
