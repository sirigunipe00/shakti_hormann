import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class TransportCnfmFormWidget extends StatefulWidget {
  const TransportCnfmFormWidget({super.key});

  @override
  State<TransportCnfmFormWidget> createState() =>
      _TransportCnfmFormWidgetState();
}

class _TransportCnfmFormWidgetState extends State<TransportCnfmFormWidget> {
  final ScrollController _scrollController = ScrollController();

  final focusNodes = List.generate(40, (index) => FocusNode());
  TransportersForm? transportersForm;
  DateTime? selectedDate;
  bool? isRejectedMode = false;

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateTransportCubit>().state;
    final isCompleted = formState.view == TransportView.completed;

    final newform = formState.form;
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateTransportCubit, CreateTransportState>(
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
                  title: 'Logistic Planning Details',
                  assetIcon: 'assets/images/gateexiticon.png',
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
                          top: 20,
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
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(plantName: p0),
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Logistic Request No',
                              hintText: 'Enter Logistic Request No',
                              readOnly: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.name,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(name: p0),
                            ),

                            const SizedBox(height: 12),

                            AppDateField(
                              title: 'Logistic Request Date',
                              hintText: 'Select a Date',

                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.logisticsRequestDate ?? '',
                              ),
                              readOnly: true,

                              startDate: DFU.now(),
                              endDate: DFU.now(),
                              onSelected: (date) {
                                final formattedDate = DateFormat(
                                  'dd-MM-yyyy',
                                ).format(date);
                                context
                                    .cubit<CreateTransportCubit>()
                                    .onValueChanged(
                                      logisticsRequestDate: formattedDate,
                                    );
                              },
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                            ),
                            const SizedBox(height: 12),

                            InputField(
                              title: 'Transporter Name',

                              readOnly: true,

                              borderColor: AppColors.grey,
                              initialValue: newform.transporterName,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(transporterName: p0),
                            ),
                            const SizedBox(height: 12),

                            InputField(
                              title: 'Prefrred Vehicle Type',

                              readOnly: true,

                              borderColor: AppColors.grey,
                              initialValue: newform.preferredVehicleType,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(preferredVehicleType: p0),
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
                  title: 'Delivery Address Details',
                  assetIcon: 'assets/images/vehicleinvoiceicon.png',
                ),
              ),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16,bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Requested Delivery Date',
                              hintText: 'Select Date',
                              readOnly: true,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),

                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.requestedDeliveryDate ?? '',
                              ),
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(
                                        requestedDeliveryDate: DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(date),
                                      );
                                });
                              },
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TimePickerField(
                              title: 'Request Delivery Time',
                              hintText: 'Select time',
                              readOnly: true,

                              initialTime:formatTime (newform.requestedDeliveryTime),
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateTransportCubit>()
                                    .onValueChanged(
                                      requestedDeliveryTime: selectedTime,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Shipping Address-1',
                        readOnly: true,
                        hintText: 'Enter Address',
                        borderColor: AppColors.grey,
                        initialValue: newform.shippingAddress1,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(shippingAddress1: value),
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Shipping Address-2',
                        readOnly: true,
                        hintText: 'Enter Address',
                        borderColor: AppColors.grey,
                        initialValue: newform.shippingAddress2,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(shippingAddress2: value),
                      ),

                      const SizedBox(height: 12),
                      InputField(
                        title: 'Shipping Country',
                        readOnly: true,
                        hintText: 'Enter Country',
                        borderColor: AppColors.grey,
                        initialValue: newform.country,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(country: value),
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Shipping State',
                        readOnly: true,
                        hintText: 'Enter State',
                        borderColor: AppColors.grey,
                        initialValue: newform.states,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(states: value),
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Shipping City',
                        readOnly: true,
                        hintText: 'Enter City',
                        borderColor: AppColors.grey,
                        initialValue: newform.city,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(city: value),
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Shipping Pin Code',
                        readOnly: true,
                        hintText: 'Enter Pincode',
                        borderColor: AppColors.grey,
                        initialValue: newform.pincode,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(pinCode: value),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Remarks',
                  assetIcon: 'assets/images/reamraksicon.png',
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
                      title: 'Any Special Instructions',
                      hintText: 'Enter Your Instructions',

                      readOnly: true,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.anySpecialInstructions,
                      onChanged:
                          (value) => context
                              .cubit<CreateTransportCubit>()
                              .onValueChanged(anySpecialInstructions: value),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Driver Details',
                  assetIcon: 'assets/images/vehicleinvoiceicon.png',
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
                          top: 20,
                          left: 16,
                          right: 16,
                          bottom: 6
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppDateField(
                              title: 'Transporter Confirmation Date',
                              hintText: 'Select Date',
                              readOnly: true,

                              startDate: DateTime(2020),
                              endDate: DateTime(2030),

                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.transporterConfirmationDate ?? '',
                              ),
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(
                                        transporterConfirmationDate: DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(date),
                                      );
                                });
                              },
                              fillColor: Colors.grey.shade100,
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'Driver Name',
                              hintText: 'Enter Driver Name',
                              isRequired: true,
                              borderColor: Colors.grey,
                              readOnly: isCompleted,
                              initialValue: newform.driverName,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(driverName: p0),
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Vehicle Number',
                              isRequired: true,
                              hintText: 'Enter Vehicle Number',
                              readOnly: isCompleted,
                              borderColor: Colors.grey,
                              initialValue: newform.vehicleNumber,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(vehicleNumber: p0),
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Driver Contact No',
                              isRequired: true,
                              hintText: 'Enter Contract Number',
                              readOnly: isCompleted,
                              borderColor: AppColors.grey,

                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              inputType: TextInputType.number,

                              initialValue: newform.driverContact,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(driverContact: p0),
                            ),
                          AppDateField(
                              title: 'Estimated Arrival Date and Time',
                              hintText: 'Select Date',
                              isRequired: true,
                              readOnly: isCompleted,
                              startDate: DateTime.now(),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyHHmmssFromStr(
                                newform.estimatedArrival ?? '',
                              ),
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(
                                        estimatedArrival: DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(date),
                                      );
                                });
                              },
                              fillColor: Colors.grey[200],
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Expanded(
                            //       child: AppDateField(
                            //         title: 'Estimated Arrival Date',
                            //         hintText: 'Select Date',
                            //         isRequired: true,
                            //         readOnly: isCompleted,
                            //         startDate: DateTime.now(),
                            //         endDate: DateTime(2030),
                            //         initialDate: DFU.ddMMyyyyFromStr(
                            //           newform.requestedDeliveryDate ?? '',
                            //         ),
                            //         onSelected: (DateTime date) {
                            //           setState(() {
                            //             selectedDate = date;
                            //             context
                            //                 .cubit<CreateTransportCubit>()
                            //                 .onValueChanged(
                            //                   estimatedArrival: DateFormat(
                            //                     'dd-MM-yyyy',
                            //                   ).format(date),
                            //                 );
                            //           });
                            //         },
                            //         fillColor: Colors.grey[200],
                            //       ),
                            //     ),
                            //     const SizedBox(width: 13),
                            //     Expanded(
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           TimePickerField(
                            //             title: 'Estimated Arrival Time',
                            //             readOnly: isCompleted,
                            //             isRequired: true,
                            //             hintText: 'Select Time',
                            //             initialTime:
                            //                 newform.requestedDeliveryTime,
                            //             onTimeChanged: (selectedTime) {
                            //               context
                            //                   .cubit<CreateTransportCubit>()
                            //                   .onValueChanged(
                            //                     estimatedArrival: selectedTime,
                            //                   );
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
                  title: 'Transporter Remarks Details',
                  assetIcon: 'assets/images/reamraksicon.png',
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
                      title: 'Transporter Remarks (if any)',
                      hintText: 'Enter Remarks',
                      readOnly: isCompleted,
                      borderColor: Colors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.transporterRemarks,
                      onChanged:
                          (value) => context
                              .cubit<CreateTransportCubit>()
                              .onValueChanged(transporterRemarks: value),
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

  // Parse backend string "HH:MM:SS"
  final parts = backendTime.split(':');
  if (parts.length < 2) return backendTime;

  return '${parts[0]}:${parts[1]}'; // HH:MM only
}