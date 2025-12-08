import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LogisticRequestWidget extends StatelessWidget {
  const LogisticRequestWidget({
    super.key,
    required this.logistic,
    required this.onTap,
  });

  final LogisticPlanningForm logistic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    //     final statusText = logistic.docstatus == 2
    //     ? 'Cancelled'
    //     : logistic.status ?? '';

    // final formattedDateTime = formatDateTime(
    //   logistic.requestedDeliveryDate,
    //   logistic.requestedDeliveryTime,
    // );
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
          defaultHeight: 4,
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
                                logistic.name,
                                style: AppTextStyles.titleLarge(
                                  context,
                                ).copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // if ((logistic.transporterType ?? '') == 
                              //     'Hormann')
                                Text(
                                  [
                                        logistic.transporterName,
                                        logistic.transporterNAme2,
                                      ]
                                      .where((e) => e != null && e.isNotNull)
                                      .join(' - '),
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
                                  logistic.requestedDeliveryDate ?? '',
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
                              Image.asset('assets/images/timeicon.png'),
                              Text(
                                formatTime(logistic.requestedDeliveryTime) ??
                                    '',
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
                BlocBuilder<SalesOrders, SalesState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      success: (data) {
                        context.read<CreateLogisticCubit>().addsaleseorders(
                          salesorder: data,
                        );
                        return Expanded(
                          child: Wrap(
                            runSpacing: 2,
                            spacing: 2,
                            children: [
                              Text(
                                data
                                    .map((po) => po.name ?? '')
                                    .where((e) => e.isNotEmpty)
                                    .join(', '),
                                style: const TextStyle(
                                  color: Color(0xFF2957A4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      orElse: () => const SizedBox(),
                    );
                  },
                ),
                //                 Text(
                //   "$statusText – $formattedDateTime",
                //   style: AppTextStyles.titleLarge(context).copyWith(
                //     color: _getStatusColor(statusText),
                //     fontWeight: FontWeight.bold,
                //     fontSize: 12,
                //   ),
                // ),
                Text(
                  logistic.docstatus == 2 ? 'Cancelled' : logistic.status ?? '',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    color: _getStatusColor(
                      logistic.docstatus == 2
                          ? 'Cancelled'
                          : logistic.status ?? '',
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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

Color _getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'transporter confirmed':
      return Colors.green;
    case 'transporter rejected':
      return Colors.red;
    case 'cancelled':
      return Colors.red;
    case 'pending from transporter':
      return Colors.orange;
    default:
      return Colors.black;
  }
}

String? formatTime(String? backendTime) {
  if (backendTime == null || backendTime.isEmpty) return null;

  final parts = backendTime.split(':');
  if (parts.length < 2) return backendTime;

  return '${parts[0]}:${parts[1]}';
}

String formatDateTime(String? date, String? time) {
  if (date == null || date.isEmpty) return '';
  final formattedDate = DFU.ddMMyyyyFromStr(date);

  if (time == null || time.isEmpty) return formattedDate;

  final parts = time.split(':');
  if (parts.length < 2) return formattedDate;

  // Convert 24hr → 12hr
  int hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts[1];
  final suffix = hour >= 12 ? 'PM' : 'AM';
  hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return "$formattedDate ${hour.toString().padLeft(2, '0')}:$minute $suffix";
}
