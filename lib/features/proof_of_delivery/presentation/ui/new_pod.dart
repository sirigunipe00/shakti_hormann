import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shakti_hormann/app/presentation/bloc/geo_permission/geo_permission_handler.dart';
import 'package:shakti_hormann/app/presentation/bloc/geo_permission/geo_permission_state.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/create_pd_cubit/create_pod_cubit.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/pod_filters_cubit.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/ui/pod_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewPod extends StatefulWidget {
  const NewPod({super.key});

  @override
  State<NewPod> createState() => _NewPodState();
}

class _NewPodState extends State<NewPod> {
  SalesInvoiceForm? invoiceform;
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final position = await determinePositionWithAlert(context);

    //   if (position != null && mounted) {

    //     context.read<CreatePodCubit>().onValueChanged(
    //       geoLatitude: position.latitude,
    //       geoLongitude: position.longitude,
    //     );

    //     debugPrint('📍 Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    //   }
    // });

    // final currentPosition =  Geolocator.getCurrentPosition();
    // print('currentPosition: ${currentPosition.latitude}');
    // print('currentPosition: ${currentPosition.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    final podState = context.read<CreatePodCubit>().state;

    final newform = podState.form;
    final status = newform.docStatus;
    final name = newform.name;
    final isCompleted = podState.view == PodView.completed;

    final isNew = podState.view == PodView.create;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Proof Of Delivery',
                actionButton: BlocBuilder<CreatePodCubit, CreatePodState>(
                  builder: (context, state) {
                    return AppButton(
                      isLoading: state.isLoading,
                      bgColor:
                          state.view == PodView.create
                              ? const Color.fromARGB(255, 250, 193, 47)
                              : AppColors.green,
                      textStyle: const TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      label: state.view.toName(),
                      borderColor: Colors.grey,
                      onPressed: () {
                        context.cubit<CreatePodCubit>().save();
                      },
                    );
                  },
                ),

                dropdown: BlocBuilder<SalesInvoiceList, SalesInvoiceState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <SalesInvoiceForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<SalesInvoiceForm>(
                      title: 'Invoice No',
                      hint: 'Search Invoice No',
                      key: UniqueKey(),
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      defaultSelection: invoiceform,
                      isloading: state.isLoading,
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
                                'Sales Invoice No: ${item.name ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.customerName != null)
                                Text('Customer Name : ${item.customerName}'),
                              Text('Order Date: ${(item.orderDate ?? '')} '),

                              const Divider(height: 8),
                            ],
                          ),
                      onSelected: (selected) {
                        setState(() {
                          invoiceform = selected;
                        });
                        context.cubit<CreatePodCubit>().onValueChanged(
                          salesInvoice: selected.name,
                          plantName: selected.plantName,
                          salesInvoiceDate: selected.orderDate,
                          customerName: selected.customerName,
                        );
                      },

                      focusNode: FocusNode(),
                    );
                  },
                ),

                showScanner: false,
              )
              : PreferredSize(
                preferredSize: const Size.fromHeight(250),
                child: TitleStatusAppBar(
                  title: '$name',
                  status: StringUtils.docStatus(status ?? 0),
                  onSubmit: () {},
                  onReject: () {},
                  actionButton:
                      (status == 1)
                          ? null
                          : BlocBuilder<CreatePodCubit, CreatePodState>(
                            builder: (context, state) {
                              return AppButton(
                                isLoading: state.isLoading,
                                label: state.view.toName(),
                                borderColor: Colors.grey,
                                onPressed: () {
                                  context.cubit<CreatePodCubit>().save();
                                },
                              );
                            },
                          ),
                  dropdown: BlocBuilder<SalesInvoiceList, SalesInvoiceState>(
                    builder: (_, state) {
                      final allData = state.maybeWhen(
                        orElse: () => <SalesInvoiceForm>[],
                        success: (data) => data,
                      );

                      final names = allData.toList();
                      final selectedOrders =
                          context
                              .watch<CreatePodCubit>()
                              .state
                              .form
                              .salesInvoice ??
                          '';
                      return SearchDropDownList<SalesInvoiceForm>(
                        title: 'Invoice No',
                        hint: 'Search Invoice No',
                        key: UniqueKey(),

                        color: AppColors.white,
                        items: names,
                        readOnly: status == 1,

                        defaultSelection: () {
                          if (names.isEmpty || selectedOrders.isNull) {
                            return null;
                          }

                          final selected = names.firstWhere(
                            (item) => item.name == selectedOrders,
                            orElse:
                                () => SalesInvoiceForm(name: selectedOrders),
                          );

                          return selected;
                        }(),

                        isloading: state.isLoading,
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
                                    // color: AppColors.white
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
                                  'Sales Invoice No: ${item.name ?? ''}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (item.customerName != null)
                                  Text('Customer Name : ${item.customerName}'),
                                Text('Order Date: ${(item.orderDate ?? '')} '),

                                const Divider(height: 8),
                              ],
                            ),
                        onSelected: (selected) {
                          setState(() {
                            invoiceform = selected;
                          });
                          context.cubit<CreatePodCubit>().onValueChanged(
                            salesInvoice: selected.name,
                            plantName: selected.plantName,
                            salesInvoiceDate: selected.orderDate,
                            customerName: selected.customerName,
                          );
                        },

                        focusNode: FocusNode(),
                      );
                    },
                  ),

                  showScanner: false,
                  textColor: Colors.white,
                  pageMode: PageMode2.proofOfDelivery,
                  showRejectButton: false,
                  isSubmitting: podState.isLoading,
                ),
              ),

      body: BlocListener<CreatePodCubit, CreatePodState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreatePodCubit>().errorHandled();

              final podFilters = context.read<PodFiltersCubit>().state;
              context.cubit<ProofOfDeliveryCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(podFilters.status),
                  podFilters.query,
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
            context.cubit<CreatePodCubit>().errorHandled();
          }
        },

        child: PodFormWidget(key: ValueKey(status)),
      ),
    );
    // );
  }
}
