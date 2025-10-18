import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class VehicleReportingFormWidget extends StatefulWidget {
  const VehicleReportingFormWidget({super.key});

  @override
  State<VehicleReportingFormWidget> createState() =>
      _VehicleReportingFormWidget();
}

class _VehicleReportingFormWidget extends State<VehicleReportingFormWidget> {
  final ScrollController _scrollController = ScrollController();

  final focusNodes = List.generate(40, (index) => FocusNode());
  VehicleReportingForm? vehicleForm;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateVehicleCubit>().state;
    final isCompleted =
        formState.view == VehicleView.completed ||
        (formState.form.docstatus == 1 || formState.form.status == 'Reported' || formState.form.status == 'Rejected');
    final hasVehicleNo = (vehicleForm?.vehicleNumber?.isNotEmpty ?? false);
    final newform = formState.form;
   

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
        color: Colors.purple.shade100.withValues(alpha: 0.15),
        child: SingleChildScrollView(
          
          controller: _scrollController,
        
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(12.0),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vehicle Request Details',
                  assetIcon: 'assets/images/gateentryicon.svg',
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
                          top: 15,
                          left: 16,
                          right: 16,
                          bottom: 6
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
                              title: 'Vehicle Reporting Entry Date',
                              hintText: 'Select Date',
                              readOnly: true,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.vehicleReportingEntryVreDate ?? '',
                              ),
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
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vehicle and Driver Details',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
        
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 6),
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
                              // key: ValueKey(newform.arrivalDate ?? ''),
                              key: UniqueKey(),
                              startDate: DateTime(2020), 
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.arrivalDate ?? '',
                              ),
                              onSelected: (DateTime date) {
                        // setState(() {
                          if (formState.form.status == '') {
                            context
                                .cubit<CreateVehicleCubit>()
                                .onValueChanged(
                                  arrivalDate: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(date),
                                );
                          } else {
                            context
                                .cubit<CreateVehicleCubit>()
                                .onValueChanged(
                                  arrivalDate: DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(date),
                                );
                          }
                        // });
                      },
                              fillColor: Colors.white,
                            
                            ),
                          ),
                          const SizedBox(width: 13,),
                          Expanded(child: 
                             Column(
                              mainAxisSize: MainAxisSize.min,
                               children: [
                                 TimePickerField(
                                      title: 'Arrival Time',
                                      readOnly: isCompleted,
                                      isRequired: true,
                                      key: UniqueKey(),
                                      hintText: 'Select Time',
                                      initialTime: formatTime(
                                        newform.arrivalTime
                                      ),
                                      onTimeChanged: (selectedTime) {
                                        context
                                            .cubit<CreateVehicleCubit>()
                                            .onValueChanged(
                                              arrivalTime: selectedTime,
                                            );
                                      },
                                    ),
                               ],
                             ),
                          )
                        ],
                      ),
        
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Vehicle Number',
                        hintText: 'Vehicle No',
                        readOnly: hasVehicleNo  || isCompleted,
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
                        readOnly: true,
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
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only( left: 16, right: 16),
                child: Card(
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
              ),
        
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Driver Remarks',
                  assetIcon: 'assets/images/remarksicon.svg',
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
                      title: 'Driver Remarks (if any)',
                      hintText: 'Enter Remarks',
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
            ],
          ),
        ),
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
