import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class HardwareWidget extends StatelessWidget {
  const HardwareWidget({
    super.key,
    required this.gateEntry,
    required this.onTap,
  });
  final GateManagementForm gateEntry;
  final VoidCallback onTap;
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
                    color: const Color(0xFFAB94FF).withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'QL',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFAB94FF),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gateEntry.name ?? '',
                                style: AppTextStyles.titleLarge(
                                  context,
                                ).copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    gateEntry.driverMobileNo ?? '',
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Text(
                                    gateEntry.vehicleNo ?? '',
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Color(0xFF163A6B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DFU.ddMMyyyyFromStr(
                                  gateEntry.gateeEntrydate ?? '',
                                ),
                                style: AppTextStyles.titleMedium(
                                  context,
                                  const Color(0xFF163A6B),
                                ).copyWith(color: const Color(0xFF163A6B)),
                              ),
                            ],
                          ),
                          DocStatusWidget(
                            status: StringUtils.docStatus(
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
