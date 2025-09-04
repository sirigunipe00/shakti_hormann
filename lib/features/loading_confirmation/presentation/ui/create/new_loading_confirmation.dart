import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/loading_cnfm_filters_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/create/loading_cnfm_form_widget.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewLoadingConfirmation extends StatefulWidget {
  const NewLoadingConfirmation({super.key});

  @override
  State<NewLoadingConfirmation> createState() => _NewLoadingConfirmationState();
}

class _NewLoadingConfirmationState extends State<NewLoadingConfirmation> {
  VehicleReportingForm? vehicleReportingForm;

  @override
  Widget build(BuildContext context) {
    final loadingState = context.watch<CreateLoadingCnfmCubit>().state;

    // final isCreating = vehicleState.view == VehicleView.create;

    final newform = loadingState.form;
    final status = newform.docstatus;
    final name = newform.name;

    final isNew = loadingState.view == LoadingView.create;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Loading Confirmation',
                actionButton:
                    BlocBuilder<CreateLoadingCnfmCubit, CreateLaodingCnfmState>(
                      builder: (context, state) {
                        return AppButton(
                          label: state.view.toName(),
                          bgColor: const Color.fromARGB(255, 250, 193, 47),
                          textStyle: const TextStyle(color: AppColors.darkBlue,fontWeight: FontWeight.bold,fontSize: 15),
                          isLoading: state.isLoading,
                          borderColor: Colors.grey,
                          onPressed: context.read<CreateLoadingCnfmCubit>().save,
                        );
                      },
                    ),
                dropdown: const SizedBox(),
              )
              : TitleStatusAppBar(
                    title: name ?? '',
                    status: StringUtils.docStatus(status ?? 0),
                    textColor: Colors.white,
                    actionButton: loadingState.form.docstatus == 1 ? null :
                    BlocBuilder<CreateLoadingCnfmCubit, CreateLaodingCnfmState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          label: state.view.toName(),
                          isLoading: state.isLoading,
                          onPressed: () =>{
                            context.read<CreateLoadingCnfmCubit>().save(),
                          } 
                        );
                      },
                    ),
                    pageMode: PageMode2.loadingConfirmation,
                    showRejectButton: false,
                    onSubmit: () {},
                    onReject: () {},
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateLoadingCnfmCubit, CreateLaodingCnfmState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateLoadingCnfmCubit>().errorHandled();

              final vehicleFilters =
                  context.read<LoadingCnfmFiltersCubit>().state;
              context.cubit<LoadingCnfmCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusVehicle(vehicleFilters.status),
                  vehicleFilters.query,
                ),
              );
              Navigator.pop(context, true);
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
            context.cubit<CreateLoadingCnfmCubit>().errorHandled();
          }
        },
        child: LoadingCnfmFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
