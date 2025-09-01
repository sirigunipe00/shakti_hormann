import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class GateEntryFormWidget extends StatefulWidget {
  const GateEntryFormWidget({super.key});

  @override
  State<GateEntryFormWidget> createState() => _GateEntryFormWidgetState();
}

class _GateEntryFormWidgetState extends State<GateEntryFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final _scanIrnController = TextEditingController();
  String scanVal = '';

  final focusNodes = List.generate(40, (index) => FocusNode());
  final _indianFormat = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateGateEntryCubit>().state;
    final isCompleted = formState.view == GateEntryView.completed;
    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateGateEntryCubit, CreateGateEntryState>(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (_, state) async {
            // final indx = state.error?.status;
            // if (indx != null) {
            //   final focus = focusNodes.elementAt(indx);
            //   FocusScope.of(context).requestFocus(focus);

            //   final targetContext = focus.context;
            //   if (targetContext != null) {
            //     await Scrollable.ensureVisible(
            //       targetContext,
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.easeInOut,
            //     );
            //   }
            // }
          },
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withOpacity(0.15),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.symmetric(vertical: 20),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Gate Entry Details',
                  assetIcon: 'assets/images/gateentryicon.png',
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

                child: SpacedColumn(
                  defaultHeight: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      readOnly: true,
                      title: 'Plant Name',
                      hintText: 'plant name',
                      borderColor: AppColors.grey,
                      initialValue: newform.plantName,
                      onChanged:
                          (p0) => context
                              .cubit<CreateGateEntryCubit>()
                              .onValueChanged(plantName: p0),
                    ),

                   AppDateField(
                      title: 'Gate Entry Date',
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      readOnly: true,
                      initialValue:DFU.ddMMyyyyFromStr(newform.gateEntryDate ?? ''),
                      fillColor: Colors.grey[200],
                      onSelected: (date) {
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          gateEntryDate: DateFormat('dd-MM-yyyy').format(date),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Invoice Details',
                  assetIcon: 'assets/images/vehicleinvoiceicon.png',
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
                child: SpacedColumn(
                  defaultHeight: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      readOnly: isCompleted,

                      initialValue: newform.vendorInvoiceNo,
                      title: 'Vendor Invoice No',
                      hintText: 'Enter Invoice No',

                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          vendorInvoiceNo: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    AppDateField(
                      readOnly: isCompleted,
                      title: 'Vendor Invoice Date',
                      fillColor:Colors.white,
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      initialDate: DFU.ddMMyyyyFromStr(
                        newform.vendorInvoiceDate ?? '',
                      ),
                      onSelected: (DateTime date) {
                        setState(() {
                          context.cubit<CreateGateEntryCubit>().onValueChanged(
                            vendorInvoiceDate: DateFormat(
                              'dd-MM-yyyy',
                            ).format(date),
                          );
                        });
                      },
                      hintText: 'Select a date',
                      ),

                    InputField(
                      borderColor: AppColors.grey,
                      readOnly: isCompleted,
                      key: UniqueKey(),
                      hintText: 'Enter Invoice Quantity',
                      initialValue: newform.invoiceQuantity?.toString() ?? '0',
                      title: 'Vendor Invoice Quantity',
                      onChanged: (quantity) {
                        final intValue = int.tryParse(quantity);
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          invoiceQuantity: intValue,
                        );
                      },
                    ),
                    InputField(
                      borderColor: AppColors.grey,
                      readOnly: isCompleted,
                      hintText: 'Enter Invoice Amount',
                      suffixIcon: const Icon(Icons.currency_rupee_outlined),

                      initialValue:
                          newform.invoiceAmount != null
                              ? _indianFormat.format(newform.invoiceAmount)
                              : '',

                      title: 'Invoice Amount',
                      onChanged: (p0) {
                        final cleaned = p0.replaceAll(',', '');
                        final intValue = int.tryParse(cleaned);

                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          invoiceAmount: intValue,
                        );
                      },
                    ),

                    InputField(
                      borderColor: AppColors.grey,
                      readOnly: isCompleted,

                      initialValue: newform.vehicleNo,
                      title: 'Vehicle Number',
                      hintText: 'Enter Vehicle No',
                      onChanged: (p0) {
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          vehicleNo: p0,
                        );
                      },
                      inputFormatters: [UpperCaseTextFormatter()],
                    ),
                    InputField(
                      readOnly: isCompleted,
                      controller: _scanIrnController,
                      title: 'Scan IRN QR',
                      hintText: 'Tap to scan QR code',
                      borderColor: AppColors.grey,
                      initialValue:
                          context
                              .read<CreateGateEntryCubit>()
                              .state
                              .form
                              .scanIrn,
                      suffixIcon: GestureDetector(
                        onTap:
                            isCompleted
                                ? null
                                : () async {
                                  final scanResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const SimpleBarcodeScannerPage(
                                                scanType: ScanType.qr,
                                                appBarTitle: 'Scan IRN QR',
                                                isShowFlashIcon: true,
                                              ),
                                    ),
                                  );

                                  if (scanResult != null) {
                                    String irn = extractIrnFromQr(scanResult);

                                    setState(() {
                                      context
                                          .cubit<CreateGateEntryCubit>()
                                          .onValueChanged(scanIrn: irn);
                                    });
                                  }
                                },
                        child: const Icon(Icons.qr_code_scanner),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.png',
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.00),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NewUploadPhotoWidget(
                        fileName: 'vehiclefront',
                
                        imageUrl: newform.vehiclePhoto,
                        title: 'Vehicle Front',
                        isRequired: true,
                        isReadOnly: isCompleted,
                        onFileCapture: (file) {
                          context.cubit<CreateGateEntryCubit>().onValueChanged(
                            vehiclePhoto: file,
                          );
                        },
                        focusNode: focusNodes.elementAt(27),
                      ),
                      NewUploadPhotoWidget(
                        fileName: 'vehicleback',
                
                        imageUrl: newform.vehicleBackPhoto,
                        title: 'Vehicle Back',
                        isRequired: true,
                        isReadOnly: isCompleted,
                        onFileCapture: (file) {
                          context.cubit<CreateGateEntryCubit>().onValueChanged(
                            vehicleBackPhoto: file,
                          );
                        },
                        focusNode: focusNodes.elementAt(27),
                      ),
                      NewUploadPhotoWidget(
                        fileName: 'vehicleinvoice',
                
                        imageUrl: newform.invoicePhoto,
                        title: 'Vehicle Invoice',
                        isRequired: true,
                        isReadOnly: isCompleted,
                        onFileCapture: (file) {
                          context.cubit<CreateGateEntryCubit>().onValueChanged(
                            invoicePhoto: file,
                          );
                        },
                        focusNode: focusNodes.elementAt(27),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Remarks',
                  assetIcon: 'assets/images/reamraksicon.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputField(
                      readOnly: isCompleted,
                      minLines: 3,
                      maxLines: 6,
                      hintText: 'Enter here.....',
                      initialValue: newform.remarks,
                      title: 'Remarks (if any)',
                      onChanged: (text) {
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          remarks: text,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String extractIrnFromQr(String qrData) {
  try {
    final decoded = jsonDecode(qrData);
    if (decoded is Map<String, dynamic> && decoded.containsKey('irn')) {
      return decoded['irn'].toString();
    }
  } catch (_) {
    final match = RegExp(r'IRN[:\s]?(\w+)').firstMatch(qrData);
    if (match != null) {
      return match.group(1) ?? '';
    }
  }
  return qrData;
}
