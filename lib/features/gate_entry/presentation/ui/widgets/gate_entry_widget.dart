import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';
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

  String get _badgeLabel {
    final raw = gateEntry.name;
    if (raw == null || raw.isEmpty) return 'GE';
    final digits =
        RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) {
      return raw.substring(0, raw.length.clamp(0, 3)).toUpperCase();
    }
    return digits.last;
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = gateEntry.vehicleNo?.trim().isNotEmpty == true
        ? gateEntry.vehicleNo!
        : '—';

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
                      _badgeLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2957A4),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 13,
                                color: Color(0xFF163A6B),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                DFU.ddMMyyyyFromStr(
                                  gateEntry.gateEntryDate ?? '',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF163A6B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Vehicle: $vehicle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                        ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: BlocBuilder<Purchase, PurchaseState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        success: (data) {
                          context
                              .read<CreateGateEntryCubit>()
                              .addpurchseorders(purchaseorder: data);
                          final label = data
                              .map((po) => po.name ?? '')
                              .where((e) => e.isNotEmpty)
                              .join(', ');
                          return Text(
                            label.isNotEmpty ? label : 'PO: —',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF2957A4),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          );
                        },
                        orElse: () => const Text(
                          'PO: —',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF2957A4),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
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
