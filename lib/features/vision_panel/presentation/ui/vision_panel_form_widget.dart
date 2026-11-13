import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/image_capture_table.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/product_table.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/vision_select_fields.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class VisionPanelFormWidget extends StatefulWidget {
  const VisionPanelFormWidget({super.key});

  @override
  State<VisionPanelFormWidget> createState() => _VisionPanelFormWidgetState();
}

class _VisionPanelFormWidgetState extends State<VisionPanelFormWidget> {
  SalesOrderForm? _selectedOrder;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateVisionPanelCubit>().state;
    final newform = formState.form;
    final isLocked = newform.name != null && newform.name!.isNotEmpty;

    final totalBoxes = formState.items
        .where(
          (item) =>
              item.productType != null && item.productType!.isNotEmpty,
        )
        .length;

    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: ShellInsets.scrollPadding(
          context,
          left: 16,
          right: 16,
          top: 8,
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          defaultHeight: 12,
          children: [
            const SectionHeader(
              title: 'SO Details',
              assetIcon: 'assets/images/vehicleinvoicicon.svg',
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF4)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0E1446).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  BlocBuilder<PalletSales, PalletSalesState>(
                    builder: (_, state) {
                      final allData = state.maybeWhen(
                        orElse: () => <SalesOrderForm>[],
                        success: (data) => data,
                      );

                      if (_selectedOrder == null &&
                          newform.salesOrderNo != null &&
                          allData.isNotEmpty) {
                        final match = allData.where(
                          (item) => item.name == newform.salesOrderNo,
                        );
                        if (match.isNotEmpty) {
                          _selectedOrder = match.first;
                        } else {
                          _selectedOrder = SalesOrderForm(
                            name: newform.salesOrderNo,
                            customerName: newform.customerName,
                          );
                        }
                      }

                      return VisionSalesOrderSelect(
                        orders: allData,
                        selected: _selectedOrder,
                        isLoading: state.isLoading,
                        locked: isLocked,
                        onSelected: (selected) {
                          setState(() => _selectedOrder = selected);
                          context
                              .cubit<CreateVisionPanelCubit>()
                              .onSalesOrderSelected(selected.name!);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  InputField(
                    key: ValueKey('total_boxes_$totalBoxes'),
                    readOnly: true,
                    isRequired: true,
                    title: 'Packed Box Quantity',
                    hintText: 'Enter Box Quantity',
                    borderColor: AppColors.grey,
                    initialValue: totalBoxes.toString(),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            if (newform.docStatus != 1 &&
                newform.docStatus != 0 &&
                formState.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Add at least one product type before saving.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            const ProductSelectionTable(),
            const SectionHeader(
              title: 'Box Details',
              assetIcon: 'assets/images/vehicleinvoicicon.svg',
            ),
            const ImageCaptureTable(),
          ],
        ),
      ),
    );
  }
}
