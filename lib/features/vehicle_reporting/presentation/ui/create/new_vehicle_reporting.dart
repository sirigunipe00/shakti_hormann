import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/ui/create/vehicle_reporting_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/rejectreasondailog.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewVehicleReporting extends StatefulWidget {
  const NewVehicleReporting({super.key});

  @override
  State<NewVehicleReporting> createState() => _NewVehicleReportingState();
}

class _NewVehicleReportingState extends State<NewVehicleReporting> {
  TransportConfirmationForm? transporterForm;

  @override
  Widget build(BuildContext context) {
    final vehicleState = context.read<CreateVehicleCubit>().state;

    // final isCreating = vehicleState.view == VehicleView.create;

    final newform = vehicleState.form;
    final status = newform.status;
    final name = newform.name;

    final isNew = vehicleState.view == VehicleView.create;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Vehicle Reporting',
                actionButton:
                    BlocBuilder<CreateVehicleCubit, CreateVehicleState>(
                      builder: (context, state) {
                        return AppButton(
                          label: state.view.toName(),
                          isLoading: state.isLoading,
                          bgColor:
                              state.view == VehicleView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          borderColor: Colors.grey,
                          onPressed: context.cubit<CreateVehicleCubit>().save,
                        );
                      },
                    ),
                dropdown: BlocBuilder<LogisticRequest, LogisticRequestState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <TransportConfirmationForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<TransportConfirmationForm>(
                      title: 'Logistic Request No',
                      hint: 'Search Logistic No',
                      color: AppColors.white,
                      key: UniqueKey(),
                      defaultSelection: transporterForm,
                      items: names,
                      isloading: state.isLoading,
                      futureRequest: (query) async {
                        if (query.isEmpty) return names;

                        return names.where((item) {
                          final orderNo = item.name?.toLowerCase() ?? '';
                          final customer =
                              item.vehicleNumber?.toLowerCase() ?? '';
                          final transporter =
                              item.transporterName?.toLowerCase() ?? '';
                          final search = query.toLowerCase();

                          return orderNo.contains(search) ||
                              customer.contains(search) ||
                              transporter.contains(search);
                        }).toList();
                      },

                      headerBuilder:
                          (_, item, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(item.name ?? '')],
                          ),
                      listItemBuilder:
                          (_, item, __, ___) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Logistic No: ${item.name ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.transporterName != null)
                                Text(
                                  'Transporter Name : ${item.transporterName}',
                                ),
                              Text('Vehicle No: ${item.vehicleNumber ?? ''}'),
                              const Divider(height: 8),
                            ],
                          ),

                      onSelected: (selected) {
                        setState(() {
                          transporterForm = selected;
                        });
                        context.cubit<CreateVehicleCubit>().onValueChanged(
                          plantName: selected.plantName,
                          transporterName: selected.transporterName,
                          vehicleNo: selected.vehicleNumber,
                          linkedTransporterConfirmation: selected.name,
                          driverContact: selected.driverContact,
                        );
                      },
                      focusNode: FocusNode(),
                    );
                  },
                ),
                showScanner: false,
              )
              : TitleStatusAppBar(
                    title: name ?? '',
                    status: status ?? '',
                    textColor: Colors.white,

                    pageMode: PageMode2.vehicleReporting,
                    showRejectButton: true,
                    onSubmit: () {
                      context.cubit<CreateVehicleCubit>().approve();
                    },
                    onReject: () {
                      showRejectDialogs(context);
                    },
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateVehicleCubit, CreateVehicleState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            final isReject = state.successMsg!.toLowerCase().contains('reject');

            if (isReject) {
              AppDialog.showErrorDialog(
                context,
                title: 'Transporter Rejected',
                content: state.successMsg.valueOrEmpty,
                onTapDismiss: context.exit,
              ).then((_) {
                if (!context.mounted) return;
                context.cubit<CreateVehicleCubit>().errorHandled();
                Navigator.pop(context, true);
              });
            } else {
              AppDialog.showSuccessDialog(
                context,
                title: 'Success',
                content: state.successMsg.valueOrEmpty,
                onTapDismiss: context.exit,
              ).then((_) {
                if (!context.mounted) return;
                context.cubit<CreateVehicleCubit>().errorHandled();
                Navigator.pop(context, true);
              });
            }
          }

          if (state.error.isNotNull) {
            await AppDialog.showErrorDialog(
              context,
              title: state.error!.title,
              content: state.error!.error,
              onTapDismiss: context.exit,
            );
            if (!context.mounted) return;
            context.cubit<CreateVehicleCubit>().errorHandled();
          }
        },
        child: VehicleReportingFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
