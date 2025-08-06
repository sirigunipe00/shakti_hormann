import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/photo_widget.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class GateExitFormWidget extends StatefulWidget {
  final SalesInvoiceForm? form;
  const GateExitFormWidget({super.key, required this.form});

  @override
  State<GateExitFormWidget> createState() => _GateExitFormWidgetState();
}

class _GateExitFormWidgetState extends State<GateExitFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();

  String? vehicleNumber;
  String? plantName;

  @override
  void initState() {
    if (widget.form != null) {
      vehicleNumber = widget.form!.vehicleNo;
      plantName = widget.form!.companyName;
    }

    print("vehicle no......$vehicleNumber");

    context.cubit<CreateGateExitCubit>().onValueChanged(
      vehicleNo: vehicleNumber,
    );

    super.initState();
  }

  final focusNodes = List.generate(40, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    bool hasScanValue = false;

    final formState = context.read<CreateGateExitCubit>().state;
    final isCreating = formState.view == GateExitView.create;
    final isCompleted = formState.view == GateExitView.completed;
    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateGateExitCubit, CreateGateExitState>(
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
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          Colors.transparent, // No background color
                      backgroundImage: AssetImage(
                        'assets/images/gateexiticon.png',
                      ), // Use backgroundImage
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Gate Exit Details',
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
                        side: BorderSide(
                          color: Color(0xFFE8ECF4), // your border color
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
                          // bottom: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BlocBuilder<
                            //   CompanyNameList,
                            //   NetworkRequestState<List<String>>
                            // >(
                            //   builder: (_, state) {
                            //     final names = state.maybeWhen(
                            //       orElse: () => <String>[],
                            //       success: (data) => data,
                            //     );
                            //     return SearchDropDownList(
                            //       color: Color(0xFF0E1446),
                            //       isMandatory: true,
                            //       items: names,

                            //       key: UniqueKey(),
                            //       defaultSelection:
                            //           names
                            //               .where((e) => e == newform.plantName)
                            //               .firstOrNull,
                            //       title: 'Plant Name',
                            //       hint: 'Select Plant Name',
                            //       readOnly: isCompleted,
                            //       isloading: state.isLoading,
                            //       futureRequest: (p0) async {
                            //         final where = names.where(
                            //           (e) => e.containsIgnoreCase(p0),
                            //         );
                            //         return where.toList();
                            //       },
                            //       headerBuilder: (_, item, __) => Text(item),
                            //       listItemBuilder:
                            //           (_, item, __, ___) =>
                            //               CompactListTile(title: item),
                            //       onSelected: (names) {
                            //         context
                            //             .cubit<CreateGateExitCubit>()
                            //             .onValueChanged(plantName: names);
                            //       },
                            //       focusNode: focusNodes.elementAt(0),
                            //     );
                            //   },
                            // ),
                            InputField(
                              title: 'Plant Name',
                              hintText: 'Enter Plant Name',
                              borderColor: AppColors.grey,
                              initialValue: newform.plantName,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateGateExitCubit>()
                                      .onValueChanged(plantName: p0),
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Gate Exit No',
                              hintText: 'Enter Gate Exit No',
                              borderColor: AppColors.grey,
                              initialValue: newform.name,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateGateExitCubit>()
                                      .onValueChanged(name: p0),
                            ),

                            const SizedBox(height: 12),

                            AppDateField(
                              title: 'Gate Exit Date',

                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.gateEntryDate,
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateGateExitCubit>()
                                      .onValueChanged(
                                        gateEntryDate: DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(date),
                                      );
                                });
                              },
                              hintText: 'Select Date',
                              isRequired: true,
                              fillColor: Colors.grey[200],
                            ),

                            const SizedBox(height: 12),

                            InputField(
                              title: 'Vehicle No',
                              hintText: 'Enter Vehicle No',
                              borderColor: AppColors.grey,
                              initialValue: newform.vehicleNo,
                              onChanged:
                                  (p0) => context
                                      .cubit<CreateGateExitCubit>()
                                      .onValueChanged(vehicleNo: p0),
                            ),
                            const SizedBox(height: 12),
                            AppDateField(
                              title: 'Invoice Date',
                              hintText: 'Select Date',

                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: newform.gateEntryDate,
                              onSelected: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  context
                                      .cubit<CreateGateExitCubit>()
                                      .onValueChanged(
                                        gateEntryDate: DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(date),
                                      );
                                });
                              },

                              isRequired: true,
                              fillColor: Colors.grey[200],
                            ),
                            //                   AppDropDownWidget(

                            //   defaultSelection: newform.,
                            //   readOnly: isCompleted,
                            //   title: 'Pay Type',
                            //   hint: 'Select Pay Type',
                            //   color: AppColors.marigoldDDust,
                            //   items: const ['Hours', 'Qty'],
                            //   focusNode: focusNodes.elementAt(7),
                            //   onSelected: (value) {
                            //     setState(() {
                            //       payType = value;
                            //     });

                            //     context
                            //         .cubit<CreateGateEntryCubit>()
                            //         .onValueChanged(payType: value);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 30,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF263238),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                  side: BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PhotoSelectionWidget(
                      label: "Vehicle Front",
                      imagePath: 'assets/images/vehiclefront.png',

                      backgroundColor: Colors.teal.shade50,
                      onImageSelected:
                          (file) => context
                              .cubit<CreateGateEntryCubit>()
                              .onValueChanged(vehiclePhoto: file),
                    ),
                    PhotoSelectionWidget(
                      label: "Vehicle Back",
                      imagePath: 'assets/images/vehicleback.png',
                      initialValue: newform.vehicleBackPhoto,

                      backgroundColor: Colors.orange.shade50,
                      onImageSelected:
                          (file) => context
                              .cubit<CreateGateEntryCubit>()
                              .onValueChanged(vehicleBackPhoto: file),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4),
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
                    const SizedBox(width: 8),
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
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  0,
                ), // reduced top padding to 0
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputField(
                      readOnly: isCompleted,
                      controller: remarks,
                      minLines: 3,
                      maxLines: 6,
                      initialValue: newform.remarks,
                      title: 'Remarks (if any)',
                      onChanged: (text) {
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          remarks: text,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // if (!isCompleted) ...[
              //   BlocBuilder<CreateGateEntryCubit, CreateGateEntryState>(
              //     builder:
              //         (_, state) => AppButton(
              //           label: isCreating ? 'Create' : 'Submit',
              //           isLoading: state.isLoading,
              //           bgColor: AppColors.darkBlue,
              //           onPressed: context.cubit<CreateGateEntryCubit>().save,
              //         ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
