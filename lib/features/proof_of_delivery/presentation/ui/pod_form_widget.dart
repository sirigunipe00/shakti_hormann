import 'package:shakti_hormann/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/create_pd_cubit/create_pod_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/geolocator.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';


class PodFormWidget extends StatefulWidget {
  const PodFormWidget({super.key});

  @override
  State<PodFormWidget> createState() => _PodFormWidgetState();
}

class _PodFormWidgetState extends State<PodFormWidget> {
  final ScrollController _scrollController = ScrollController();
  DateTime? selectedDate;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _fillCurrentLocation();
  }

 void _fillCurrentLocation() async {
    final position = await determinePosition();

    if (position != null) {
      // Update local state
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      // Debug log
      $logger.devLog('Current Position: Lat=$latitude, Lng=$longitude');

      // Update Cubit state
      context.read<CreatePodCubit>().onValueChanged(
            geoLatitude: latitude,
            geoLongitude: longitude,
          );

      // Log after updating Cubit state
      final newForm = context.read<CreatePodCubit>().state.form;
      $logger.devLog(
          'Cubit Updated: geoLatitude=${newForm.geoLatitude}, geoLongitude=${newForm.geoLongitude}');
    } else {
      $logger.devLog('Could not fetch user location.');
    }
  }


  final focusNodes = List.generate(40, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreatePodCubit>().state;

    final isCompleted = formState.view == PodView.completed;
    final newform = formState.form;
    $logger.devLog('date.........${newform.salesInvoiceDate}');

    return MultiBlocListener(
      listeners: [
        BlocListener<CreatePodCubit, CreatePodState>(
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
            margin: const EdgeInsets.symmetric(vertical: 20),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Proof Of Delivery Details',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
                              .cubit<CreatePodCubit>()
                              .onValueChanged(plantName: p0),
                    ),

                    BlocBuilder<CreatePodCubit, CreatePodState>(
                      builder: (context, formState) {
                        final newform = formState.form;

                        return AppDateField(
                          key: ValueKey(newform.salesInvoiceDate),
                          title: 'Sales Invoice Date',
                          startDate: DateTime(2020),
                          endDate: DateTime(2030),
                          readOnly: true,
                          initialValue:
                              (newform.salesInvoiceDate?.isNotEmpty ?? false)
                                  ? DFU.ddMMyyyyFromStr(
                                    newform.salesInvoiceDate!,
                                  )
                                  : '',
                          fillColor: Colors.grey[200],
                          onSelected: (date) {},
                        );
                      },
                    ),

                    InputField(
                      title: 'Customer Name',
                      hintText: 'Enter Customer Name',
                      readOnly: true,
                      isRequired: true,
                      borderColor: AppColors.grey,
                      initialValue: newform.customerName,
                      onChanged:
                          (p0) => context
                              .cubit<CreatePodCubit>()
                              .onValueChanged(customerName: p0),
                    ),
                    AppDateField(
                      title: 'Proof Of Delivery Date',
                      startDate: DateTime(2020),
                      endDate: DateTime(2030),
                      readOnly: true,
                      initialValue: DFU.ddMMyyyyFromStr(newform.podDate ?? ''),
                      fillColor: Colors.grey[200],
                      onSelected: (DateTime date) {
                        //   selectedDate = date;

                        // context.cubit<CreatePodCubit>().onValueChanged(
                        //   podDate: DateFormat('dd-MM-yyyy').format(date),
                        // );
                      },
                    ),
                    BlocBuilder<CreatePodCubit, CreatePodState>(
                      builder: (context, state) {
                        return InputField(
                                          title: 'Latitude',
                                          hintText: 'Latitude',
                                          readOnly: true,
                                          isRequired: true,
                                          borderColor: AppColors.grey,
                                          initialValue: latitude?.toString() ?? newform.geoLatitude?.toString() ?? '',
                                          onChanged:
                                              (p0) => context
                                                  .cubit<CreatePodCubit>()
                                                  .onValueChanged(geoLatitude: double.tryParse(p0)),
                                        );
                      },
                    ),
                    BlocBuilder<CreatePodCubit, CreatePodState>(
                      builder: (context, state) {
                        return InputField(
                          title: 'Longitude',
                          hintText: 'Longitude',
                          readOnly: true,
                          isRequired: true,
                          borderColor: AppColors.grey,
                          initialValue:  longitude?.toString() ??  newform.geoLongitude?.toString() ?? '',
                          onChanged:
                              (p0) => context
                                  .cubit<CreatePodCubit>()
                                  .onValueChanged(
                                    geoLongitude: double.tryParse(p0),
                                  ),
                        );
                      },
                    ),
                  ],
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
                padding: const EdgeInsets.only(left: 16, right: 16),
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
                        fileName: 'vehicleinvoice',
                        imageUrl: newform.podPhoto,
                        title: 'Pod Photo',
                        isRequired: true,
                        isReadOnly: isCompleted,
                        onFileCapture: (file) {
                          context.cubit<CreatePodCubit>().onValueChanged(
                            podPhoto: file,
                          );
                        },
                        focusNode: focusNodes.elementAt(27),
                      ),
                      NewUploadPhotoWidget(
                        fileName: 'vehiclefront',
                        isRequired: true,
                        imageUrl: newform.unloadingPhoto1,
                        title: 'UnLoading 1',
                        isReadOnly: isCompleted,
                        onFileCapture: (file) {
                          context.cubit<CreatePodCubit>().onValueChanged(
                            unloadingPhoto1: file,
                          );
                        },
                        focusNode: focusNodes.elementAt(27),
                      ),
                      NewUploadPhotoWidget(
                        fileName: 'vehicleback',
                        // isRequired: true,
                        imageUrl: newform.unloadingPhoto2,
                        title: 'UnLoading 2',
                        isReadOnly: isCompleted,
                        onFileCapture: (file) {
                          context.cubit<CreatePodCubit>().onValueChanged(
                            unloadingPhoto2: file,
                          );
                        },
                        focusNode: focusNodes.elementAt(27),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 12),
              // const Padding(
              //   padding: EdgeInsets.only(left: 16.0),
              //   child: SectionHeader(
              //     title: 'Remarks',
              //     assetIcon: 'assets/images/reamraksicon.png',
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              //   child: Card(
              //     color: Colors.white,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //       side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
              //     ),
              //     elevation: 0,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InputField(
              //         controller: remarks,
              //         minLines: 3,
              //         maxLines: 6,
              //         readOnly: isCompleted,
              //         initialValue: newform.remarks,
              //         title: 'Remarks (if any)',
              //         hintText: 'Enter Here....',
              //         onChanged: (text) {
              //           context.cubit<CreateGateExitCubit>().onValueChanged(
              //             remarks: text,
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
