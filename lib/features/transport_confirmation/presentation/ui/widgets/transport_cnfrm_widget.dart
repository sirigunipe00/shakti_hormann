import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class TransportCnfrmWidget extends StatelessWidget {
  const TransportCnfrmWidget({
    super.key,
    required this.transport,
    required this.onTap,
  });

  final TransportConfirmationForm transport;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
   
 
    return GestureDetector(
      onTap: (transport.status == 'Pending From Transporter') ? onTap : null,
      child: Card(
        color: Colors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: AppColors.white),
        ),
        child: SpacedColumn(
          defaultHeight: 4,
          margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB94FF).withOpacity(0.30),
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
                                transport.name,
                                style: AppTextStyles.titleLarge(
                                  context,
                                ).copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                transport.vehicleNumber ?? '',
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
                              color: const Color.fromARGB(255, 12, 3, 120),
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
                                  transport.creation ?? '',
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
                              const Icon(
                                Icons.alarm_add,
                                size: 14,
                                color: Color(0xFF53A5DF),
                              ),
                              Text(
                                DFU.timeFromStr(transport.creation ?? ''),
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
              padding: EdgeInsets.symmetric(vertical: 8.0),
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
                  transport.name,
                  style:const TextStyle(
                    color: Color(0xFF2957A4),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                   Text(
                  transport.status ?? '',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    color: _getStatusColor(transport.status),
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
    case 'pending from transporter':
      return Colors.orange; 
    default:
      return Colors.black; 
  }
}
