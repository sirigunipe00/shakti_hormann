import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/vehicle_type_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/create/salesorder.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/compact_search_select.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LogisticPlanningFormWidget extends StatefulWidget {
  const LogisticPlanningFormWidget({super.key, required this.orderForm});
  final List<SalesOrderForm> orderForm;

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
    $logger.devLog('selected date.....$selectedDate');
    final formState = context.watch<CreateLogisticCubit>().state;
    final isCompleted =
        formState.view == LogisticPlanningView.completed ||
        (formState.form.docstatus == 1 ||
            formState.form.status == 'Pending From Transporter');

    final newform = formState.form;

    final salesOrders = newform.salesOrder ?? [];

    $logger.devLog('oredrform.....$newform');

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
                  title: 'Logistic Request Details',
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
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: Color(0xFFE8ECF4),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
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
                            CompactSearchSelect<String>(
                              label: 'Transport Type',
                              hint: 'Select Transport Type',
                              isRequired: true,
                              locked: isCompleted,
                              leadingIcon: Icons.local_shipping_outlined,
                              options: Dropdownoptions.transporterType,
                              value: newform.transporterType?.isNotEmpty == true
                                  ? newform.transporterType
                                  : null,
                              labelOf: (e) => e,
                              onChanged: (selected) {
                                context
                                    .cubit<CreateLogisticCubit>()
                                    .onValueChanged(transporterType: selected);
                              },
                            ),
                            const SizedBox(height: 12),
                            CompactSearchSelect<String>(
                              label: 'Dispatch Type',
                              hint: 'Select Dispatch Type',
                              isRequired: true,
                              locked: isCompleted,
                              leadingIcon: Icons.alt_route_rounded,
                              options: Dropdownoptions.dispatchType,
                              value: newform.dispatchType?.isNotEmpty == true
                                  ? newform.dispatchType
                                  : null,
                              labelOf: (e) => e,
                              onChanged: (selected) {
                                context
                                    .cubit<CreateLogisticCubit>()
                                    .onValueChanged(dispatchType: selected);
                              },
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<TransportersList, TransportersState>(
                              buildWhen:
                                  (previous, current) => previous != current,
                              builder: (_, state) {
                                final allData = state.maybeWhen(
                                  orElse: () => <TransportersForm>[],
                                  success: (data) => data,
                                );
                                final names = List<TransportersForm>.from(
                                  allData,
                                );
                                final selectedId = newform.transporterName;
                                TransportersForm? selected;
                                if (selectedId != null &&
                                    selectedId.isNotEmpty) {
                                  selected = names
                                      .where((e) => e.name == selectedId)
                                      .firstOrNull;
                                  if (selected == null) {
                                    selected = TransportersForm(
                                      name: selectedId,
                                      suppliername: newform.transporterNAme2,
                                    );
                                    names.insert(0, selected);
                                  }
                                }

                                return CompactSearchSelect<TransportersForm>(
                                  key: ValueKey(
                                    'lr_transporter_${selectedId ?? 'new'}',
                                  ),
                                  label: 'Transporter Name',
                                  hint: 'Select Transporter',
                                  isRequired: true,
                                  locked: isCompleted,
                                  isLoading: state.isLoading,
                                  leadingIcon: Icons.apartment_outlined,
                                  options: names,
                                  value: selected,
                                  labelOf: (e) => e.name ?? '',
                                  subtitleOf: (e) => e.suppliername,
                                  onChanged: (picked) {
                                    setState(() => transportersForm = picked);
                                    context
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          transporterName: picked.name,
                                        );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<VehicleList, VehicleListState>(
                              buildWhen:
                                  (previous, current) => previous != current,
                              builder: (_, state) {
                                final allData = state.maybeWhen(
                                  orElse: () => <VehicleTypeForm>[],
                                  success: (data) => data,
                                );
                                final names = List<VehicleTypeForm>.from(
                                  allData,
                                );
                                final selectedName =
                                    newform.preferredVehicleType;
                                VehicleTypeForm? selected;
                                if (selectedName != null &&
                                    selectedName.isNotEmpty) {
                                  selected = names
                                      .where((e) => e.name == selectedName)
                                      .firstOrNull;
                                  if (selected == null) {
                                    selected =
                                        VehicleTypeForm(name: selectedName);
                                    names.insert(0, selected);
                                  }
                                }

                                return CompactSearchSelect<VehicleTypeForm>(
                                  key: ValueKey(
                                    'lr_vehicle_${selectedName ?? 'new'}',
                                  ),
                                  label: 'Preferred Vehicle Type',
                                  hint: 'Select Vehicle Type',
                                  isRequired: true,
                                  locked: isCompleted,
                                  isLoading: state.isLoading,
                                  leadingIcon: Icons.directions_car_outlined,
                                  options: names,
                                  value: selected,
                                  labelOf: (e) => e.name ?? '',
                                  onChanged: (picked) {
                                    setState(() => vehicleTypeForm = picked);
                                    context
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          preferredVehicleType: picked.name,
                                        );
                                  },
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
                  title: 'Delivery Order Details',
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
                  child: SalesOrderTable(salesOrders: salesOrders),
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
                                  if (formState.form.status == 'Draft') {
                                    context
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          requestedDeliveryDate: DateFormat(
                                            'dd-MM-yyyy',
                                          ).format(date),
                                        );
                                  } else {
                                    context
                                        .cubit<CreateLogisticCubit>()
                                        .onValueChanged(
                                          requestedDeliveryDate: DateFormat(
                                            'dd-MM-yyyy',
                                          ).format(date),
                                        );
                                  }
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
                                  initialTime: formatTime(
                                    newform.requestedDeliveryTime,
                                  ),
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
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Any Special Instructions',
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
                      title: 'Any Special Instructions',
                      hintText: 'Enter Your Instructions',
                      readOnly: isCompleted,
                      controller: remarks,
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
