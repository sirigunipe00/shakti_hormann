import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/create_gate_management_cubit.dart/gate_management_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/compact_search_select.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/multi_dropdown_select.dart';
import 'package:shakti_hormann/widgets/inputs/multiple_invoice.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
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
  final focusNodes = List.generate(40, (index) => FocusNode());
  String? _mobileError;

  @override
  void dispose() {
    _scrollController.dispose();
    vehicleNo.dispose();
    vendorInvoiceNo.dispose();
    remarks.dispose();
    driverName.dispose();
    driverMobileNo.dispose();
    vendorName.dispose();
    securityRemarks.dispose();
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateGateManagementCubit>().state;
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
          listener: (_, state) async {},
        ),
      ],
      child: Container(
        color: const Color(0xFFF7F8FA),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: ShellInsets.scrollPadding(context),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: SectionHeader(
                  title: 'Gate Management Details',
                  assetIcon: 'assets/images/gateentryicon.svg',
                ),
              ),
              _FormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      readOnly: true,
                      isRequired: true,
                      title: 'Plant Name',
                      hintText: 'Plant Name',
                      borderColor: AppColors.grey,
                      initialValue: newform.plantName ?? user().plantName,
                      onChanged: (p0) => context
                          .cubit<CreateGateManagementCubit>()
                          .onValueChanged(plantName: p0),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppDateField(
                            title: 'Gate Entry Date',
                            hintText: 'Select Entry Date',
                            startDate: DateTime(2020),
                            endDate: DateTime(2030),
                            isRequired: true,
                            readOnly: isCompleted,
                            initialValue: DFU.ddMMyyyyFromStr(
                              newform.gateeEntrydate ?? '',
                            ),
                            fillColor:
                                isCompleted ? Colors.grey[200] : Colors.white,
                            onSelected: (date) {
                              context
                                  .cubit<CreateGateManagementCubit>()
                                  .onValueChanged(
                                    gateEntryDate: DateFormat('dd-MM-yyyy')
                                        .format(date),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TimeField(
                            title: 'Gate Entry Time',
                            readOnly: isCompleted,
                            isRequired: true,
                            hintText: 'Select Time',
                            initialTime: formatTime(newform.gateEntryTime),
                            onTimeChanged: (selectedTime) {
                              context
                                  .cubit<CreateGateManagementCubit>()
                                  .onValueChanged(
                                    gateEntryTime: selectedTime,
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (!isCreating) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Gate Exit Date',
                              isRequired: true,
                              hintText: 'Select Exit Date',
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              readOnly: isCompleted,
                              initialValue: DFU.ddMMyyyyFromStr(
                                newform.gateExitdate ?? '',
                              ),
                              fillColor: isCompleted
                                  ? Colors.grey[200]
                                  : Colors.white,
                              onSelected: (date) {
                                context
                                    .cubit<CreateGateManagementCubit>()
                                    .onValueChanged(
                                      gateExitdate: DateFormat('dd-MM-yyyy')
                                          .format(date),
                                    );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TimeField(
                              title: 'Gate Exit Time',
                              readOnly: isCompleted,
                              isRequired: true,
                              hintText: 'Select Time',
                              initialTime: formatTime(newform.gateExitTime),
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateGateManagementCubit>()
                                    .onValueChanged(
                                      gateExitTime: selectedTime,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    InputField(
                      title: 'Purpose / Remarks',
                      hintText: 'Enter Your Remarks',
                      readOnly: isCompleted,
                      controller: remarks,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,
                      initialValue: newform.remarks,
                      onChanged: (value) => context
                          .cubit<CreateGateManagementCubit>()
                          .onValueChanged(remarks: value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: SectionHeader(
                  title: 'Vendor and Driver Info',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              _FormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.vehicleNo,
                      title: 'Vehicle No',
                      hintText: 'Enter Vehicle No',
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Z0-9]'),
                        ),
                      ],
                      controller: vehicleNo,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vehicleNo: p0);
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.vendorInvoiceNo,
                      title: 'Vendor Invoice Number',
                      hintText: 'Enter Invoice No',
                      controller: vendorInvoiceNo,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vendorInvoiceNo: p0);
                      },
                      focusNode: focusNodes.elementAt(14),
                    ),
                    const SizedBox(height: 12),
                    CompactSearchSelect<String>(
                      label: 'Vehicle Type',
                      hint: 'Select Vehicle Type',
                      locked: isCompleted,
                      leadingIcon: Icons.local_shipping_outlined,
                      options: Dropdownoptions.vehicleType.toSet().toList(),
                      value: newform.vehicleType,
                      labelOf: (e) => e,
                      onChanged: (selected) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vehicleType: selected);
                      },
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.driverName,
                      title: 'Driver Name',
                      hintText: 'Enter Driver Name',
                      controller: driverName,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(driverName: p0);
                      },
                      focusNode: focusNodes.elementAt(15),
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.driverMobileNo,
                      title: 'Driver Mobile No',
                      hintText: 'Enter 10-digit Mobile No',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      inputType: TextInputType.phone,
                      controller: driverMobileNo,
                      borderColor: _mobileError != null
                          ? Colors.red
                          : AppColors.grey,
                      onChanged: (p0) {
                        setState(() => _mobileError = _mobileErrorFor(p0));
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(driverMobileNo: p0);
                      },
                      focusNode: focusNodes.elementAt(16),
                    ),
                    if (_mobileError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _mobileError!,
                        style: const TextStyle(
                          color: Color(0xFFE11D48),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    InputField(
                      readOnly: isCompleted,
                      initialValue: newform.vendorName,
                      title: 'Company / Vendor Name',
                      hintText: 'Enter Vendor Name',
                      controller: vendorName,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context
                            .cubit<CreateGateManagementCubit>()
                            .onValueChanged(vendorName: p0);
                      },
                      focusNode: focusNodes.elementAt(17),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: SectionHeader(
                  title: 'Security Remarks',
                  assetIcon: 'assets/images/remarksicon.svg',
                ),
              ),
              _FormCard(
                child: InputField(
                  title: 'Security Remarks (if any)',
                  hintText: 'Enter Your Remarks',
                  readOnly: isCompleted,
                  controller: securityRemarks,
                  borderColor: AppColors.grey,
                  maxLines: 3,
                  minLines: 3,
                  initialValue: newform.securityRemarks,
                  onChanged: (value) => context
                      .cubit<CreateGateManagementCubit>()
                      .onValueChanged(securityRemarks: value),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.svg',
                ),
              ),
              _FormCard(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                child: BlocBuilder<CreateGateManagementCubit,
                    CreateGateManagementState>(
                  builder: (context, state) {
                    final form = state.form;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: NewUploadPhotoWidget(
                                fileName: 'vehiclefront',
                                imageUrl: form.vehiclePhoto,
                                title: 'Vehicle Front',
                                isRequired: true,
                                isReadOnly: isCompleted,
                                onFileCapture: (file) {
                                  context
                                      .cubit<CreateGateManagementCubit>()
                                      .onValueChanged(vehiclePhoto: file);
                                },
                              ),
                            ),
                            Expanded(
                              child: NewUploadPhotoWidget(
                                fileName: 'vehicleback',
                                imageUrl: form.backPhoto,
                                title: 'Vehicle Back',
                                isRequired: true,
                                isReadOnly: isCompleted,
                                onFileCapture: (file) {
                                  context
                                      .cubit<CreateGateManagementCubit>()
                                      .onValueChanged(backPhoto: file);
                                },
                              ),
                            ),
                            if (!isCompleted)
                              Expanded(
                                child: Column(
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
                                          if (!context.mounted) return;
                                          context
                                              .read<CreateGateManagementCubit>()
                                              .addInvoicePhoto(
                                                File(image.path),
                                              );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 9),
                                    const Text(
                                      'Vendor Invoices',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Urbanist',
                                        color: Color(0xFF0E1446),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if ((form.documentPhotoImg?.isNotEmpty ?? false) ||
                            (form.invoicePhotos?.isNotEmpty ?? false)) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(height: 28),
                          ),
                          MultipleImageUploadWidget(
                            title: 'Captured Invoices',
                            isReadOnly: isCompleted,
                            localFiles: form.documentPhotoImg,
                            serverUrls: form.invoicePhotos,
                            showAddButton: false,
                            onLocalFileAdded: (file) => context
                                .read<CreateGateManagementCubit>()
                                .addInvoicePhoto(file),
                            onLocalFileRemoved: (index) => context
                                .read<CreateGateManagementCubit>()
                                .removeLocalInvoicePhoto(index),
                            onServerFileRemoved: (index) => context
                                .read<CreateGateManagementCubit>()
                                .removeServerInvoicePhoto(index),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(14, 14, 14, 12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE8ECF4)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD6DCE8)),
          color: const Color(0xFFF8FAFD),
        ),
        child: const Center(
          child: Icon(Icons.add_rounded, size: 28, color: Color(0xFF2957A4)),
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

String? formatTime(String? backendTime) {
  if (backendTime == null || backendTime.isEmpty) return null;
  final parts = backendTime.split(':');
  if (parts.length < 2) return backendTime;
  return '${parts[0]}:${parts[1]}';
}

String? _mobileErrorFor(String? value) {
  final contact = value?.trim() ?? '';
  if (contact.isEmpty) return null;
  if (contact.length < 10) {
    return 'Enter a complete 10-digit mobile number';
  }
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(contact)) {
    return 'Mobile number must start with 6, 7, 8 or 9';
  }
  return null;
}
