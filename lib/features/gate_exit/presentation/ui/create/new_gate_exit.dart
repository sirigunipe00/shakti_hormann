import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/create/gate_exit_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
import 'package:shakti_hormann/widgets/inputs/multi_selection.widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class NewGateExit extends StatefulWidget {
  const NewGateExit({super.key});

  @override
  State<NewGateExit> createState() => _NewGateExitState();
}

class _NewGateExitState extends State<NewGateExit> {
  SalesInvoiceForm? invoiceform;
  List<SalesInvoiceForm> selectedSalesInvoices = [];
  List<Sales> dataorders = [];

  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateGateExitCubit>().state;

    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;


    final isNew = gateEntryState.view == GateExitView.create;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Gate Exit',
                actionButton:
                    BlocBuilder<CreateGateExitCubit, CreateGateExitState>(
                      builder: (context, state) {
                        return AppButton(
                          isLoading: state.isLoading,
                          bgColor:
                              state.view == GateExitView.create
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
                            context.cubit<CreateGateExitCubit>().save();
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

                    return SearchMultiDropDownList<SalesInvoiceForm>(
                      title: 'Invoice No',
                      hint: 'Search Invoice No',
                      key: UniqueKey(),
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      defaultSelection: selectedSalesInvoices,
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
                              Text(
                                'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate ?? '')} ',
                              ),

                              const Divider(height: 8),
                            ],
                          ),
                      onSelected: (selected) {
                        setState(() {
                          selectedSalesInvoices = selected;
                          if (selectedSalesInvoices.isNotEmpty) {
                            final List<SalesInvoice> salesInvoices =
                                selected
                                    .where((e) => e.name != null)
                                    .map((e) => SalesInvoice(name: e.name))
                                    .toList();
                            context.cubit<CreateGateExitCubit>().onValueChanged(
                              salesInvoices: salesInvoices,
                              plantName: selectedSalesInvoices[0].plantName,
                              vehicleNo: selectedSalesInvoices[0].vehicleNo,
                            );
                          } else {
                            context.cubit<CreateGateExitCubit>().onValueChanged(
                              salesInvoices: [],
                              plantName: '',
                              vehicleNo: '',
                              // gateNumber: '',
                            );
                          }
                        });
                      },

                      focusNode: FocusNode(),
                    );
                  },
                ),
                onScan: () async {
                  final scanResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const SimpleBarcodeScannerPage(
                            scanType: ScanType.qr,
                            appBarTitle: 'Scan IRN QR',
                            isShowFlashIcon: true,
                          ),
                    ),
                  );

                  if (scanResult != null) {

                    if (!context.mounted) return;

                    $logger.devLog('….scanresult….$scanResult');
                    try {
                      
                      final Map<String, dynamic> jsonData = jsonDecode(
                        scanResult,
                      );

                      final String? invoiceNumber =
                          jsonData['InvoiceNumber']?.toString();
                      final String? vehicleNumber =
                          jsonData['VehicleNumber']?.toString();
                      final String? plantNameFromQR =
                          jsonData['PlantName']?.toString();

                      if (invoiceNumber != null && invoiceNumber.isNotEmpty) {


                        final allPOs = context
                            .read<SalesInvoiceList>()
                            .state
                            .maybeWhen(
                              orElse: () => <SalesInvoiceForm>[],
                              success: (data) => data,
                            );

                        SalesInvoiceForm? matchedInvoice;
                        try {
                          matchedInvoice = allPOs.firstWhere(
                            (po) =>
                                (po.name ?? '').trim().toUpperCase() ==
                                invoiceNumber.trim().toUpperCase(),
                          );
                        } catch (_) {
                          matchedInvoice = null;
                        }

                        if (matchedInvoice != null) {
                          setState(() {
                            invoiceform = matchedInvoice;
                            bool alreadyExists = selectedSalesInvoices.any(
                              (item) => item.name == matchedInvoice!.name,
                            );

                            if (!alreadyExists) {
                              selectedSalesInvoices = [
                                ...selectedSalesInvoices,
                                matchedInvoice!,
                              ];
                            }
                          });
                          final List<SalesInvoice> allSelectedInvoices =
                              selectedSalesInvoices
                                  .map((e) => SalesInvoice(name: e.name))
                                  .toList();

                          final selectedPlant =
                              plantNameFromQR?.isNotEmpty == true
                                  ? plantNameFromQR
                                  : matchedInvoice.plantName;

                          context.cubit<CreateGateExitCubit>().onValueChanged(
                            salesInvoices: allSelectedInvoices,
                            plantName: selectedPlant,
                            vehicleNo:
                                vehicleNumber ?? matchedInvoice.vehicleNo,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text(
                                    'Invoice Not Found',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    'The scanned invoice number does not match any existing invoice.',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed:
                                          () =>
                                              Navigator.of(
                                                context,
                                                rootNavigator: true,
                                              ).pop(),
                                    ),
                                  ],
                                ),
                          );
                        }
                      } else {
                        throw Exception(
                          'Invalid QR Data: Missing InvoiceNumber',
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Invalid QR Code'),
                              content: Text(
                                'Scanned data is not valid JSON or missing fields.\n\nError: $e',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed:
                                      () =>
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop(),
                                ),
                              ],
                            ),
                      );
                    }
                  }
                },
                showScanner: true,
              )
              : PreferredSize(
                preferredSize: const Size.fromHeight(250),
                child: BlocListener<Sales, SalesState>(
                  listener: (context, pstate) {
                    pstate.maybeWhen(
                      orElse: () {},
                      success: (data) {
                        context.read<CreateGateExitCubit>().addSalesInvoices(
                          salesInvoices: data,
                        );
                        final allInvoiceForms = context
                            .read<SalesInvoiceList>()
                            .state
                            .maybeWhen(
                              orElse: () => <SalesInvoiceForm>[],
                              success: (d) => d,
                            );

                        setState(() {
                          selectedSalesInvoices =
                              allInvoiceForms
                                  .where(
                                    (item) =>
                                        data.any((si) => si.name == item.name),
                                  )
                                  .toList();
                        });
                      },
                    );
                  },
                  child: TitleStatusAppBar(
                    title: '$name',
                    status: StringUtils.docStatus(status ?? 0),
                    onSubmit: () {},
                    onReject: () {},
                    actionButton:
                        (status == 1)
                            ? null
                            : BlocBuilder<
                              CreateGateExitCubit,
                              CreateGateExitState
                            >(
                              builder: (context, state) {
                                return AppButton(
                                  isLoading: state.isLoading,
                                  label: state.view.toName(),
                                  borderColor: Colors.grey,
                                  onPressed: () {
                                    context.cubit<CreateGateExitCubit>().save();
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
                                .watch<CreateGateExitCubit>()
                                .state
                                .form
                                .salesInvoices ??
                            [];

                        return SearchMultiDropDownList<SalesInvoiceForm>(
                          title: 'Invoice No',
                          hint: 'Search Invoice No',
                          key: UniqueKey(),
                          color: AppColors.white,
                          items: names,
                          readOnly: status == 1,
                          defaultSelection: [
                            ...names.where(
                              (item) => selectedOrders.any(
                                (so) => so.name == item.name,
                              ),
                            ),

                            ...selectedOrders
                                .where(
                                  (so) =>
                                      !names.any(
                                        (item) => item.name == so.name,
                                      ),
                                )
                                .map((so) => SalesInvoiceForm(name: so.name)),
                          ],


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
                          headerBuilder: (_, item, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
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
                                    'Sales Invoice No: ${item.name ?? ''}',
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
                          onSelected: (selected) {
                            setState(() {
                              selectedSalesInvoices = selected;
                              if (selectedSalesInvoices.isNotEmpty) {
                                final List<SalesInvoice> purchaseOrders =
                                    selectedSalesInvoices
                                        .where((e) => e.name != null)
                                        .map((e) => SalesInvoice(name: e.name))
                                        .toList();
                                context
                                    .cubit<CreateGateExitCubit>()
                                    .onValueChanged(
                                      salesInvoices: purchaseOrders,
                                      plantName:
                                          selectedSalesInvoices[0].plantName,
                                      vehicleNo:
                                          selectedSalesInvoices[0].vehicleNo,
                                    );
                              } else {
                                context
                                    .cubit<CreateGateExitCubit>()
                                    .onValueChanged(
                                      salesInvoices: [],
                                      plantName: '',
                                      vehicleNo: '',
                                    );
                              }
                            });
                          },

                          focusNode: FocusNode(),
                        );
                      },
                    ),
                    onScan: () async {
                      if (status == 1) {
                        return;
                      }
                      final scanResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SimpleBarcodeScannerPage(
                                scanType: ScanType.qr,
                                appBarTitle: 'Scan IRN QR',
                                isShowFlashIcon: true,
                              ),
                        ),
                      );

                      if (scanResult != null) {

                        if (!context.mounted) return;




                        try {

                          final Map<String, dynamic> jsonData = jsonDecode(
                            scanResult,
                          );

                          final String? invoiceNumber =
                              jsonData['InvoiceNumber']?.toString();
                          final String? vehicleNumber =
                              jsonData['VehicleNumber']?.toString();
                          final String? plantNameFromQR =
                              jsonData['PlantName']?.toString();
                          if (invoiceNumber != null &&
                              invoiceNumber.isNotEmpty) {
                            final List<SalesInvoice> scannedInvoices = [
                              SalesInvoice(
                                name: invoiceNumber.trim().toUpperCase(),
                              ),
                            ];
                            context.cubit<CreateGateExitCubit>().onValueChanged(
                              salesInvoices: scannedInvoices,
                              vehicleNo: vehicleNumber,
                            );
                            final allPOs = context
                                .read<SalesInvoiceList>()
                                .state
                                .maybeWhen(
                                  orElse: () => <SalesInvoiceForm>[],
                                  success: (data) => data,
                                );
                            SalesInvoiceForm? matchedInvoice;
                            try {
                              matchedInvoice = allPOs.firstWhere(
                                (po) =>
                                    (po.name ?? '').trim().toUpperCase() ==
                                    invoiceNumber.trim().toUpperCase(),
                              );
                            } catch (_) {
                              matchedInvoice = null;
                            }

                            if (matchedInvoice != null) {
                              setState(() {
                                invoiceform = matchedInvoice;
                              });

                              final selectedPlant =
                                  plantNameFromQR?.isNotEmpty == true
                                      ? plantNameFromQR
                                      : matchedInvoice.plantName;

                              context
                                  .cubit<CreateGateExitCubit>()
                                  .onValueChanged(
                                    salesInvoices: scannedInvoices,
                                    plantName: selectedPlant,
                                    vehicleNo:
                                        vehicleNumber ??
                                        matchedInvoice.vehicleNo,
                                  );
                            } else {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text(
                                        'Invoice Not Found',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        'The scanned invoice number does not match any existing invoice.',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed:
                                              () =>
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).pop(),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          } else {
                            throw Exception(
                              'Invalid QR Data: Missing InvoiceNumber',
                            );
                          }
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Invalid QR Code'),
                                  content: Text(
                                    'Scanned data is not valid JSON or missing fields.\n\nError: $e',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed:
                                          () =>
                                              Navigator.of(
                                                context,
                                                rootNavigator: true,
                                              ).pop(),
                                    ),
                                  ],
                                ),
                          );
                        }
                      }
                    },
                    showScanner: true,
                    textColor: Colors.white,
                    pageMode: PageMode2.gateexit,
                    showRejectButton: false,
                    isSubmitting: gateEntryState.isLoading,
                  ),
                ),
              ),

      body: BlocBuilder<CreateGateExitCubit, CreateGateExitState>(
        builder: (context, overlayState) {
          return FormPageLoadingStack(
            isLoading: overlayState.isLoading,
            message: 'Saving document...',
            statusLabel: 'Processing...',
            child: BlocListener<CreateGateExitCubit, CreateGateExitState>(
              listener: (_, state) async {
                if (state.isSuccess && state.successMsg!.isNotNull) {
                  AppDialog.showSuccessDialog(
                    context,
                    title: 'Success',
                    content: state.successMsg.valueOrEmpty,
                    onTapDismiss: context.exit,
                  ).then((_) {
                    if (!context.mounted) return;
                    context.cubit<CreateGateExitCubit>().errorHandled();

                    final gateEntryFilters =
                        context.read<GateExitFilterCubit>().state;
                    context.cubit<GateExitCubit>().fetchInitial(
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
                  context.cubit<CreateGateExitCubit>().errorHandled();
                }
              },
              child: GateExitFormWidget(key: ValueKey(status)),
            ),
          );
        },
      ),
    );
  }
}
