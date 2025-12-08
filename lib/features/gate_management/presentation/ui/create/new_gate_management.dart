import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/create_gate_management_cubit.dart/gate_management_cubit.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/gate_management_filter.dart';
import 'package:shakti_hormann/features/gate_management/presentation/ui/create/gate_management_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewGateManagement extends StatefulWidget {
  const NewGateManagement({super.key});

  @override
  State<NewGateManagement> createState() => _NewGateManagementState();
}

class _NewGateManagementState extends State<NewGateManagement> {


 

  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateGateManagementCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    final isNew = gateEntryState.view == GateManagementView.create;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: isNew
              ?  SimpleAppBar(
                title: 'New Gate Management',
                  actionButton:
                    BlocBuilder<CreateGateManagementCubit, CreateGateManagementState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == GateManagementView.create
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
                            context.cubit<CreateGateManagementCubit>().save();
                          },
                        );
                      },
                    ),
              
                //  dropdown : BlocBuilder<PurchaseOrderList, PurchaseOrderState>(
                //   builder: (_, state) {
                //     final allData = state.maybeWhen(
                //       orElse: () => <PurchaseOrderForm>[],
                //       success: (data) => data,
                //     );

                //     final names = allData.toList();

                //     return SearchDropDownList<PurchaseOrderForm>(
                //       title: 'Purchase Order No',
                //       hint: 'Search Purchase No',
                //       color: AppColors.white,
                //       key: UniqueKey(),
                //       defaultSelection: purchaseOrderForm,
                //       items: names,
                //       isloading: state.isLoading,
                //       futureRequest: (query) async {
                //         if (query.isEmpty) return names;

                //         return names.where((item) {
                //           final orderNo = item.name?.toLowerCase() ?? '';
                //           final customer =
                //               item.supplierName?.toLowerCase() ?? '';
                //           final transporter =
                //               item.orderDate?.toLowerCase() ?? '';
                //           final search = query.toLowerCase();

                //           return orderNo.contains(search) ||
                //               customer.contains(search) ||
                //               transporter.contains(search);
                //         }).toList();
                //       },

                //       headerBuilder:
                //           (_, item, __) => Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [Text(item.name ?? '')],
                //           ),
                //       listItemBuilder:
                //           (_, item, __, ___) => Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 'Purchase Order No: ${item.name ?? ''}',
                //                 style: const TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               if (item.supplierName != null)
                //                 Text(
                //                   'Supplier Name : ${item.supplierName}',
                //                 ),
                //               Text('Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} '),
                //               const Divider(height: 8),
                //             ],
                //           ),

                //       onSelected: (selected) {
                //         setState(() {
                //           purchaseOrderForm = selected;
                //         });
                //         context.cubit<CreateGateEntryCubit>().onValueChanged(
                //           purchaseOrder: selected.name,
                //           plantName: selected.plantName,
                //           gateNumber: selected.gateNumber,

                //         );
                //       },
                //       focusNode: FocusNode(),
                //     );
                //   },
                // ),
                showScanner: false, 
              )
              : PreferredSize(
                preferredSize: const Size.fromHeight(250),
               
                      child: TitleStatusAppBar(
                        title: '$name',
                        status: StringUtils.docStatus(status ?? 0),
                        actionButton: (status == 1)
                                ? null
                                : BlocBuilder<CreateGateManagementCubit,CreateGateManagementState>(
                                  builder: (context, state) {
                                    return AppButton(
                                      borderColor: Colors.grey,
                                      isLoading: state.isLoading,
                                      label: gateEntryState.view.toName(),
                                      onPressed: () {
                                        context
                                            .cubit<CreateGateManagementCubit>()
                                            .save();
                                      },
                                    );
                                  },
                                ),
            
                        onSubmit: () {},
                        onReject: () {},
                        textColor: Colors.white,
                        pageMode: PageMode2.gateManagement,
                        showRejectButton: false,
                      ),
                    
              ) ,
      body: BlocListener<CreateGateManagementCubit, CreateGateManagementState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateGateManagementCubit>().errorHandled();

              final gateEntryFilters =
                  context.read<GateManagementFilter>().state;
              context.cubit<GateMangementCubit>().fetchInitial(
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
            context.cubit<CreateGateManagementCubit>().errorHandled();
          }
        },
        child: GateManagementFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
