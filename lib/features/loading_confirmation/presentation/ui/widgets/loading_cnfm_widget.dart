import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/doc_status_widget.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/app_spacer.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LoadingCnfmWidget extends StatelessWidget {
  const LoadingCnfmWidget({
    super.key,
    required this.loadingCnfmForm,
    required this.onTap,
  });

  final LoadingCnfmForm loadingCnfmForm;
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
                    color: const Color(0xFFAB94FF).withValues(alpha: 0.10),
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
                                loadingCnfmForm.name ?? '',
                                style: AppTextStyles.titleLarge(
                                  context,
                                ).copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                loadingCnfmForm.vehicleNumber ?? '',
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),

                          // Text(
                          //   '(SHM)',
                          //   style: AppTextStyles.titleLarge(context).copyWith(
                          //     color: const Color(0xFF2957A4),
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
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
                                color: Color.fromARGB(255, 17, 17, 226),
                              ),
                                 const SizedBox(width: 4),
                          Text(
                            DFU.ddMMyyyyFromStr(loadingCnfmForm.vehicleReportingEntryVreDate ?? ''),
                            style: const TextStyle(
                              color: Color(0xFF163A6B),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            ],
                          ),
                       
                      
                          // Row(
                          //   children: [
                          //     Image.asset('assets/images/timeicon.png'),
                          //      Text(
                          //   DFU.timeFromStr(loadingCnfmForm.creation ?? ''),
                          //   style: AppTextStyles.titleMedium(
                          //     context,
                          //     AppColors.darkBlue,
                          //   ).copyWith(color: const Color(0xFF53A5DF)),
                          // ),
                          //   ],
                          // ),
                         
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
            AppSpacer.empty(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loadingCnfmForm.linkedTransporterConfirmation ?? '',
                  style: const TextStyle(
                    color: Color(0xFF2957A4),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                
                DocStatusWidget(
                  status: loadingCnfmForm.docstatus == 1 ? 'Submitted' : loadingCnfmForm.status ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
