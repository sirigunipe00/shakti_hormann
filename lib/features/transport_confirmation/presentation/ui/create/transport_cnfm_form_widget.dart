import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/app_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class TransportCnfmFormWidget extends StatefulWidget {
  const TransportCnfmFormWidget({super.key});

  @override
  State<TransportCnfmFormWidget> createState() =>
      _TransportCnfmFormWidgetState();
}

class _TransportCnfmFormWidgetState extends State<TransportCnfmFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();

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
                        'assets/images/gateexiticon.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logistic Planning Details',
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
                              initialValue: newform.logisticsRequestDate,
                              isRequired: true,
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

                            BlocBuilder<TransportersList, TransportersState>(
                              builder: (_, state) {
                                final allData = state.maybeWhen(
                                  orElse: () => <TransportersForm>[],
                                  success: (data) => data,
                                );
                                final names = allData.toList();

                                return SearchDropDownList(
                                  key: UniqueKey(),
                                  color: AppColors.grey,
                                  isMandatory: true,
                                  items: names,

                                  defaultSelection:
                                      names
                                          .where(
                                            (e) =>
                                                e.name ==
                                                newform.transporterName,
                                          )
                                          .firstOrNull,
                                  title: 'Transporters',
                                  readOnly: true,
                                  hint: 'Select transporter',
                                  isloading: state.isLoading,
                                  futureRequest: (p0) async {
                                    return names;
                                  },
                                  headerBuilder:
                                      (_, item, __) =>
                                          Text(item.name.toString()),
                                  listItemBuilder:
                                      (_, item, __, ___) => CompactListTile(
                                        title: item.name ?? '',
                                      ),
                                  onSelected: (selected) {
                                    setState(() {
                                      transportersForm = selected;
                                    });
                                    context
                                        .cubit<CreateTransportCubit>()
                                        .onValueChanged(
                                          transporterName: selected.name,
                                        );
                                  },
                                  focusNode: focusNodes.elementAt(3),
                                );
                              },
                            ),

                            const SizedBox(height: 12),

                            AppDropDownWidget(
                              hint: 'Select Vehicle Type',
                              title: 'Vehicle Types',
                              isMandatory: true,

                              readOnly: true,
                              defaultSelection: newform.preferredVehicleType,
                              items: Dropdownoptions.vehicleType,
                              onSelected: (item) {
                                context
                                    .cubit<CreateTransportCubit>()
                                    .onValueChanged(preferredVehicleType: item);
                                setState(() {});
                              },
                              color: AppColors.black,
                              focusNode: focusNodes.elementAt(11),
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
                              title: 'Requested Delivery Date',
                              hintText: 'Select Date',
                              readOnly: true,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.requestedDeliveryDate,
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
                          const SizedBox(width: 13),
                          Expanded(
                            child: TimePickerField(
                              title: 'Request Delivery Time',
                              hintText: 'Select time',
                              readOnly: true,
                              initialTime: newform.requestedDeliveryTime,
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
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Address - 1',
                        readOnly: true,
                        hintText: 'Enter Address',

                        borderColor: AppColors.grey,
                        initialValue: newform.deliveryAddress,
                        onChanged:
                            (value) => context
                                .cubit<CreateTransportCubit>()
                                .onValueChanged(deliveryAddress: value),
                      ),
                    ],
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
                      hintText: 'enter your instrcution',

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
                padding: EdgeInsets.only(left: 16.0, bottom: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/vehicleinvoiceicon.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Driver Details',
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
                              title: 'Driver Name',
                              hintText: 'Enter Driver Name',
                              borderColor: AppColors.grey,
                              readOnly: isCompleted,
                              initialValue: newform.driverName,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(driverName: p0),
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Vehicle No',
                              hintText: 'Enter Vehicle Number',
                              readOnly: isCompleted,
                              borderColor: AppColors.grey,
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
                              hintText: 'Enter Contract Number',
                              readOnly: isCompleted,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, 
                                LengthLimitingTextInputFormatter(
                                  10,
                                ), 
                              ],
                              borderColor: AppColors.grey,
                              initialValue: newform.driverContact,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateTransportCubit>()
                                      .onValueChanged(driverContact: p0),
                            ),

                            const SizedBox(height: 12),
                            TimePickerField(
                              title: 'Arraival Time',
                              hintText: 'Select time',

                              readOnly: isCompleted,
                              initialTime: newform.estimatedArrival,
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateTransportCubit>()
                                    .onValueChanged(
                                      estimatedArrival: selectedTime,
                                    );
                              },
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

                      initialValue: newform.transporterRemarks,
                      onChanged:
                          (value) => context
                              .cubit<CreateTransportCubit>()
                              .onValueChanged(transporterRemarks: value),
                    ),
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
                      'Reject Reason',
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
                      title: 'If You Want Reject, Reason is Must be Enter',
                      hintText: 'enter reason...',
                      readOnly: isCompleted,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.rejectReason,
                      onChanged:
                          (value) => context
                              .cubit<CreateTransportCubit>()
                              .onValueChanged(rejectReason: value),
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
