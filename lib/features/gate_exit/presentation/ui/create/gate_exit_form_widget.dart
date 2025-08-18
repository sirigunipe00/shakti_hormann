import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class GateExitFormWidget extends StatefulWidget {
  const GateExitFormWidget({super.key});

  @override
  State<GateExitFormWidget> createState() => _GateExitFormWidgetState();
}

class _GateExitFormWidgetState extends State<GateExitFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController remarks = TextEditingController();

  final focusNodes = List.generate(40, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateGateExitCubit>().state;

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

              final targetContext = focus.context;
              if (targetContext != null) {
                await Scrollable.ensureVisible(
                  targetContext,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
        ),
      ],
      child: Container(
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.symmetric(vertical: 20),
            defaultHeight: 8,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/gateexiticon.png',
                      ),
                    ),
                    SizedBox(width: 8),
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
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SpacedColumn(
                  defaultHeight: 6,
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
                              .cubit<CreateGateExitCubit>()
                              .onValueChanged(plantName: p0),
                    ),

                    AppDateField(
                      title: 'Gate Exit Date',
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      readOnly: true,
                      fillColor: Colors.grey[200],
                      onSelected: (date) {
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          gateEntryDate: DateFormat('dd-MM-yyyy').format(date),
                        );
                      },
                    ),

                    InputField(
                      title: 'Vehicle No',
                      hintText: 'Enter Vehicle No',
                      readOnly: isCompleted,
                      borderColor: AppColors.grey,
                      initialValue: newform.vehicleNo,
                      onChanged:
                          (p0) => context
                              .cubit<CreateGateExitCubit>()
                              .onValueChanged(vehicleNo: p0),
                      inputFormatters: [UpperCaseTextFormatter()],
                    ),

                    AppDateField(
                      title: 'Invoice Date',
                      hintText: 'Select Date',
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      readOnly: isCompleted,
                      onSelected: (date) {
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          gateEntryDate: date.toString(),
                        );
                      },

                      fillColor: Colors.grey[200],
                    ),
                  ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NewUploadPhotoWidget(
                      fileName: 'vehiclefront',
                      imageUrl: newform.vehiclePhoto,
                      title: 'Vehicle Front',
                      isRequired: true,
                      isReadOnly: isCompleted,
                      onFileCapture: (file) {
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          vehiclePhoto: file,
                        );
                      },
                      focusNode: focusNodes.elementAt(27),
                    ),
                    NewUploadPhotoWidget(
                      fileName: 'vehicleback',
                      isRequired: true,
                      imageUrl: newform.vehicleBackPhoto,
                      title: 'Vehicle Back',
                      isReadOnly: isCompleted,
                      onFileCapture: (file) {
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          vehicleBackPhoto: file,
                        );
                      },
                      focusNode: focusNodes.elementAt(27),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 200, 209, 225),
                      radius: 20,
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
                      controller: remarks,
                      minLines: 3,
                      maxLines: 6,
                      readOnly: isCompleted,
                      initialValue: newform.remarks,
                      title: 'Remarks (if any)',
                      hintText: 'Enter here....',
                      onChanged: (text) {
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          remarks: text,
                        );
                      },
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
