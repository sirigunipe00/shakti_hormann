import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/create_gate_management_cubit.dart/gate_management_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/create/loading_cnfm_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/multi_dropdown_select.dart';
import 'package:shakti_hormann/widgets/inputs/multiple_invoice.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_field.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class GateManagementFormWidget extends StatefulWidget {
  const GateManagementFormWidget({super.key});

  @override
  State<GateManagementFormWidget> createState() =>
      _GateManagementFormWidgetState();
}

class _GateManagementFormWidgetState extends State<GateManagementFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController vehicleNo = TextEditingController();
  final TextEditingController vendorInvoiceNo = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController driverName = TextEditingController();
  final TextEditingController driverMobileNo = TextEditingController();
  final TextEditingController vendorName = TextEditingController();
  final TextEditingController securityRemarks = TextEditingController();

  GateManagementForm? gateManagementForm;

  LoggedInUser user() => $sl.get<LoggedInUser>();

  String scanVal = '';

  final focusNodes = List.generate(40, (index) => FocusNode());
  // final _indianFormat = NumberFormat.decimalPattern('en_IN');
  // final _invoiceAmountController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   final form = context.read<CreateGateManagementCubit>().state.form;

  //   $logger.devLog('gatenumber imitas..........${form.gateNumber}');

  //   if (form.invoiceAmount != null) {
  //     _invoiceAmountController.text = _indianFormat.format(form.invoiceAmount);
  //   }

  //   _invoiceAmountController.addListener(() {
  //     final text = _invoiceAmountController.text.replaceAll(',', '');
  //     final value = int.tryParse(text);

  //     if (value != null) {
  //       context.cubit<CreateGateEntryCubit>().onValueChanged(
  //         invoiceAmount: value,
  //       );

  //       // format back with commas
  //       final newText = _indianFormat.format(value);
  //       if (_invoiceAmountController.text != newText) {
  //         final selectionIndex =
  //             _invoiceAmountController.selection.baseOffset +
  //             (newText.length - _invoiceAmountController.text.length);

  //         _invoiceAmountController.value = TextEditingValue(
  //           text: newText,
  //           selection: TextSelection.collapsed(
  //             offset: selectionIndex.clamp(0, newText.length),
  //           ),
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    $logger.devLog('plantname...........${user().plantName}');
    final formState = context.read<CreateGateManagementCubit>().state;
    final isCompleted = formState.view == GateManagementView.completed;
    final isCreating = formState.view == GateManagementView.create;
    final newform = formState.form;


    return MultiBlocListener(
      listeners: [
        BlocListener<CreateGateManagementCubit, CreateGateManagementState>(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (_, state) async {
            
          },
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withValues(alpha: 0.15),
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
                  title: 'Gate Management Details',
                  assetIcon: 'assets/images/gateentryicon.svg',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
                      isRequired: true,
                      title: 'Plant Name',
                      hintText: 'Plant Name',
                      borderColor: AppColors.grey,
                      initialValue: newform.plantName ?? user().plantName,

                      onChanged:
                          (p0) => context
                              .cubit<CreateGateManagementCubit>()
                              .onValueChanged(plantName: p0),
                    ),
                    AppDateField(
                      title: 'Gate Entry Date',
                      hintText: 'Select Entry Date',
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      isRequired: true,
                      readOnly: isCompleted,
                      initialValue: DFU.ddMMyyyyFromStr(
                        newform.gateeEntrydate ?? '',
                      ),
                      fillColor: Colors.grey[200],
                      onSelected: (date) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(
                              gateEntryDate: DateFormat(
                                'dd-MM-yyyy',
                              ).format(date),
                            );
                      },
                    ),
                    TimeField(
                      title: 'Gate Entry Time',
                      readOnly: isCompleted,
                      isRequired: true,
                      hintText: 'Select Time',
                      initialTime: formatTime(newform.gateEntryTime),
                      onTimeChanged: (selectedTime) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(gateEntryTime: selectedTime);
                      },
                    ),
                    if (!isCreating) ...[
                      AppDateField(
                        title: 'Gate Exit Date',
                        isRequired: true,
                        hintText: 'Select Exit Date',
                        startDate: DateTime(2020),
                        endDate: DateTime(2030),
                        readOnly: isCompleted,
                        initialValue: DFU.ddMMyyyyFromStr(
                          newform.gateExitdate ?? '',
                        ),
                        fillColor: Colors.grey[200],
                        onSelected: (date) {
                          context
                              .cubit<CreateGateManagementCubit>()
                              .onValueChanged(
                                gateExitdate: DateFormat(
                                  'dd-MM-yyyy',
                                ).format(date),
                              );
                        },
                      ),
                      TimeField(
                        title: 'Gate Exit Time',
                        readOnly: isCompleted,
                        isRequired: true,
                        hintText: 'Select Time',
                        initialTime: formatTime(newform.gateExitTime),
                        onTimeChanged: (selectedTime) {
                          context
                              .cubit<CreateGateManagementCubit>()
                              .onValueChanged(gateExitTime: selectedTime);
                        },
                      ),
                    ],
                    MultiSearchDropDownList<String>(
                      title: 'Request Type',
                      hint: 'Select Request Types',
                      readOnly: isCompleted,
                      items: Dropdownoptions.requestType,
                      defaultSelection: newform.requestType ?? [],
                      color: AppColors.black,
                      onSelected: (selectedList) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(requestType: selectedList);
                      },
                    ),

                    // SearchDropDownList<String>(
                    //   title: 'Request Type',
                    //   hint: 'Select Request Type',
                    //   isRequired: false,
                    //   readOnly: isCompleted,
                    //   color: AppColors.black,
                    //   items: Dropdownoptions.requestType,
                    //   defaultSelection: newform.requestType,
                    //   headerBuilder: (_, item, __) => Text(item),
                    //   listItemBuilder:
                    //       (_, item, __, ___) =>
                    //           CompactListTile(title: item),
                    //   futureRequest: (searchText) async {
                    //     final all = Dropdownoptions.requestType;
                    //     if (searchText.trim().isEmpty) return all;
                    //     return all
                    //         .where(
                    //           (item) => item.toLowerCase().contains(
                    //             searchText.trim().toLowerCase(),
                    //           ),
                    //         )
                    //         .toList();
                    //   },
                    //   onSelected: (selected) {
                    //     context
                    //         .cubit<CreateGateManagementCubit>()
                    //         .onValueChanged(requestType: selected);
                    //   },
                    //   focusNode: focusNodes.elementAt(5),
                    // ),
                    InputField(
                      title: 'Purpose / Remarks',
                      hintText: 'Enter Your Remarks',
                      readOnly: isCompleted,
                      controller: remarks,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.remarks,
                      onChanged:
                          (value) => context
                              .cubit<CreateGateManagementCubit>()
                              .onValueChanged(remarks: value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vendor and Driver Info',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
                      initialValue: newform.vehicleNo,
                      title: 'Vehicle No',
                      hintText: 'Enter Vehicle No',
                      isRequired: false,
                      inputFormatters: [UpperCaseTextFormatter()],
                      controller: vehicleNo,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vehicleNo: p0);
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.vendorInvoiceNo,
                      title: 'Vendor Invoice Number',
                      hintText: 'Enter Invoice No',
                      isRequired: false,
                      controller: vendorInvoiceNo,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vendorInvoiceNo: p0);
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),

                    SearchDropDownList<String>(
                      title: 'Vehicle Type',
                      hint: 'Select Vehicle Type',
                      isRequired: false,
                      readOnly: isCompleted,
                      color: AppColors.black,
                      items: Dropdownoptions.vehicleType,
                      defaultSelection: newform.vehicleType,
                      headerBuilder: (_, item, __) => Text(item),
                      listItemBuilder:
                          (_, item, __, ___) => CompactListTile(title: item),
                      futureRequest: (searchText) async {
                        final all = Dropdownoptions.vehicleType;
                        if (searchText.trim().isEmpty) return all;
                        return all
                            .where(
                              (item) => item.toLowerCase().contains(
                                searchText.trim().toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      onSelected: (selected) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vehicleType: selected);
                      },
                      focusNode: focusNodes.elementAt(5),
                    ),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.driverName,
                      title: 'Driver Name',
                      hintText: 'Enter Driver Name',
                      isRequired: false,
                      controller: driverName,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(driverName: p0);
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    InputField(
                      readOnly: isCompleted,
                      isRequired: false,
                      initialValue: newform.driverMobileNo,
                      title: 'Driver Mobile No',
                      hintText: 'Enter Mobile No',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      inputType: TextInputType.number,
                      controller: driverMobileNo,
                      borderColor: AppColors.grey,

                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(driverMobileNo: p0);
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.vendorName,
                      title: 'Company / Vendor Name',
                      hintText: 'Enter Vendor Name',
                      isRequired: false,
                      controller: vendorName,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vendorName: p0);
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    InputField(
                      title: 'Security Remarks',
                      hintText: 'Enter Your Remarks',
                      readOnly: isCompleted,
                      controller: securityRemarks,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.securityRemarks,
                      onChanged:
                          (value) => context
                              .cubit<CreateGateManagementCubit>()
                              .onValueChanged(securityRemarks: value),
                    ),

                    // InputField(
                    //   borderColor: AppColors.grey,
                    //   readOnly: isCompleted,
                    //   key: UniqueKey(),
                    //   hintText: 'Enter Invoice Quantity',
                    //   initialValue: newform.invoiceQuantity?.toString() ?? '0',
                    //   title: 'Vendor Invoice Quantity',
                    //   inputType: const TextInputType.numberWithOptions(),
                    //   onChanged: (quantity) {
                    //     final intValue = int.tryParse(quantity);
                    //     context.cubit<CreateGateManagementCubit>().onValueChanged(
                    //       invoiceQuantity: intValue,
                    //     );
                    //   },
                    // ),
                    // InputField(
                    //   borderColor: AppColors.grey,
                    //   readOnly: isCompleted,
                    //   key: UniqueKey(),
                    //   // controller: TextEditingController(),
                    //   hintText: 'Enter Invoice Amount',
                    //   suffixIcon: const Icon(Icons.currency_rupee_outlined),
                    //   inputType:  const TextInputType.numberWithOptions(),
                    //   initialValue:
                    //       newform.invoiceAmount != null
                    //           ? _indianFormat.format(newform.invoiceAmount)
                    //           : '',

                    //   title: 'Invoice Amount',
                    //   onChanged: (p0) {

                    //     final cleaned = p0.replaceAll(',', '');
                    //     final intValue = int.tryParse(cleaned);
                    //    context.cubit<CreateGateManagementCubit>().onValueChanged(
                    //       invoiceAmount: intValue,
                    //       );
                    //   },
                    // ),
                    // InputField(
                    //   borderColor: AppColors.grey,
                    //   readOnly: isCompleted,
                    //   controller: _invoiceAmountController,
                    //   hintText: 'Enter Invoice Amount',
                    //   suffixIcon: const Icon(Icons.currency_rupee_outlined),
                    //   inputType: const TextInputType.numberWithOptions(),
                    //   title: 'Invoice Amount',
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.svg',
                ),
              ),

                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ),
                    child: BlocBuilder<
                      CreateGateManagementCubit,
                      CreateGateManagementState
                    >(
                      builder: (context, state) {
                        final newform = state.form;
                        return Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NewUploadPhotoWidget(
                                  fileName: 'vehiclefront',
                                  imageUrl: newform.vehiclePhoto,
                                  title: 'Vehicle Front',
                                  isRequired: true,
                                  isReadOnly: isCompleted,
                                  onFileCapture: (file) {
                                    context
                                        .cubit<CreateGateManagementCubit>()
                                        .onValueChanged(vehiclePhoto: file);
                                  },
                                ),
                                NewUploadPhotoWidget(
                                  fileName: 'vehicleback',
                                  imageUrl: newform.backPhoto,
                                  title: 'Vehicle Back',
                                  isRequired: true,
                                  isReadOnly: isCompleted,
                                  onFileCapture: (file) {
                                    context
                                        .cubit<CreateGateManagementCubit>()
                                        .onValueChanged(backPhoto: file);
                                  },
                                ),

                                if (!isCompleted)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 18),
                                      _PlusAddTile(
                                        onTap: () async {
                                          final picker = ImagePicker();
                                          final image = await picker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 70,
                                          );
                                          if (image != null) {
                                            context
                                                .read<CreateGateManagementCubit>()
                                                .addInvoicePhoto(
                                                  File(image.path),
                                                );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 9),
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Vendor Invoices',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Urbanist',
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' *',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors
                                                        .red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),


                            if ((newform.documentPhotoImg?.isNotEmpty ??
                                    false) ||
                                (newform.invoicePhotos?.isNotEmpty ??
                                    false)) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Divider(height: 32),
                              ),
                              MultipleImageUploadWidget(
                                title: 'Captured Invoices',
                                isReadOnly: isCompleted,
                                localFiles: newform.documentPhotoImg,
                                serverUrls: newform.invoicePhotos,
                                showAddButton:
                                    false, 
                                onLocalFileAdded:
                                    (file) => context
                                        .read<CreateGateManagementCubit>()
                                        .addInvoicePhoto(file),
                                onLocalFileRemoved:
                                    (index) => context
                                        .read<CreateGateManagementCubit>()
                                        .removeLocalInvoicePhoto(index),
                                onServerFileRemoved:
                                    (index) => context
                                        .read<CreateGateManagementCubit>()
                                        .removeServerInvoicePhoto(index),
                              ),
                            ],
                          ],
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
class _PlusAddTile extends StatelessWidget {
  const _PlusAddTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(

        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.grey.shade100,
        ),
        child: const Center(
          child: Icon(Icons.add, size: 30, color: Colors.pink),
        ),
      ),
    );
  }
}