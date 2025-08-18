import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class GateEntryFormWidget extends StatefulWidget {
  const GateEntryFormWidget({super.key});

  @override
  State<GateEntryFormWidget> createState() => _GateEntryFormWidgetState();
}

class _GateEntryFormWidgetState extends State<GateEntryFormWidget> {
  final ScrollController _scrollController = ScrollController();


  final focusNodes = List.generate(40, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    String scanVal = '';

    final formState = context.read<CreateGateEntryCubit>().state;
    final isCompleted = formState.view == GateEntryView.completed;
    final newform = formState.form;
print('invoice photo.....${newform.invoicePhoto}');
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateGateEntryCubit, CreateGateEntryState>(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (_, state) async {
            final indx = state.error?.status;
            if (indx != null) {
              final focus = focusNodes.elementAt(indx);
              FocusScope.of(context).requestFocus(focus);
              await Scrollable.ensureVisible(
                focus.context!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ],
      child: Container(
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.symmetric(vertical: 20),
            defaultHeight: 2,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/gateentryicon.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Gate Entry Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
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
                      readOnly: true,
                      title: 'Gate Entry Date',
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      initialDate: newform.gateEntryDate,
                      onSelected: (DateTime date) {
                        setState(() {
                          context.cubit<CreateGateEntryCubit>().onValueChanged(
                            gateEntryDate: DateFormat(
                              'yyyy-MM-dd',
                            ).format(date),
                          );
                        });
                      },
                      hintText: 'Select a date',
                      
                      fillColor: Colors.grey[200],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/vehicleinvoiceicon.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Invoice Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
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
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      initialDate: newform.vendorInvoiceDate,
                      onSelected: (DateTime date) {
                        setState(() {
                          context.cubit<CreateGateEntryCubit>().onValueChanged(
                            vendorInvoiceDate: DateFormat(
                              'yyyy-MM-dd',
                            ).format(date),
                          );
                        });
                      },
                      hintText: 'Select a date',
                      
                      fillColor: Colors.grey[200],
                    ),

                    InputField(
                      borderColor: AppColors.grey,
                      readOnly: isCompleted,
                      key: UniqueKey(),
                      hintText: 'Enter Invoice Quantity',
                      initialValue:newform.invoiceQuantity?.toString() ?? '0',
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
                      initialValue:newform.invoiceAmount?.toString() ?? '0',
                      title: 'Invoice Amount',
                      onChanged: (p0) {
                        final intValue = int.tryParse(p0);
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
                      borderColor: AppColors.grey,
                      readOnly: isCompleted,
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final scanResult = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const SimpleBarcodeScannerPage(
                                    scanType: ScanType.barcode,
                                    appBarTitle: 'Scan Machine',
                                    isShowFlashIcon: true,
                                  ),
                            ),
                          );

                          if (scanResult != null && scanResult != '-1') {
                            setState(() {
                              scanVal = scanResult;
                            });

                            if (context.mounted) {
                              context
                                  .cubit<CreateGateEntryCubit>()
                                  .onValueChanged(scanIrn: scanResult);
                            }
                          }
                        },

                        child: const Icon(
                          Icons.qr_code,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      initialValue: scanVal,
                      title: 'Scan IRN',
                      onChanged: (p0) {
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          scanIrn: p0,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 25,
                      child: Icon(
                        Icons.camera_alt,
                        color: Color.fromARGB(255, 138, 169, 224),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
              Card(
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
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 25,
                      child: Icon(
                        Icons.edit_note_outlined,
                        color: AppColors.darkBlue,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Remarks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
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
