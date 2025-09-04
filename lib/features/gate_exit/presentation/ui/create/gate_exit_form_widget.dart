import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
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
      
          },
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withValues(alpha: 0.15),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.symmetric(vertical: 20),
            defaultHeight: 0,
            children: [
               const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Gate Exit Details',
                  assetIcon: 'assets/images/gateexiticon.png',
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 12,left: 12,right: 12,),
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
                      initialValue: DFU.ddMMyyyyFromStr(newform.gateEntryDate?? ''),
                      fillColor: Colors.grey[200],
                      onSelected: (date) {
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          gateEntryDate: DateFormat('dd-MM-yyyy').format(date),
                        );
                      },
                    ),

                    InputField(
                      title: 'Vehicle Number',
                      hintText: 'Enter Vehicle No',
                      readOnly: isCompleted,
                      isRequired: true,
                      borderColor: AppColors.grey,
                      initialValue: newform.vehicleNo,
                      onChanged:
                          (p0) => context
                              .cubit<CreateGateExitCubit>()
                              .onValueChanged(vehicleNo: p0),
                      inputFormatters: [UpperCaseTextFormatter()],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
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
                        title: 'Vehicle Front Photo',
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
                        title: 'Vehicle Back Photo',
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
              ),
              const SizedBox(height: 12),
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
                      controller: remarks,
                      minLines: 3,
                      maxLines: 6,
                      readOnly: isCompleted,
                      initialValue: newform.remarks,
                      title: 'Remarks (if any)',
                      hintText: 'Enter Here....',
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
