import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
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
    DateTime? selectedDate;
    String scanVal = '';
    bool hasScanValue = false;

    final formState = context.read<CreateGateEntryCubit>().state;
    final isCreating = formState.view == GateEntryView.create;
    final isCompleted = formState.view == GateEntryView.completed;
    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        // BlocListener<AttachmentsList,AttachmentsListState>(
        //   listener:(_, state) {
        //     state.maybeWhen(
        //       orElse: (){},
        //       success: (data) {
        //         context.cubit<CreateGateEntryCubit>().addInvUrls(data);
        //         setState(() {});
        //       },
        //     );
        //   },
        // ),
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
        color: Colors.grey[100],
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(12.0),
            defaultHeight: 8,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/gateentryicon.png',
                      ),
                    ),
                    const SizedBox(width: 8),
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
                width: MediaQuery.of(context).size.width,

                margin: const EdgeInsets.all(2),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Color(0xFFE8ECF4), // your border color
                          width: 1,
                        ),
                      ),

                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              title: 'Plant Name',

                              borderColor: AppColors.grey,
                              initialValue: newform.plantName,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateGateEntryCubit>()
                                      .onValueChanged(plantName: p0),
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Gate Entry No',

                              borderColor: AppColors.grey,
                              initialValue: newform.name,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateGateEntryCubit>()
                                      .onValueChanged(name: p0),
                            ),

                            const SizedBox(height: 12),

                            AppDateField(
                              title: 'Gate Entry Date',
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.gateEntryDate,
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateGateEntryCubit>()
                                      .onValueChanged(
                                        gateEntryDate: DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(date),
                                      );
                                });
                              },
                              hintText: 'Select a date',
                              isRequired: true,
                              fillColor: Colors.grey[200],
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Purchase Order Number',
                              borderColor: AppColors.grey,
                              initialValue: newform.purchaseOrder,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateGateEntryCubit>()
                                      .onValueChanged(purchaseOrder: p0),
                            ),
                            const SizedBox(height: 12),
                            //                   AppDropDownWidget(

                            //   defaultSelection: newform.,
                            //   readOnly: isCompleted,
                            //   title: 'Pay Type',
                            //   hint: 'Select Pay Type',
                            //   color: AppColors.marigoldDDust,
                            //   items: const ['Hours', 'Qty'],
                            //   focusNode: focusNodes.elementAt(7),
                            //   onSelected: (value) {
                            //     setState(() {
                            //       payType = value;
                            //     });

                            //     context
                            //         .cubit<CreateGateEntryCubit>()
                            //         .onValueChanged(payType: value);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          Colors.transparent, // No background color
                      backgroundImage: AssetImage(
                        'assets/images/vehicleinvoiceicon.png',
                      ), // Use backgroundImage
                    ),
                    const SizedBox(width: 8),
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
                width: MediaQuery.of(context).size.width,

                margin: const EdgeInsets.all(2),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Color(0xFFE8ECF4), // your border color
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              readOnly: isCompleted,

                              initialValue: newform.vendorInvoiceNo,
                              title: 'Vendor Invoice',
                              isRequired: true,
                              borderColor: AppColors.grey,
                              onChanged: (p0) {
                                context
                                    .cubit<CreateGateEntryCubit>()
                                    .onValueChanged(vendorInvoiceNo: p0);
                              },
                              focusNode: focusNodes.elementAt(13),
                            ),

                            const SizedBox(height: 12),
                            AppDateField(
                              title: 'Select Date',
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.vendorInvoiceDate,
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateGateEntryCubit>()
                                      .onValueChanged(
                                        vendorInvoiceDate: DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(date),
                                      );
                                });
                              },
                              hintText: 'Select a date',
                              isRequired: true,
                              fillColor: Colors.grey[200],
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              borderColor: AppColors.grey,
                              readOnly: isCompleted,

                              initialValue:
                                  newform.vendorInvoiceQuantity != null
                                      ? newform.vendorInvoiceQuantity.toString()
                                      : '',
                              title: 'Quantity',
                              onChanged: (quantity) {
                                final intValue = int.tryParse(quantity);
                                context
                                    .cubit<CreateGateEntryCubit>()
                                    .onValueChanged(
                                      vendorInvoiceQuantity: intValue,
                                    );
                              },
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              borderColor: AppColors.grey,
                              readOnly: isCompleted,
                              suffixIcon: Icon(Icons.currency_rupee_outlined),
                              initialValue:
                                  newform.invoiceAmount != null
                                      ? newform.invoiceAmount.toString()
                                      : '',
                              title: 'Amount',
                              onChanged: (p0) {
                                final intValue = int.tryParse(p0);
                                context
                                    .cubit<CreateGateEntryCubit>()
                                    .onValueChanged(invoiceAmount: intValue);
                              },
                            ),
                            InputField(
                              borderColor: AppColors.grey,
                              readOnly: isCompleted,

                              initialValue:
                                  newform.vehicleNo != null
                                      ? newform.vehicleNo.toString()
                                      : '',
                              title: 'Vehicle Number',
                              onChanged: (p0) {
                                context
                                    .cubit<CreateGateEntryCubit>()
                                    .onValueChanged(vehicleNo: p0);
                              },
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
                                          (context) =>
                                              const SimpleBarcodeScannerPage(
                                                scanType: ScanType.barcode,
                                                appBarTitle: 'Scan Machine',
                                                isShowFlashIcon: true,
                                              ),
                                    ),
                                  );

                                  if (scanResult != null &&
                                      scanResult != '-1') {
                                    setState(() {
                                      scanVal = scanResult;
                                      hasScanValue = true;
                                    });

                                    if (context.mounted) {
                                      context
                                          .cubit<CreateGateEntryCubit>()
                                          .onValueChanged(scanIrn: scanResult);
                                    }
                                  }
                                },

                                child: Icon(
                                  Icons.qr_code,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              initialValue: scanVal,
                              title: 'Scan IRN',
                              onChanged: (p0) {
                                context
                                    .cubit<CreateGateEntryCubit>()
                                    .onValueChanged(scanIrn: p0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 30,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF263238),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                  side: BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PhotoSelectionWidget(
                      label: "Vehicle Front",
                      imagePath: 'assets/images/vehiclefront.png',

                      backgroundColor: Colors.teal.shade50,
                      onImageSelected:
                          (file) => context
                              .cubit<CreateGateEntryCubit>()
                              .onValueChanged(vehiclePhoto: file),
                    ),
                    PhotoSelectionWidget(
                      label: "Vehicle Back",
                      imagePath: 'assets/images/vehicleback.png',

                      backgroundColor: Colors.orange.shade50,
                      onImageSelected:
                          (file) => context
                              .cubit<CreateGateEntryCubit>()
                              .onValueChanged(vehicleBackPhoto: file),
                    ),
                    PhotoSelectionWidget(
                      label: "Invoice",
                      imagePath: 'assets/images/vehicleinvoice.png',

                      backgroundColor: Colors.deepPurple.shade50,
                      onImageSelected:
                          (file) => context
                              .cubit<CreateGateEntryCubit>()
                              .onValueChanged(vehicleInvoicePhoto: file),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 4,
                ), // reduced bottom padding
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 30,
                      child: Icon(
                        Icons.edit_note_outlined,
                        color: AppColors.darkBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  12,
                ), 
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputField(
                      readOnly: isCompleted,
                      minLines: 3,
                      maxLines: 6,
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

              // if (!isCompleted) ...[
              //   BlocBuilder<CreateGateEntryCubit, CreateGateEntryState>(
              //     builder:
              //         (_, state) => AppButton(
              //           label: isCreating ? 'Create' : 'Submit',
              //           isLoading: state.isLoading,
              //           bgColor: AppColors.darkBlue,
              //           onPressed: context.cubit<CreateGateEntryCubit>().save,
              //         ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
