import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/create/gate_entry_form_widget.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/create/gate_exit_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateGateExitCubit>().state;

    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    final isNew = gateEntryState.view == GateExitView.create;
    return Scaffold(
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
                          bgColor: const Color.fromARGB(255, 250, 193, 47),
                          textStyle: const TextStyle(color: AppColors.darkBlue,fontWeight: FontWeight.bold,fontSize: 15),
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
                                'Sales Invoice No: ${item.name ?? ''}',
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
                          invoiceform = selected;
                        });
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          salesInvoiceNo: selected.name,
                          plantName: selected.plantName,
                        );
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
                    final scannedValue =
                        extractIrnFromQr(scanResult).trim().toUpperCase();

                    final allPOs =
                        context
                            .read<SalesInvoiceList>()
                            .state
                            .maybeWhen(
                              orElse: () => <SalesInvoiceForm>[],
                              success: (data) => data,
                            )
                            .toList();
                    try {
                      SalesInvoiceForm matchedinvoiceno = allPOs.firstWhere(
                        (po) =>
                            (po.name ?? '').trim().toUpperCase() ==
                            scannedValue,
                      );

                      setState(() {
                        invoiceform = matchedinvoiceno;
                      });

                      context.cubit<CreateGateExitCubit>().onValueChanged(
                        salesInvoiceNo: matchedinvoiceno.name,
                        plantName: matchedinvoiceno.plantName,
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Error',style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.bold)),
                              content: const Text(
                                'Scanned invoice order number is not matched with Existing invoice order.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                    }
                  }
                },
                showScanner: true,
              )
              : TitleStatusAppBar(
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
                    textColor: Colors.white,
                    pageMode: PageMode2.gateexit,
                    showRejectButton: false,
                    isSubmitting: gateEntryState.isLoading,
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateGateExitCubit, CreateGateExitState>(
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
  }
}
