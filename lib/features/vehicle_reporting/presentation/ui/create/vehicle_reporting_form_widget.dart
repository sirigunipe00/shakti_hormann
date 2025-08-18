import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/app_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class VehicleReportingFormWidget extends StatefulWidget {
  const VehicleReportingFormWidget({super.key});

  @override
  State<VehicleReportingFormWidget> createState() =>
      _VehicleReportingFormWidget();
}

class _VehicleReportingFormWidget extends State<VehicleReportingFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();

  final focusNodes = List.generate(40, (index) => FocusNode());
  VehicleReportingForm? vehicleForm;
  TransportersForm? transportersForm;
  DateTime? selectedDate;
  bool? isRejectedMode = false;

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateVehicleCubit>().state;
    final isCompleted = formState.view == VehicleView.completed;

    final newform = formState.form;
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateVehicleCubit, CreateVehicleState>(
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
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/gateentryicon.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Vehicle Request Details',
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
                        side: const BorderSide(
                          color: Color(0xFFE8ECF4),
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
                              hintText: 'Enter Plant Name',
                              readOnly: true,
                              isRequired: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.plantName,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateVehicleCubit>()
                                      .onValueChanged(plantName: p0),
                            ),
                            const SizedBox(height: 12),
                            AppDateField(
                              title: 'Vehicle Reporting Date',
                              hintText: 'Select Date',
                              readOnly: isCompleted,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.arrivalDateAndTime,
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateVehicleCubit>()
                                      .onValueChanged(
                                        vehicleReportingEntryVreDate:
                                            DateFormat(
                                              'dd-MM-yyyy',
                                            ).format(date),
                                      );
                                });
                              },
                              fillColor: Colors.grey[200],
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'Transporter',
                              hintText: 'Transporter Name',
                              readOnly: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.transporterName,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateVehicleCubit>()
                                      .onValueChanged(transporterName: p0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/vehicleinvoiceicon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Vehicle and Driver Details',
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Arrival Date',
                              hintText: 'Select Date',
                              readOnly: isCompleted,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.creation,
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateVehicleCubit>()
                                      .onValueChanged(
                                        creationDate: DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(date),
                                      );
                                });
                              },
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: TimePickerField(
                              title: 'Arrival Time',
                              hintText: 'Select time',
                              readOnly: isCompleted,
                              initialTime: newform.arrivalDateAndTime,
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateVehicleCubit>()
                                    .onValueChanged(
                                      arrivalDateAndTime: selectedTime,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      InputField(
                        title: 'Vehicle Number',
                        hintText: 'Vehicle No',
                        readOnly: isCompleted,
                        borderColor: AppColors.grey,

                        initialValue: newform.vehicleNumber,
                        onChanged:
                            (value) => context
                                .cubit<CreateVehicleCubit>()
                                .onValueChanged(vehicleNo: value),
                        inputFormatters: [UpperCaseTextFormatter()],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Driver Contact No',
                        hintText: 'Enter Contact Number',
                        readOnly: isCompleted,
                        inputType: TextInputType.number,
                        borderColor: AppColors.grey,
                        initialValue: newform.driverContact,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (p0) {
                          context.cubit<CreateVehicleCubit>().onValueChanged(
                            driverContact: p0,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 20,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF263238),
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
                child: Center(
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
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 4),
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
                    SizedBox(width: 8),
                    Text(
                      'Driver Remarks Details',
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
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                      title: 'Driver Remarks(if any)',
                      hintText: 'enter remarks',
                      readOnly: isCompleted,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.remarks,
                      onChanged:
                          (value) => context
                              .cubit<CreateVehicleCubit>()
                              .onValueChanged(remarks: value),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/vehicleinvoiceicon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Delivery Address Details',
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
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppDropDownWidget(
                      hint: 'Select Vehicle Status',
                      title: 'Vehicle Status',
                      readOnly: isCompleted,
                      defaultSelection: newform.status,
                      items: Dropdownoptions.vehicleStaus,
                      futureRequest: (searchText) async {
                        if (searchText.trim().isEmpty) {
                          return Dropdownoptions.vehicleStaus;
                        }

                        final filtered =
                            Dropdownoptions.vehicleStaus.where((item) {
                              final query = searchText.trim().toLowerCase();
                              final value = item.toString().toLowerCase();
                              return value.contains(query);
                            }).toList();

                        return filtered;
                      },
                      onSelected: (item) {
                        context.cubit<CreateVehicleCubit>().onValueChanged(
                          status: item,
                        );
                        setState(() {});
                      },
                      color: AppColors.black,
                      focusNode: focusNodes.elementAt(11),
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
