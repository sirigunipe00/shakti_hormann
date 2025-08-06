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

class GateExitWidget extends StatelessWidget {
  const GateExitWidget({
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
                  width: 75,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2957A4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/gateexiticon.png',
                      width: 75,
                      height: 80,
                      fit: BoxFit.fill,
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
                                gateExit.name ?? '',
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
                              color: Color(0xFF2957A4),
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
                            color: Color(0xFF163A6B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DFU.ddMMyyyyFromStr(gateExit.creationDate ?? ''),
                            style: AppTextStyles.titleMedium(
                              context,
                              Color(0xFF163A6B),
                            ).copyWith(
                              color:  Color(0xFF163A6B),
                            ),
                          ),
                          SizedBox(width: 125),
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
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: Color.fromARGB(255, 184, 184, 192),
                dashGapLength: 4.0,
              ),
            ),
            AppSpacer.empty(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gateExit.salesInvoice ?? '',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    color: Color(0xFF2957A4),
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
