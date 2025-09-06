import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_number_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/gate_entry_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/create/gate_entry_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/multi_selection.widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewGateEntry extends StatefulWidget {
  const NewGateEntry({super.key});

  @override
  State<NewGateEntry> createState() => _NewGateEntryState();
}

class _NewGateEntryState extends State<NewGateEntry> {
  List<PurchaseOrderForm> selectedPurchaseOrders = [];
  GateNumberForm? gateNumberForm;
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateGateEntryCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    final isNew = gateEntryState.view == GateEntryView.create;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Gate Entry',
                actionButton:
                    BlocBuilder<CreateGateEntryCubit, CreateGateEntryState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == GateEntryView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          isLoading: state.isLoading,
                          label: state.view.toName(),
                          onPressed: () {
                            context.cubit<CreateGateEntryCubit>().save();
                          },
                        );
                      },
                    ),

                dropdown: BlocBuilder<PurchaseOrderList, PurchaseOrderState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <PurchaseOrderForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchMultiDropDownList<PurchaseOrderForm>(
                      title: 'Purchase Order No',
                      hint: 'Search Purchase Order',
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      defaultSelection: selectedPurchaseOrders,
                      headerBuilder: (_, item, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },

                      listItemBuilder:
                          (_, item, __, ___) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Purchase No: ${item.name ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.supplierName != null)
                                Text('Supplier Name : ${item.supplierName}'),
                              Text(
                                'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} ',
                              ),
                              const Divider(height: 8),
                            ],
                          ),
                      onSelected: (selectedList) {
                        setState(() {
                          // multiple selections here
                          // example: save to purchaseOrderList
                          selectedPurchaseOrders = selectedList;

                          print('purchaseOrderList...:$selectedPurchaseOrders');
                          if (selectedPurchaseOrders.isNotEmpty) {
                            context
                                .cubit<CreateGateEntryCubit>()
                                .onValueChanged(
                                  purchaseOrder: selectedList
                                      .map((e) => e.name)
                                      .join(', '),
                                  plantName:
                                      selectedPurchaseOrders[0].plantName,
                                  gateNumber:
                                      selectedPurchaseOrders[0].gateNumber,
                                );
                          } else {
                            context
                                .cubit<CreateGateEntryCubit>()
                                .onValueChanged(
                                  purchaseOrder: '',
                                  plantName: '',
                                  gateNumber: '',
                                );
                          }
                        });
                      },
                      focusNode: FocusNode(),
                    );
                  },
                ),
                showScanner: false,
              )
              : TitleStatusAppBar(
                    title: '$name',
                    status: StringUtils.docStatus(status ?? 0),
                    actionButton:
                        (status == 1)
                            ? null
                            : BlocBuilder<CreateGateEntryCubit, CreateGateEntryState>
                            (builder: (context, state) {
                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label: gateEntryState.view.toName(),
                                  onPressed: () {
                                    context
                                        .cubit<CreateGateEntryCubit>()
                                        .save();
                                  },
                                );
                              },
                            ),
                    onSubmit: () {},
                    onReject: () {},
                    textColor: Colors.white,
                    pageMode: PageMode2.gateentry,
                    showRejectButton: false,
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateGateEntryCubit, CreateGateEntryState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateGateEntryCubit>().errorHandled();

              final gateEntryFilters =
                  context.read<GateEntryFilterCubit>().state;
              context.cubit<GateEntriesCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
              Navigator.pop(context, true);
              setState(() {});
            });
          }
          if (state.error.isNotNull) {
            await AppDialog.showErrorDialog(
              context,
              title: state.error!.title,
              content: state.error!.error,
              onTapDismiss: context.exit,
            );
            if (!context.mounted) return;
            context.cubit<CreateGateEntryCubit>().errorHandled();
          }
        },
        child: GateEntryFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
