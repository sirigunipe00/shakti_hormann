import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/create_installation_entry_cubit/create_installation_entry_cubit.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/installation_filter_cubit.dart';
import 'package:shakti_hormann/features/installation/presentation/ui/installation_entry_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewInstallationEntry extends StatefulWidget {
  const NewInstallationEntry({super.key});

  @override
  State<NewInstallationEntry> createState() => _NewInstallationEntryState();
}

class _NewInstallationEntryState extends State<NewInstallationEntry> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateInstallationEntryCubit, CreateInstallationState>(
      builder: (context, gateEntryState) {
        final newform = gateEntryState.form;
        final status = newform.docStatus;
        final name = newform.name;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: status == null
              ? SimpleAppBar(
                  title: 'New Installation Packing',
                  actionButton: BlocBuilder<CreateInstallationEntryCubit,
                      CreateInstallationState>(
                    builder: (context, state) {
                      final form = state.form;
                      final alreadyCreated =
                          form.name != null && form.name!.isNotEmpty;
                      if (alreadyCreated) return const SizedBox.shrink();

                      final canSave =
                          (form.salesOrderNo?.trim().isNotEmpty ?? false) &&
                              (form.noOfBoxes ?? 0) > 0;

                      return AppButton(
                        borderColor: Colors.grey,
                        bgColor: const Color.fromARGB(255, 250, 193, 47),
                        textStyle: const TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        isLoading: state.isLoading,
                        label: 'Save',
                        onPressed: canSave
                            ? () => context
                                .cubit<CreateInstallationEntryCubit>()
                                .createEntry()
                            : null,
                      );
                    },
                  ),
                )
              : TitleStatusAppBar(
                  title: '$name',
                  status: StringUtils.docStatus(status),
                  textColor: AppColors.white,
                  pageMode: PageMode2.installation,
                  onSubmit: () {},
                  onReject: () {},
                  actionButton: (status == 1 && !gateEntryState.isModified)
                      ? null
                      : BlocBuilder<CreateInstallationEntryCubit,
                          CreateInstallationState>(
                          builder: (context, state) {
                            final cubit = context.cubit<CreateInstallationEntryCubit>();
                            
                            // Button is only enabled once all box photos are captured and uploaded (isUpdated)
                            final bool canSubmit = state.isUpdated && !state.isLoading;

                            return AppButton(
                              borderColor: Colors.grey,
                              isLoading: state.isLoading,
                              label: state.newLines.isNotEmpty
                                  ? 'Update'
                                  : 'Submit',
                              onPressed: canSubmit
                                  ? () {
                                      cubit.submit();
                                    }
                                  : null, // Keeps button disabled until all images are captured
                            );
                          },
                        ),
                ) as PreferredSizeWidget,
          body: BlocListener<CreateInstallationEntryCubit,
              CreateInstallationState>(
            listener: (_, state) async {
              if (state.isSuccess && state.successMsg.isNotNull) {
                await AppDialog.showSuccessDialog(
                  context,
                  title: 'Success',
                  content: state.successMsg.valueOrEmpty,
                  onTapDismiss: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                );

                if (!context.mounted) return;
                context.cubit<CreateInstallationEntryCubit>().errorHandled();

                if (state.form.docStatus == 1) {
                  shouldAskForConfirmation.value = false;
                  final gateEntryFilters =
                      context.read<InstallationFilterCubit>().state;
                  context.cubit<InstallationCubit>().fetchInitial(
                        Pair(
                          StringUtils.docStatusInt(gateEntryFilters.status),
                          gateEntryFilters.query,
                        ),
                      );
                  Navigator.pop(context, true);
                }
              }

              if (state.error.isNotNull) {
                await AppDialog.showErrorDialog(
                  context,
                  title: state.error?.title,
                  content: state.error!.error,
                  onTapDismiss: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                );

                if (!context.mounted) return;
                context.cubit<CreateInstallationEntryCubit>().errorHandled();
              }
            },
            child: InstallationEntryFormWidget(key: ValueKey(status)),
          ),
        );
      },
    );
  }
}