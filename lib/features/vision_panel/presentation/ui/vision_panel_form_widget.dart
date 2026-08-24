import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/image_capture_table.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/product_table.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class VisionPanelFormWidget extends StatefulWidget {
  const VisionPanelFormWidget({super.key});

  @override
  State<VisionPanelFormWidget> createState() => _VisionPanelFormWidgetState();
}

class _VisionPanelFormWidgetState extends State<VisionPanelFormWidget> {
  SalesOrderForm? invoiceform;
  final ScrollController _scrollController = ScrollController();

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
      color: Colors.purple.shade100.withValues(alpha: 0.15),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          defaultHeight: 12,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SectionHeader(
                title: 'SO Details',
                assetIcon: 'assets/images/vehicleinvoicicon.svg',
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  BlocBuilder<PalletSales, PalletSalesState>(
                    builder: (_, state) {
                      final allData = state.maybeWhen(
                        orElse: () => <SalesOrderForm>[],
                        success: (data) => data,
                      );

                      final names = allData.toList();
                      if (invoiceform == null &&
                          newform.salesOrderNo != null &&
                          names.isNotEmpty) {
                        invoiceform = names.firstWhere(
                          (item) => item.name == newform.salesOrderNo,
                        );
                      }

                      return SearchDropDownList<SalesOrderForm>(
                        title: 'Sales Order No.',
                        hint: 'Select Order No',
                        key: const ValueKey('sales_order_dropdown'),
                        color: AppColors.black,
                        items: names,
                        readOnly: isLocked,
                        defaultSelection: invoiceform,
                        isloading: state.isLoading,
                        isRequired: true,
                        futureRequest: (query) async {
                          if (query.isEmpty) return names;
                          return names.where((item) {
                            final orderNo = item.name?.toLowerCase() ?? '';
                            final customer =
                                item.customerName?.toLowerCase() ?? '';
                            final search = query.toLowerCase();
                            return orderNo.contains(search) ||
                                customer.contains(search);
                          }).toList();
                        },
                        headerBuilder: (_, item, __) => Text(item.name ?? ''),
                           listItemBuilder:
                                      (_, item, __, ___) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sales Order: ${item.name ?? ''}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (item.customerName != null)
                                            Text(
                                              'Customer Name : ${item.customerName}',
                                            ),
                                          Text(
                                            'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} ',
                                          ),
                                        ],
                                      ),
                        onSelected: (selected) {
                          setState(() {
                            invoiceform = selected;
                          });
                          context
                              .cubit<CreateVisionPanelCubit>()
                              .onSalesOrderSelected(selected.name!);
                        },
                        focusNode: FocusNode(),
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
            const Center(child: Text('**Please Add Atleast One Product To Save the Record**',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
            const ProductSelectionTable(),

            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: SectionHeader(
                title: 'Box Details',
                assetIcon: 'assets/images/vehicleinvoicicon.svg',
              ),
            ),

            const ImageCaptureTable(),
          ],
        ),
      ),
    );
  }
}