import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/create/logistic_request_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewLogisticRequest extends StatefulWidget {
  const NewLogisticRequest({super.key});

  @override
  State<NewLogisticRequest> createState() => _NewLogisticRequestState();
}

class _NewLogisticRequestState extends State<NewLogisticRequest> {
  SalesOrderForm? orderForm;

  @override
  Widget build(BuildContext context) {
    $logger.devLog('orderform......$orderForm');
    final logisticState = context.read<CreateLogisticCubit>().state;

    final newform = logisticState.form;
    final status = newform.docstatus;
    final name = newform.name;

    final isNew = logisticState.view == LogisticPlanningView.create;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Logistic Request',
                actionButton:
                    BlocBuilder<CreateLogisticCubit, CreateLogisticState>(
                      builder: (context, state) {
                        return AppButton(
                          isLoading: state.isLoading,
                          bgColor: const Color.fromARGB(255, 250, 193, 47),
                          textStyle: const TextStyle(color: AppColors.darkBlue,fontWeight: FontWeight.bold,fontSize: 15),
                          borderColor: Colors.grey,
                          label: state.view.toName(),
                          onPressed: () {
                            context.cubit<CreateLogisticCubit>().save();
                          },
                        );
                      },
                    ),

                dropdown: BlocBuilder<SalesOrderList, SalesOrderState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <SalesOrderForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<SalesOrderForm>(
                      key: UniqueKey(),
                      title: 'Sales Order No',
                      hint: 'Search Order No',
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      defaultSelection: orderForm,
                      futureRequest: (query) async {
                        return names.toList();
                      },
                      headerBuilder:
                          (_, item, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      listItemBuilder:
                          (_, item, __, ___) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                'Sales Order No: ${item.name ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.customerName != null)
                                Text(
                                  'Customer Name : ${item.customerName}' 
                                ),
                                Text('Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} '),

                              const Divider(height: 8),
                            ],
                          ),
                      onSelected: (selected) {
                        setState(() {
                          orderForm = selected;
                        });

                        context.cubit<CreateLogisticCubit>().onValueChanged(
                          salesOrder: selected.name,
                          plantName: selected.plantName,
                          shippingAddress1: selected.shippingAddress1,
                          shippingAddress2: selected.shippingAddress2,
                          country: selected.country,
                          states: selected.states,
                          city: selected.city,
                          pinCode: selected.pincode,
                        );
                      },
                      focusNode: FocusNode(),
                    );
                  },
                ),
                showScanner: false,
              )
              : TitleStatusAppBar(
                    title: name,
                    status: StringUtils.docStatus(status ?? 0),
                    actionButton:
                        newform.status == 'Draft'
                            ? BlocBuilder<CreateLogisticCubit,CreateLogisticState>(
                              builder: (context, state) {
                                return AppButton(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  width: 150,
                                  isLoading: state.isLoading,
                                  borderColor: Colors.grey,
                                  label: state.view.toName(),
                                  onPressed: () {
                                    context.cubit<CreateLogisticCubit>().save();
                                  },
                                );
                              },
                            )
                            : null,
                    onSubmit: () {},
                    onReject: () {},
                    pageMode: PageMode2.logisticRequest,
                    showRejectButton: false,
                    textColor: Colors.white,
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateLogisticCubit, CreateLogisticState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateLogisticCubit>().errorHandled();

              // final gateEntryFilters =
              //     context.read<LogisticPlanningFilterCubit>().state;
              // context.cubit<LogisticPlanningCubit>().fetchInitial(
              //   Pair(
              //     StringUtils.docStatuslogistic(gateEntryFilters.status),
              //     gateEntryFilters.query,
              //   ),
              // );
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
            context.cubit<CreateLogisticCubit>().errorHandled();
          }
        },
        child: LogisticPlanningFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
