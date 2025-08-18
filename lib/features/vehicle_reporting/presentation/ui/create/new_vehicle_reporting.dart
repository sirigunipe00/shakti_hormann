import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/vehicle_reporting_filtercubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/ui/create/vehicle_reporting_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewVehicleReporting extends StatefulWidget {
  const NewVehicleReporting({super.key});

  @override
  State<NewVehicleReporting> createState() => _NewVehicleReportingState();
}

class _NewVehicleReportingState extends State<NewVehicleReporting> {
  LogisticPlanningForm? logisticForm;

  @override
  Widget build(BuildContext context) {
    final vehicleState = context.read<CreateVehicleCubit>().state;

    final isCreating = vehicleState.view == VehicleView.create;

    final newform = vehicleState.form;
    final status = newform.docstatus;
    final name = newform.name;

    final isNew = vehicleState.view == VehicleView.create;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Vehicle Reporting',
                actionButton: AppButton(
                  label: isCreating ? 'Create' : 'Update',

                  onPressed: context.cubit<CreateVehicleCubit>().save,
                ),
                dropdown: BlocBuilder<LogisticRequest, LogisticRequestState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <LogisticPlanningForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<LogisticPlanningForm>(
                      title: 'Logistic Request No',
                      hint: 'Search Logistic No',
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      futureRequest: (query) async {
                        return names.toList();
                      },
                      headerBuilder: (_, item, __) => Text(item.name),
                      listItemBuilder:
                          (_, item, __, ___) =>
                              CompactListTile(title: item.name),
                      onSelected: (selected) {
                        setState(() {
                          logisticForm = selected;
                        });
                        context.cubit<CreateVehicleCubit>().onValueChanged(
                          plantName: selected.plantName,
                          transporterName: selected.transporterName,
                          
                          linkedTransporterConfirmation: selected.name
                        );
                      },

                      focusNode: FocusNode(),
                    );
                  },
                ),
              )
              : TitleStatusAppBar(
                    title: name ?? '',
                    status: StringUtils.docStatus(status ?? 0),

                    onSubmit:
                        status == 'Reported'
                            ? () {}
                            : () {
                              context.cubit<CreateVehicleCubit>().save();
                            },
                    onReject: status == 'Rejected' ? () {} : () {},
                    textColor: Colors.white,
                    pageMode: PageMode2.vehicleReporting,
                    showRejectButton: false,
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateVehicleCubit, CreateVehicleState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateVehicleCubit>().errorHandled();

              final vehicleFilters =
                  context.read<VehicleReportingFilterCubit>().state;
              context.cubit<VehicleReportingCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(vehicleFilters.status),
                  vehicleFilters.query,
                ),
              );
              Navigator.pop(context);
              setState(() {});
            });
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
