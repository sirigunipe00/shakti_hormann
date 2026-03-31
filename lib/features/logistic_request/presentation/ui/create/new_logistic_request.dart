import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/create/logistic_request_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/multi_selection.widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewLogisticRequest extends StatefulWidget {
  const NewLogisticRequest({super.key});

  @override
  State<NewLogisticRequest> createState() => _NewLogisticRequestState();
}

class _NewLogisticRequestState extends State<NewLogisticRequest> {
  List<SalesOrderForm> orderForm = [];
  SalesOrderForm? salesOrderForm;

  @override
  Widget build(BuildContext context) {
    final logisticState = context.read<CreateLogisticCubit>().state;

    final newform = logisticState.form;
    final status = newform.docstatus;
    final name = newform.name;
    final isCompleted =
        logisticState.view == LogisticPlanningView.completed ||
        (logisticState.form.docstatus == 1 ||
            logisticState.form.status == 'Pending From Transporter');

    final isNew = logisticState.view == LogisticPlanningView.create;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                          bgColor:
                              state.view == LogisticPlanningView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          borderColor: Colors.grey,
                          label: state.view.toName(),
                          onPressed: () {
                            final cubit = context.read<CreateLogisticCubit>();
                            if (!cubit.state.isLoading) {
                              cubit.save();
                            }
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

                    return SearchMultiDropDownList<SalesOrderForm>(
                      key: UniqueKey(),
                      title: 'Sales Order No',
                      hint: 'Search Order No',
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      defaultSelection: orderForm,
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
                                Text('Customer Name : ${item.customerName}'),
                              Text(
                                'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} ',
                              ),

                              const Divider(height: 8),
                            ],
                          ),
                      onSelected: (selectedList) {
                        setState(() {
                          orderForm = selectedList;

                          if (orderForm.isNotEmpty) {
                            final first = selectedList[0];
                            final List<SalesOrder> salesOrders =
                                selectedList
                                    .where((e) => e.name != null)
                                    .map(
                                      (e) => SalesOrder(
                                        name: e.name,
                                        city: e.city,
                                        state: e.states,
                                      ),
                                    )
                                    .toList();

                            context.cubit<CreateLogisticCubit>().onValueChanged(
                              salesOrder: salesOrders,

                              plantName: first.plantName ?? '',
                              shippingAddress1: first.shippingAddress1 ?? '',
                              shippingAddress2: first.shippingAddress2 ?? '',
                              states: first.states ?? '',
                              city: first.city ?? '',
                              pinCode: first.pincode ?? '',
                              country: first.country ?? '',
                            );
                          } else {
                            context.cubit<CreateLogisticCubit>().onValueChanged(
                              salesOrder: [],
                              plantName: '',
                              shippingAddress1: '',
                              shippingAddress2: '',
                              states: '',
                              city: '',
                              pinCode: '',
                              country: '',
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
              : PreferredSize(
                preferredSize: const Size.fromHeight(250),
                child: BlocListener<SalesOrders, SalesState>(
                  listener: (context, lstate) {
                    lstate.maybeWhen(
                      orElse: () {},
                      success: (data) {
                        context.read<CreateLogisticCubit>().addsaleseorders(
                          salesorder: data,
                        );
                      },
                    );
                  },
                  child: TitleStatusAppBar(
                    title: name,
                    status: StringUtils.docStatus(status ?? 0),
                    actionButton:
                        newform.status == 'Draft'
                            ? BlocBuilder<
                              CreateLogisticCubit,
                              CreateLogisticState
                            >(
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
                    dropdown: BlocBuilder<SalesOrderList, SalesOrderState>(
                      builder: (_, state) {
                        final allData = state.maybeWhen(
                          orElse: () => <SalesOrderForm>[],
                          success: (data) => data,
                        );

                        final names = allData.toList();
                        final selectedOrders =
                            context
                                .watch<CreateLogisticCubit>()
                                .state
                                .form
                                .salesOrder ??
                            [];

                        return SearchMultiDropDownList<SalesOrderForm>(
                          key: UniqueKey(),
                          title: 'Sales Order No',
                          hint: 'Search Order No',
                          color: AppColors.white,
                          items: names,
                          readOnly: isCompleted,

                          isloading: state.isLoading,

                          defaultSelection:
                              names
                                  .where(
                                    (item) => selectedOrders.any(
                                      (so) => so.name == item.name,
                                    ),
                                  )
                                  .toList(),
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

                          headerBuilder:
                              (_, item, __) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isCompleted
                                              ? AppColors.white
                                              : AppColors.black,
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
                                      'Customer Name : ${item.customerName}',
                                    ),
                                  Text(
                                    'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} ',
                                  ),

                                  const Divider(height: 8),
                                ],
                              ),
                          onSelected: (selectedList) {
                            setState(() {
                              orderForm = selectedList;

                              if (orderForm.isNotEmpty) {
                                final first = selectedList[0];
                                final List<SalesOrder> salesOrders =
                                    selectedList
                                        .where((e) => e.name != null)
                                        .map(
                                          (e) => SalesOrder(
                                            name: e.name,
                                            state: e.states,
                                            city: e.city,
                                          ),
                                        )
                                        .toList();

                                context
                                    .cubit<CreateLogisticCubit>()
                                    .onValueChanged(
                                      salesOrder: salesOrders,

                                      plantName: first.plantName ?? '',
                                      shippingAddress1:
                                          first.shippingAddress1 ?? '',
                                      shippingAddress2:
                                          first.shippingAddress2 ?? '',
                                      states: first.states ?? '',
                                      city: first.city ?? '',
                                      pinCode: first.pincode ?? '',
                                      country: first.country ?? '',
                                    );
                              } else {
                                context
                                    .cubit<CreateLogisticCubit>()
                                    .onValueChanged(
                                      salesOrder: [],
                                      plantName: '',
                                      shippingAddress1: '',
                                      shippingAddress2: '',
                                      states: '',
                                      city: '',
                                      pinCode: '',
                                      country: '',
                                    );
                              }
                            });
                          },

                          focusNode: FocusNode(),
                        );
                      },
                    ),
                    onSubmit: () {},
                    onReject: () {},
                    pageMode: PageMode2.logisticRequest,
                    showRejectButton: false,
                    textColor: Colors.white,
                  ),
                ),
              ),

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
        child: LogisticPlanningFormWidget(
          key: ValueKey(status),
          orderForm: orderForm,
        ),
      ),
    );
  }
}
