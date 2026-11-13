import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

const _ink = Color(0xFF0E1446);
const _muted = Color(0xFF6B7280);

class VehicleReportingFormWidget extends StatefulWidget {
  const VehicleReportingFormWidget({super.key});

  @override
  State<VehicleReportingFormWidget> createState() =>
      _VehicleReportingFormWidget();
}

class _VehicleReportingFormWidget extends State<VehicleReportingFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController vehicleNo = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final focusNodes = List.generate(40, (index) => FocusNode());
  String? _contactError;

  @override
  void dispose() {
    _scrollController.dispose();
    vehicleNo.dispose();
    remarks.dispose();
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateVehicleCubit>().state;
    final isCompleted = formState.view == VehicleView.completed ||
        (formState.form.docstatus == 1 ||
            formState.form.status == 'Reported' ||
            formState.form.status == 'Rejected');
    final newform = formState.form;
    final hasVehicleNo = newform.vehicleNumber?.trim().isNotEmpty == true;
    final hasContact = newform.driverContact?.trim().isNotEmpty == true;
    final transporter = [
      newform.transporterName,
      newform.transporterName2,
    ].where((e) => e != null && e.trim().isNotEmpty).join(' - ');
    final lr = newform.linkedTransporterConfirmation?.trim() ?? '';

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateVehicleCubit, CreateVehicleState>(
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
                  title: 'Vehicle Request Details',
                  assetIcon: 'assets/images/gateentryicon.svg',
                ),
              ),
              _SummaryCard(
                plant: newform.plantName ?? '—',
                logisticNo: lr.isEmpty ? '—' : lr,
                vreDate: DFU.ddMMyyyyFromStr(
                  newform.vehicleReportingEntryVreDate ?? '',
                ),
                transporter: transporter.isEmpty ? '—' : transporter,
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: SectionHeader(
                  title: 'Vehicle and Driver Details',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8ECF4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Arrival Date',
                              hintText: 'Select Date',
                              isRequired: true,
                              readOnly: isCompleted,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.arrivalDate ?? '',
                              ),
                              onSelected: (DateTime date) {
                                if (formState.form.status == '') {
                                  context
                                      .cubit<CreateVehicleCubit>()
                                      .onValueChanged(
                                        arrivalDate: DateFormat('yyyy-MM-dd')
                                            .format(date),
                                      );
                                } else {
                                  context
                                      .cubit<CreateVehicleCubit>()
                                      .onValueChanged(
                                        arrivalDate: DateFormat('dd-MM-yyyy')
                                            .format(date),
                                      );
                                }
                              },
                              fillColor:
                                  isCompleted ? Colors.grey[200] : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TimePickerField(
                              title: 'Arrival Time',
                              readOnly: isCompleted,
                              isRequired: true,
                              hintText: 'Select Time',
                              initialTime: formatTime(newform.arrivalTime),
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateVehicleCubit>()
                                    .onValueChanged(arrivalTime: selectedTime);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Vehicle Number',
                        hintText: 'Enter Vehicle No',
                        isRequired: true,
                        readOnly: hasVehicleNo || isCompleted,
                        borderColor: AppColors.grey,
                        controller: vehicleNo,
                        initialValue: newform.vehicleNumber,
                        onChanged: (value) => context
                            .cubit<CreateVehicleCubit>()
                            .onValueChanged(vehicleNo: value),
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Z0-9]'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Driver Contact No',
                        hintText: 'Enter 10-digit Contact Number',
                        isRequired: true,
                        readOnly: hasContact || isCompleted,
                        inputType: TextInputType.phone,
                        borderColor: _contactError != null
                            ? Colors.red
                            : AppColors.grey,
                        initialValue: newform.driverContact,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (p0) {
                          setState(() => _contactError = _contactErrorFor(p0));
                          context
                              .cubit<CreateVehicleCubit>()
                              .onValueChanged(driverContact: p0);
                        },
                      ),
                      if (_contactError != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _contactError!,
                          style: const TextStyle(
                            color: Color(0xFFE11D48),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ],
                  ),
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
              Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8ECF4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: NewUploadPhotoWidget(
                          fileName: 'driverid',
                          imageUrl: newform.driverIdPhoto,
                          title: 'Driver ID Proof',
                          isRequired: true,
                          isReadOnly: isCompleted,
                          onFileCapture: (file) {
                            context.cubit<CreateVehicleCubit>().onValueChanged(
                                  driverIdPhoto: file,
                                );
                          },
                          focusNode: focusNodes.elementAt(27),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: SectionHeader(
                  title: 'Driver Remarks',
                  assetIcon: 'assets/images/remarksicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8ECF4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: InputField(
                    title: 'Driver Remarks (if any)',
                    hintText: 'Enter Remarks',
                    readOnly: isCompleted,
                    controller: remarks,
                    borderColor: AppColors.grey,
                    maxLines: 3,
                    minLines: 3,
                    initialValue: newform.remarks,
                    onChanged: (value) => context
                        .cubit<CreateVehicleCubit>()
                        .onValueChanged(remarks: value),
                  ),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.plant,
    required this.logisticNo,
    required this.vreDate,
    required this.transporter,
  });

  final String plant;
  final String logisticNo;
  final String vreDate;
  final String transporter;

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          children: [
            _infoRow(
              icon: Icons.factory_outlined,
              label: 'Plant',
              value: plant,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _chip(
                    icon: Icons.receipt_long_outlined,
                    label: 'Logistic No',
                    value: logisticNo,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _chip(
                    icon: Icons.calendar_month_outlined,
                    label: 'VRE Date',
                    value: vreDate.isEmpty ? '—' : vreDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.apartment_outlined,
              label: 'Transporter',
              value: transporter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF2957A4)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.lock_outline, size: 14, color: _muted),
      ],
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF2957A4)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }
}

String? formatTime(String? backendTime) {
  if (backendTime == null || backendTime.isEmpty) return null;
  final parts = backendTime.split(':');
  if (parts.length < 2) return backendTime;
  return '${parts[0]}:${parts[1]}';
}

String? _contactErrorFor(String? value) {
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
