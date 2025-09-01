import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/core/utils/string_utils.dart';
import 'package:shakti_hormann/doc_status_widget.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
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
          margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 4
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2957A4).withValues(alpha:0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/gateexiticon.png',
                     
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
                             const SizedBox(height: 5),
                              Text(
                                gateExit.vehicleNo ?? '',
                                style:const TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            '(SHM)',
                            style: AppTextStyles.titleLarge(context).copyWith(
                              color: const Color(0xFF2957A4),
                              fontWeight: FontWeight.bold,
                            ),
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
                                Icons.calendar_month,
                                size: 14,
                                color: Color(0xFF163A6B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DFU.ddMMyyyyFromStr(
                                  gateExit.creationDate ?? '',
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF163A6B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                             Image.asset(
                            'assets/images/timeicon.png'
                   ,
                           ),
                              Text(
                                DFU.timeFromStr(gateExit.creationDate ?? ''),
                                style: AppTextStyles.titleMedium(
                                  context,
                                  AppColors.darkBlue,
                                ).copyWith(color: AppColors.litecyan),
                              ),
                            ],
                          ),
                        ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gateExit.salesInvoice ?? '',
                  style: const TextStyle(
                    color: Color(0xFF2957A4),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
