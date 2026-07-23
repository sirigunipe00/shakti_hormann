import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/create/shutter_packing_form_widget.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/vision_panel_filter_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewVision extends StatefulWidget {
  const NewVision({super.key});

  @override
  State<NewVision> createState() => _NewVisionState();
}

class _NewVisionState extends State<NewVision> {
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateVisionPanelCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New Accessories Packing',
                actionButton:
                    BlocBuilder<CreateVisionPanelCubit, CreateVisionPanelState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == VisionView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          isLoading: state.isLoading,
                          label: state.view.toName(),
                          onPressed: () {
                            context.cubit<CreateVisionPanelCubit>().save();
                          },
                        );
                      },
                    ),
              )
              : TitleStatusAppBar(
                    title: '  $name',
                    status: StringUtils.docStatus(status),
                    textColor: AppColors.white,
                    pageMode: PageMode2.visionPanel,
                    onSubmit: () {},
                    onReject: () {},
                    actionButton:
                        (status == 1 && !gateEntryState.isModified)
                            ? null
                            : BlocBuilder<CreateVisionPanelCubit,CreateVisionPanelState>(
                              builder: (context, state) {
                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label:
                                      state.newLines.isNotEmpty
                                          ? 'Update'
                                          : 'Submit',
                                  onPressed: () {
                                    context
                                        .cubit<CreateVisionPanelCubit>()
                                        .save();
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateVisionPanelCubit, CreateVisionPanelState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: () {
                Navigator.of(context, rootNavigator: true).pop();
                shouldAskForConfirmation.value = false;
                context.exit();
              },
            ).then((_) {
              final docName = state.form.name;
              if (!context.mounted) return;
              context.cubit<CreateVisionPanelCubit>().errorHandled();
              context.cubit<VisionLinesCubit>().request(docName);
              final gateEntryFilters = context.read<VisionPanelFilterCubit>().state;
              context.cubit<VisionPanelCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
              Navigator.pop(context, true);
              setState(() {});
            });
          }
          if (state.error.isNotNull) {
            await AppDialog.showErrorDialog(
              context,
              title: state.error?.title,
              content: state.error!.error,
              onTapDismiss: context.exit,
            );
            if (!context.mounted) return;
            context.cubit<CreateVisionPanelCubit>().errorHandled();
          }
        },
        child: ShutterPackingFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
