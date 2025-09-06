import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/doc_status_widget.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/widgets/card_details.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class GateEntryWidget extends StatelessWidget {
  const GateEntryWidget({
    super.key,
    required this.gateEntry,
    required this.onTap,
    this.purchaseOrderForm,
  });

  final GateEntryForm gateEntry;
  final VoidCallback onTap;
  final PurchaseOrderForm? purchaseOrderForm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showGateEntryDialog(context, gateEntry),
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
                                    purchaseOrderForm?.supplier ?? '',
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
                                color: Color(0xFF163A6B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DFU.ddMMyyyyFromStr(
                                  gateEntry.gateEntryDate ?? '',
                                ),
                                style: AppTextStyles.titleMedium(
                                  context,
                                  const Color(0xFF163A6B),
                                ).copyWith(color: const Color(0xFF163A6B)),
                              ),
                            ],
                          ),

                          //         Row(
                          //           children: [
                          //          Image.asset(
                          //           'assets/images/timeicon.png'
                          //  ,
                          //          ),
                          //             Text(
                          //               DFU.timeFromStr(gateEntry.creationDate ?? ''),
                          //               style: AppTextStyles.titleMedium(
                          //                 context,
                          //                 AppColors.darkBlue,
                          //               ).copyWith(color: AppColors.litecyan),
                          //             ),
                          //           ],
                          //         ),
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
                BlocBuilder<Purchase, PurchaseState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      success: (data) {
                        context.read<CreateGateEntryCubit>().addpurchseorders(
                          purchaseorder: data,
                        );

                        return Expanded(
                          child: Wrap(
                            spacing: 2,

                            children:
                                data.map((po) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 2,
                                    ),

                                    child: Text(
                                      "${po.name}, ",
                                      style: const TextStyle(
                                        color: Color(0xFF2957A4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        );
                      },
                      orElse: () => const SizedBox(),
                    );
                  },
                ),

                DocStatusWidget(
                  status: StringUtils.docStatus(gateEntry.docStatus ?? 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
