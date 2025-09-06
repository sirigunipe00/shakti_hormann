import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/vehicle_type_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LogisticPlanningFormWidget extends StatefulWidget {
  const LogisticPlanningFormWidget({super.key});

  @override
  State<LogisticPlanningFormWidget> createState() =>
      __LogisticPlanningFormWidgetState();
}

class __LogisticPlanningFormWidgetState
    extends State<LogisticPlanningFormWidget> {
  TransportersForm? transportersForm;
  VehicleTypeForm? vehicleTypeForm;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  DateTime? selectedDate;

  final focusNodes = List.generate(40, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateLogisticCubit>().state;
    final isCompleted =
        formState.view == LogisticPlanningView.completed ||
        (formState.form.docstatus == 1 ||
            formState.form.status == 'Pending From Transporter');

    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateLogisticCubit, CreateLogisticState>(
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
                  title: 'Logistic Request Details',
                  assetIcon: 'assets/images/gateentryicon.png',
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
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              isRequired: true,
                              readOnly: true,
                              title: 'Plant Name',
                              hintText: 'Enter Plant Name',
                              borderColor: AppColors.grey,
                              initialValue: newform.plantName,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateLogisticCubit>()
                                      .onValueChanged(plantName: p0),
                            ),

                            const SizedBox(height: 12),

                            AppDateField(
                              title: 'Logistic Request Date',
                              readOnly: true,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              fillColor: Colors.grey[200],
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.logisticsRequestDate ?? '',
                              ),
                              onSelected: (date) {
                                context
                                    .cubit<CreateLogisticCubit>()
                                    .onValueChanged(
                                      logisticsRequestDate: date.toString(),
                                    );
                              },
                            ),

                            const SizedBox(height: 12),

                            BlocBuilder<TransportersList, TransportersState>(
                              builder: (_, state) {
                                final allData = state.maybeWhen(
                                  orElse: () => <TransportersForm>[],
                                  success: (data) {
                                    return data;
                                  },
                                );
                                final names = allData.toList();

                                return SearchDropDownList(
                                  key: UniqueKey(),
                                  readOnly: isCompleted,
                                  color: AppColors.black,
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
                                  hint: 'Select transporter',
                                  isloading: state.isLoading,
                                  futureRequest: (searchText) async {
                                    if (searchText.trim().isEmpty) {
                                      return names;
                                    }
                                    final query =
                                        searchText.trim().toLowerCase();
                                    final filtered =
                                        names.where((item) {
                                          final value =
                                              item.name?.toLowerCase() ?? '';
                                          return value.contains(query);
                                        }).toList();
                                    return filtered;
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
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          transporterName: selected.name,
                                        );
                                  },
                                  focusNode: focusNodes.elementAt(3),
                                );
                              },
                            ),

                            const SizedBox(height: 12),
                            BlocBuilder<VehicleList, VehicleListState>(
                              builder: (_, state) {
                                final allData = state.maybeWhen(
                                  orElse: () => <VehicleTypeForm>[],
                                  success: (data) {
                                    return data;
                                  },
                                );
                                final names = allData.toList();

                                return SearchDropDownList(
                                  key: UniqueKey(),
                                  readOnly: isCompleted,
                                  color: AppColors.black,
                                  items: names,

                                  defaultSelection:
                                      names
                                          .where(
                                            (e) =>
                                                e.name ==
                                                newform.preferredVehicleType,
                                          )
                                          .firstOrNull,
                                  title: 'Vehicle Type',
                                  hint: 'Select Vehicle Type',
                                  isloading: state.isLoading,
                                  futureRequest: (searchText) async {
                                    if (searchText.trim().isEmpty) {
                                      return names;
                                    }
                                    final query =
                                        searchText.trim().toLowerCase();
                                    final filtered =
                                        names.where((item) {
                                          final value =
                                              item.name?.toLowerCase() ?? '';
                                          return value.contains(query);
                                        }).toList();
                                    return filtered;
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
                                      vehicleTypeForm = selected;
                                    });
                                    context
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          preferredVehicleType: selected.name,
                                        );
                                  },
                                  focusNode: focusNodes.elementAt(3),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Request Delivery Date',
                              hintText: 'Select Date',
                              isRequired: true,
                              readOnly: isCompleted,
                              startDate: DateTime.now(),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.requestedDeliveryDate ?? '',
                              ),
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateLogisticCubit>()
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TimePickerField(
                                  title: 'Request Delivery Time',
                                  readOnly: isCompleted,
                                  isRequired: true,
                                  hintText: 'Select Time',
                                  initialTime: formatTime(newform.requestedDeliveryTime),
                                  onTimeChanged: (selectedTime) {
                                    context
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          requestedDeliveryTime: selectedTime,
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      InputField(
                        title: 'Shipping Address-1',
                        readOnly: true,
                        // hintText: 'Enter Address',
                        borderColor: AppColors.grey,
                        initialValue: newform.shippingAddress1,
                        onChanged:
                            (value) => context
                                .cubit<CreateLogisticCubit>()
                                .onValueChanged(shippingAddress1: value),
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Shipping Address-2',
                        readOnly: true,
                        // hintText: 'Enter Address',
                        borderColor: AppColors.grey,
                        initialValue: newform.shippingAddress2,
                        onChanged:
                            (value) => context
                                .cubit<CreateLogisticCubit>()
                                .onValueChanged(shippingAddress2: value),
                      ),

                      const SizedBox(height: 16),
                      InputField(
                        title: 'Shipping Country',
                        readOnly: true,
                        // hintText: 'Enter Country',
                        borderColor: AppColors.grey,
                        initialValue: newform.country,
                        onChanged:
                            (value) => context
                                .cubit<CreateLogisticCubit>()
                                .onValueChanged(country: value),
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Shipping State',
                        readOnly: true,
                        // hintText: 'Enter State',
                        borderColor: AppColors.grey,
                        initialValue: newform.states,
                        onChanged:
                            (value) => context
                                .cubit<CreateLogisticCubit>()
                                .onValueChanged(states: value),
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Shipping City',
                        readOnly: true,
                        // hintText: 'Enter City',
                        borderColor: AppColors.grey,
                        initialValue: newform.city,
                        onChanged:
                            (value) => context
                                .cubit<CreateLogisticCubit>()
                                .onValueChanged(city: value),
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        title: 'Shipping Pin Code',
                        readOnly: true,
                        // hintText: 'Enter Pincode',
                        borderColor: AppColors.grey,
                        initialValue: newform.pincode,
                        onChanged:
                            (value) => context
                                .cubit<CreateLogisticCubit>()
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
                  title: 'Any Special Instructions',
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
                      readOnly: isCompleted,
                      borderColor: AppColors.grey,
                      maxLines: 3,
                      minLines: 3,

                      initialValue: newform.anySpecialInstructions,
                      onChanged:
                          (value) => context
                              .cubit<CreateLogisticCubit>()
                              .onValueChanged(anySpecialInstructions: value),
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