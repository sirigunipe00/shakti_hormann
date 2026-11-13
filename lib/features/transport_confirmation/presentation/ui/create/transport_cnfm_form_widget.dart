import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/create/salesorder.dart';
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
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController driverContactController = TextEditingController();
  final TextEditingController remarks = TextEditingController();

  final focusNodes = List.generate(40, (index) => FocusNode());
  TransportersForm? transportersForm;
  DateTime? selectedDate;
  bool? isRejectedMode = false;
  String? _driverContactError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final contact =
          context.read<CreateTransportCubit>().state.form.driverContact;
      if (contact != null && contact.isNotEmpty) {
        setState(() => _driverContactError = _contactErrorFor(contact));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateTransportCubit>().state;
    final isCompleted = formState.view == TransportView.completed;

    final newform = formState.form;
    $logger.devLog('............$newform');
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
        color: const Color(0xFFF7F8FA),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: ShellInsets.scrollPadding(context),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(12.0),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Logistic Planning Details',
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
                          bottom: 6,
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
                              title: 'Transport Type',

                              readOnly: true,

                              borderColor: AppColors.grey,
                              initialValue: newform.transporterType,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(transportType: p0),
                            ),
                            const SizedBox(height: 12.0),
                            InputField(
                              title: 'Dispatch Type',

                              readOnly: true,

                              borderColor: AppColors.grey,
                              initialValue: newform.dispatchType,

                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(dispatchType: p0),
                            ),

                            // if (newform.transporterType == 'Hormann') ...[
                              const SizedBox(height: 12),
                              InputField(
                                title: 'Transporter',
                                isRequired: true,
                                readOnly: true,
                                borderColor: AppColors.grey,
                                initialValue: [
                                      newform.transporterName,
                                      newform.transporterName2,
                                    ]
                                    .where((e) => e != null && e.isNotEmpty)
                                    .join(' - '),
                                onChanged:
                                    (p0) => context
                                        .cubit<CreateTransportCubit>()
                                        .onValueChanged(transporterName: p0),
                              ),
                            // ],

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Preferred Vehicle Type',

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
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<SalesOrders, SalesState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        success: (data) {
                          context.read<CreateTransportCubit>().addsaleseorders(
                            salesorder: data,
                          );
                          return SalesOrderTable(salesOrders: data);
                        },
                        orElse: () =>
                            const SalesOrderTable(salesOrders: []),
                      );
                    },
                  ),
                ),
              ),

              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Request Delivery Date',
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
                              hintText: 'Select Time',
                              readOnly: true,

                              initialTime: formatTime(
                                newform.requestedDeliveryTime,
                              ),
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Remarks',
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
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                                  transporterConfirmationDate:
                                      DateFormat('dd-MM-yyyy').format(date),
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
                        controller: driverNameController,
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
                        controller: vehicleNumberController,
                        borderColor: Colors.grey,
                        initialValue: newform.vehicleNumber,
                        onChanged:
                            (p0) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(vehicleNumber: p0),
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
                        isRequired: true,
                        controller: driverContactController,
                        hintText: 'Enter 10-digit Contact Number',
                        readOnly: isCompleted,
                        borderColor: _driverContactError != null
                            ? Colors.red
                            : AppColors.grey,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        inputType: TextInputType.phone,
                        initialValue: newform.driverContact,
                        onChanged: (p0) {
                          setState(() {
                            _driverContactError = _contactErrorFor(p0);
                          });
                          context
                              .cubit<CreateTransportCubit>()
                              .onValueChanged(driverContact: p0);
                        },
                      ),
                      if (_driverContactError != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _driverContactError!,
                          style: const TextStyle(
                            color: Color(0xFFE11D48),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Arrival Date',
                              hintText: 'Select Date',
                              isRequired: true,
                              readOnly: isCompleted,
                              startDate: DateTime.now(),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.estimatedArrivalDate ?? '',
                              ),
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(
                                        estimatesdArrivalDate:
                                            DateFormat('dd-MM-yyyy')
                                                .format(date),
                                      );
                                });
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
                              initialTime: formatTime(
                                newform.estimatedArrivalTime,
                              ),
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateTransportCubit>()
                                    .onValueChanged(
                                      estimatedArrivalTime: selectedTime,
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Transporter Remarks',
                  assetIcon: 'assets/images/remarksicon.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
                      controller: remarks,
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

String? _contactErrorFor(String? value) {
  final contact = value?.trim() ?? '';
  if (contact.isEmpty) return 'Contact number is required';
  if (contact.length < 10) {
    return 'Enter a complete 10-digit mobile number';
  }
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(contact)) {
    return 'Mobile number must start with 6, 7, 8 or 9';
  }
  return null;
}
