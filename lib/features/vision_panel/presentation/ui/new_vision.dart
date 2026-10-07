import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/vision_panel_filter_cubit.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/ui/vision_panel_form_widget.dart';
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
    return BlocBuilder<CreateVisionPanelCubit, CreateVisionPanelState>(
      builder: (context, visionState) {
        final form = visionState.form;
        final status = form.docStatus;
        final docName = form.name;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar:
              (docName == null || docName.isEmpty)
                  ? SimpleAppBar(
                    title: 'New Accessories Packing',
                    actionButton: BlocBuilder<
                      CreateVisionPanelCubit,
                      CreateVisionPanelState
                    >(
                      builder: (context, state) {
                        final hasSO =
                            (state.form.salesOrderNo?.trim().isNotEmpty ??
                                false);
                        final firstItem = state.items.firstOrNull;
                        final hasValidFirstRow =
                            firstItem != null &&
                            (firstItem.productType?.isNotEmpty ?? false) &&
                            (firstItem.noOfBoxes ?? 0) > 0;

                        final canSave = hasSO && hasValidFirstRow;

                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor: const Color.fromARGB(255, 250, 193, 47),
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          isLoading: state.isLoading,
                          useRootLoadingOverlay: false,
                          label: 'Save',
                          onPressed:
                              canSave
                                  ? () => context
                                      .cubit<CreateVisionPanelCubit>()
                                      .createEntry()
                                  : null,
                        );
                      },
                    ),
                  )
                  : TitleStatusAppBar(
                        title: docName,
                        status: StringUtils.docStatus(status ?? 0),
                        textColor: AppColors.white,
                        pageMode: PageMode2.visionPanel,
                        onSubmit: () {},
                        onReject: () {},
                        actionButton:
                            (form.docStatus == 1)
                                ? null
                                : BlocBuilder<
                                  CreateVisionPanelCubit,
                                  CreateVisionPanelState
                                >(
                                  builder: (context, state) {
                                    final canSubmit =
                                        state.isUpdated && !state.isLoading;

                                    return AppButton(
                                      borderColor: Colors.grey,
                                      bgColor:
                                          canSubmit
                                              ? AppColors.green
                                              : const Color(0xFFCBD5E1),
                                      textStyle:
                                          canSubmit
                                              ? const TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              )
                                              : null,
                                      isLoading:
                                          state.isLoading && state.isUpdated,
                                      useRootLoadingOverlay: false,
                                      label: 'Submit',
                                      onPressed:
                                          canSubmit
                                              ? () => context
                                                  .cubit<CreateVisionPanelCubit>()
                                                  .submit()
                                              : null,
                                    );
                                  },
                                ),
                      )
                      as PreferredSizeWidget,
          body: Stack(
            fit: StackFit.expand,
            children: [
              BlocListener<CreateVisionPanelCubit, CreateVisionPanelState>(
                listener: (_, state) async {
                  if (state.isSuccess && state.successMsg.isNotNull) {
                    if (!context.mounted) return;
                    await AppDialog.showSuccessDialog(
                      context,
                      title: 'Success',
                      content: state.successMsg.valueOrEmpty,
                      onTapDismiss: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    );

                    if (!context.mounted) return;
                    context.cubit<CreateVisionPanelCubit>().errorHandled();

                    if (state.form.docStatus == 1) {
                      shouldAskForConfirmation.value = false;
                      final filters =
                          context.read<VisionPanelFilterCubit>().state;
                      context.cubit<VisionPanelCubit>().fetchInitial(
                        Pair(
                          StringUtils.docStatusInt(filters.status),
                          filters.query,
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  }

                  if (state.error.isNotNull) {
                    if (!context.mounted) return;
                    await AppDialog.showErrorDialog(
                      context,
                      title: state.error?.title,
                      content: state.error!.error,
                      onTapDismiss: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    );

                    if (!context.mounted) return;
                    context.cubit<CreateVisionPanelCubit>().errorHandled();
                  }
                },
                child: const VisionPanelFormWidget(),
              ),
              // Lightweight overlay for image upload + submit (Installation style).
              BlocBuilder<CreateVisionPanelCubit, CreateVisionPanelState>(
                buildWhen: (p, c) =>
                    p.isLoading != c.isLoading ||
                    p.isUpdated != c.isUpdated ||
                    p.isModified != c.isModified,
                builder: (context, state) {
                  if (!state.isLoading) return const SizedBox.shrink();

                  final hasDoc =
                      state.form.name != null && state.form.name!.isNotEmpty;
                  final isImageUploading =
                      hasDoc && state.isModified && !state.isUpdated;
                  final isSubmitting = state.isUpdated;

                  if (!isImageUploading && !isSubmitting) {
                    return const SizedBox.shrink();
                  }

                  final label = isImageUploading
                      ? 'Uploading box images...'
                      : 'Submitting document...';

                  return AbsorbPointer(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.25),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
