import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/app/presentation/widgets/drop_down_optn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/app_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  DateTime? selectedDate;

  final focusNodes = List.generate(40, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateLogisticCubit>().state;
    final isCompleted = formState.view == LogisticPlanningView.completed;
    final newform = formState.form;
  
  

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateLogisticCubit, CreateLogisticState>(
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
                                  color: AppColors.grey,
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

                            AppDropDownWidget(
                              hint: 'Select Vehicle Type',
                              title: 'Vehicle Types',
                              readOnly: isCompleted,
                              defaultSelection: newform.preferredVehicleType,
                              items: Dropdownoptions.vehicleType,
                              futureRequest: (searchText) async {
                                if (searchText.trim().isEmpty) {
                                  return Dropdownoptions.vehicleType;
                                }

                                final filtered =
                                    Dropdownoptions.vehicleType.where((item) {
                                      final query =
                                          searchText.trim().toLowerCase();
                                      final value =
                                          item.toString().toLowerCase();
                                      return value.contains(query);
                                    }).toList();

                                return filtered;
                              },
                              onSelected: (item) {
                                context
                                    .cubit<CreateLogisticCubit>()
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
                              readOnly: isCompleted,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.requestedDeliveryDate,
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
                            child: TimePickerField(
                              title: 'Request Delivery Time',
                              readOnly: isCompleted,
                              hintText: 'Select time',
                              initialTime: newform.requestedDeliveryTime,
                              onTimeChanged: (selectedTime) {
                                context
                                    .cubit<CreateLogisticCubit>()
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
                                .cubit<CreateLogisticCubit>()
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
                      'Any Special Instructions',
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
