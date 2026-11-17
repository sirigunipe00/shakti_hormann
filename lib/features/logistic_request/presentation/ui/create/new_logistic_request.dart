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
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
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

  /// Asks the server for this order number. The sheet used to filter only the
  /// list already on the phone, so a Shorebird build with a different page
  /// size could not see the same sales order.
  Future<List<SalesOrderForm>> _searchSalesOrders(String query) {
    return LogisticPlanningBlocProvider.get().repo.fetchSalesOrder(query).then(
      (result) => result.fold((_) => <SalesOrderForm>[], (rows) => rows),
    );
  }

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
                          onPressed: () => _onPrimaryAction(context),
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
                      title: 'Sales Order No',
                      hint: 'Search Order No',
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      defaultSelection: orderForm,
                      serverSearch: _searchSalesOrders,

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
                                  width: 120,
                                  isLoading: state.isLoading,
                                  borderColor: Colors.grey,
                                  label: state.view.toName(),
                                  onPressed: () => _onPrimaryAction(context),
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
                          serverSearch: _searchSalesOrders,

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

      body: BlocBuilder<CreateLogisticCubit, CreateLogisticState>(
        builder: (context, overlayState) {
          return FormPageLoadingStack(
            isLoading: overlayState.isLoading,
            message: 'Saving document...',
            statusLabel: 'Processing...',
            child: BlocListener<CreateLogisticCubit, CreateLogisticState>(
              listener: (_, state) async {
                if (state.isSuccess && state.successMsg!.isNotNull) {
                  final isSubmitSuccess =
                      state.form.name == 'Pending From Transporter';
                  AppDialog.showSuccessDialog(
                    context,
                    title: 'Success',
                    content: state.successMsg.valueOrEmpty,
                    onTapDismiss: context.exit,
                  ).then((_) {
                    if (!context.mounted) return;
                    context.cubit<CreateLogisticCubit>().errorHandled();

                    if (!isSubmitSuccess) {
                      shouldAskForConfirmation.value = false;
                    }

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
        },
      ),
    );
  }

  Future<void> _onPrimaryAction(BuildContext context) async {
    final cubit = context.read<CreateLogisticCubit>();
    if (cubit.state.isLoading) return;

    // Create stays immediate; only "Send For Transporter" needs confirm.
    if (cubit.state.view != LogisticPlanningView.edit) {
      cubit.save();
      return;
    }

    final form = cubit.state.form;
    final soCount = form.salesOrder?.length ?? 0;
    final transporter = [
      form.transporterName,
      form.transporterNAme2,
    ].where((e) => e != null && e.trim().isNotEmpty).join(' · ');

    await AppDialog.askForConfirmation(
      context,
      title: 'Send to Transporter?',
      content:
          'Are you sure you want to send this logistic request to the transporter for confirmation? You can cancel and keep editing if something looks wrong.',
      buttonText: 'Keep Editing',
      confirmBtnText: 'Yes, Send',
      icon: Icons.local_shipping_rounded,
      iconBackground: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF1B7A3D),
      confirmIcon: Icons.send_rounded,
      confirmColor: const Color(0xFF1B7A3D),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (form.name.trim().isNotEmpty)
            _ConfirmMetaRow(label: 'Request', value: form.name),
          if (transporter.isNotEmpty) ...[
            const SizedBox(height: 6),
            _ConfirmMetaRow(label: 'Transporter', value: transporter),
          ],
          if (soCount > 0) ...[
            const SizedBox(height: 6),
            _ConfirmMetaRow(
              label: 'Sales Orders',
              value: '$soCount selected',
            ),
          ],
        ],
      ),
      onTapDismiss: () => Navigator.of(context).pop(false),
      onTapConfirm: () {
        Navigator.of(context).pop(true);
        cubit.save();
      },
    );
  }
}

class _ConfirmMetaRow extends StatelessWidget {
  const _ConfirmMetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0E1446),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ],
    );
  }
}
