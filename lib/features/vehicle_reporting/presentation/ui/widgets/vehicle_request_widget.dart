import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/core/utils/string_utils.dart';
import 'package:shakti_hormann/doc_status_widget.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate%20_exit_form.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class VehicleRequestWidget extends StatelessWidget {
  const VehicleRequestWidget({
    super.key,
    required this.gateExit,
    required this.onTap,
  });

  final GateExitForm gateExit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    print('gateExit.docStatu---:${gateExit.docStatus}');
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: AppColors.white, width: 2),
        ),
        child: SpacedColumn(
          defaultHeight: 4,
          margin: const EdgeInsets.all(8),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFAB94FF).withOpacity(0.30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "QL",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFAB94FF),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
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
                                "VRE-SHM-001",
                                style: AppTextStyles.titleLarge(
                                  context,
                                ).copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                gateExit.vehicleNo ?? '',
                                style: AppTextStyles.titleLarge(
                                  context,
                                ).copyWith(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            '(SHM)',
                            style: AppTextStyles.titleLarge(context).copyWith(
                              color: const Color.fromARGB(255, 12, 3, 120),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Color.fromARGB(255, 17, 17, 226),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DFU.ddMMyyyyFromStr(gateExit.creationDate ?? ''),
                            style: AppTextStyles.titleMedium(
                              context,
                              AppColors.darkBlue,
                            ).copyWith(
                              color: const Color.fromARGB(255, 28, 16, 205),
                            ),
                          ),
                          SizedBox(width: 120),
                          const Icon(
                            Icons.timelapse_rounded,
                            size: 14,
                            color: Color(0xFF53A5DF),
                          ),
                          Text(
                            DFU.timeFromStr(gateExit.creationDate ?? ''),
                            style: AppTextStyles.titleMedium(
                              context,
                              AppColors.darkBlue,
                            ).copyWith(color: Color(0xFF53A5DF)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 3.0,
                dashLength: 4.0,
                dashColor: AppColors.grey,
                dashGapLength: 4.0,
              ),
            ),
            AppSpacer.empty(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TC-SHM-001',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    color: const Color.fromARGB(255, 36, 11, 226),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DocStatusWidget(
                  status: StringUtils.docStatus(gateExit.docStatus ?? 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
