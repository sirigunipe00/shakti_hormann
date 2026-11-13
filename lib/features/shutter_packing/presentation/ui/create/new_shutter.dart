import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/create_shutter_cubit.dart/create_shutter_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/shutter_filter_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/create/shutter_packing_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
import 'package:shakti_hormann/widgets/packing_scan_processing_overlay.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewShutter extends StatefulWidget {
  const NewShutter({super.key});

  @override
  State<NewShutter> createState() => _NewShutterState();
}

class _NewShutterState extends State<NewShutter> {
  int _formRefreshToken = 0;
  bool _needsListRefresh = false;
  final ValueNotifier<bool> _isDecodingUploadSticker = ValueNotifier(false);

  @override
  void dispose() {
    _isDecodingUploadSticker.dispose();
    super.dispose();
  }

  void _refreshListCubit() {
    if (!mounted) return;
    final filters = context.read<ShutterFilterCubit>().state;
    context.cubit<ShutterCubit>().fetchInitial(
      Pair(filters.status, filters.query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShutterCubit, CreateShutterState>(
      builder: (context, gateEntryState) {
        final newform = gateEntryState.form;
        final status = newform.docStatus;
        final name = newform.name;
        final isCompletedView = gateEntryState.view == ShutterView.completed;
        final isSubmitted = status == 1;

        return ValueListenableBuilder<bool>(
          valueListenable: _isDecodingUploadSticker,
          builder: (context, isDecodingUploadSticker, _) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) return;
                if (isDecodingUploadSticker) return;
                Navigator.of(context).pop(_needsListRefresh);
              },
              child: Scaffold(
          backgroundColor: AppColors.white,
          appBar:
              status == null
                  ? SimpleAppBar(
                    title: 'New Shutter Packing',
                    actionButton: BlocBuilder<
                      CreateShutterCubit,
                      CreateShutterState
                    >(
                      builder: (context, state) {
                        final isDocCreated =
                            state.form.name != null &&
                            state.form.name!.isNotEmpty;
                        if (!isDocCreated) {
                          final canCreate =
                              (state.form.salesOrder?.isNotEmpty ?? false) &&
                              (state.form.palletCode?.isNotEmpty ?? false) &&
                              !state.isCreatingDoc;

                          return AppButton(
                            borderColor: Colors.grey,
                            bgColor:
                                canCreate
                                    ? const Color.fromARGB(255, 250, 193, 47)
                                    : const Color(0xFFCBD5E1),
                            textStyle: const TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            isLoading: state.isCreatingDoc,
                            label: 'Save',
                            onPressed: () {
                              if (!canCreate) {
                                final needsSo =
                                    state.form.salesOrder?.isEmpty ?? true;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      needsSo
                                          ? 'Select a Sales Order first'
                                          : 'Select a Pallet Code first',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              context
                                  .cubit<CreateShutterCubit>()
                                  .createDocument();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  )
                  : TitleStatusAppBar(
                        title: '  $name',
                        status: StringUtils.docStatus(status),
                        textColor: AppColors.white,
                        pageMode: PageMode2.shutterPacking,
                        showRejectButton: false,
                        onSubmit: () {},
                        onReject: () {},
                        actionButton:
                            (isSubmitted || isCompletedView)
                                ? null
                                : BlocBuilder<
                                  CreateShutterCubit,
                                  CreateShutterState
                                >(
                                  builder: (context, state) {
                                    final isPrinted =
                                        state.form.palletQrPrinted == 1;

                                    return AppButton(
                                      borderColor: Colors.grey,
                                      bgColor:
                                          !isPrinted
                                              ? const Color(0xFFCBD5E1)
                                              : AppColors.green,
                                      isLoading: state.isSubmitting,
                                      label:
                                          state.newLines.isNotEmpty
                                              ? 'Update'
                                              : 'Submit',
                                      onPressed:
                                          isPrinted && !state.isSubmitting
                                              ? () => _onSubmitWithConfirmation(context)
                                              : null,
                                    );
                                  },
                                ),
                      )
                      as PreferredSizeWidget,
          body: Stack(
            fit: StackFit.expand,
            children: [
              BlocBuilder<CreateShutterCubit, CreateShutterState>(
                buildWhen:
                    (previous, current) =>
                        previous.isCreatingDoc != current.isCreatingDoc ||
                        previous.isProcessingScan != current.isProcessingScan,
                builder: (context, overlayState) {
                  return FormPageLoadingStack(
                    isLoading:
                        overlayState.isCreatingDoc,
                    message: 'Please wait...',
                    statusLabel: 'Processing...',
                    child: MultiBlocListener(
            listeners: [
              BlocListener<CreateShutterCubit, CreateShutterState>(
                listenWhen:
                    (previous, current) =>
                        previous.createSuccessMsg != current.createSuccessMsg &&
                        current.createSuccessMsg != null,
                listener: (context, state) async {
                  await AppDialog.showSuccessDialog(
                    context,
                    title: 'Success',
                    content: state.createSuccessMsg!,
                    onTapDismiss: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  );
                  if (!context.mounted) return;
                  _needsListRefresh = true;
                  _refreshListCubit();
                  context.cubit<CreateShutterCubit>().createDocHandled();
                  setState(() => _formRefreshToken++);
                },
              ),
              BlocListener<CreateShutterCubit, CreateShutterState>(
                listenWhen:
                    (previous, current) =>
                        previous.isSuccess != current.isSuccess &&
                        current.isSuccess &&
                        current.successMsg != null,
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

                    final isSubmitted = state.form.docStatus == 1;
                    _needsListRefresh = true;
                    context.cubit<CreateShutterCubit>().errorHandled();
                    _refreshListCubit();

                    if (isSubmitted) {
                      shouldAskForConfirmation.value = false;
                      Navigator.pop(context, true);
                    } else {
                      setState(() => _formRefreshToken++);
                    }
                  }
                },
              ),
              BlocListener<CreateShutterCubit, CreateShutterState>(
                listenWhen:
                    (previous, current) =>
                        previous.error != current.error &&
                        current.error.isNotNull,
                listener: (_, state) async {
                  if (state.error.isNotNull) {
                    await AppDialog.showErrorDialog(
                      context,
                      title: state.error?.title,
                      content: state.error!.error,
                      onTapDismiss: context.exit,
                    );
                    if (!context.mounted) return;
                    context.cubit<CreateShutterCubit>().errorHandled();
                  }
                },
              ),
            ],
            child: BlocProvider(
              create: (context) => ShutterBlocProvider.get().getItemsLines(),
              child: ShutterPackingFormWidget(
                isDecodingUploadSticker: _isDecodingUploadSticker,
                key: ValueKey(
                  '${name}_${status}_${gateEntryState.view}_$_formRefreshToken',
                ),
              ),
            ),
          ),
                  );
                },
              ),
              BlocBuilder<CreateShutterCubit, CreateShutterState>(
                buildWhen:
                    (previous, current) =>
                        previous.isProcessingScan != current.isProcessingScan,
                builder: (context, state) {
                  if (!state.isProcessingScan && !isDecodingUploadSticker) {
                    return const SizedBox.shrink();
                  }
                  return const PackingScanProcessingOverlay();
                },
              ),
              BlocBuilder<CreateShutterCubit, CreateShutterState>(
                buildWhen: (p, c) =>
                    p.isSubmitting != c.isSubmitting ||
                    p.newLines.length != c.newLines.length,
                builder: (context, state) {
                  if (!state.isSubmitting) return const SizedBox.shrink();
                  final label = state.newLines.isNotEmpty
                      ? 'Updating document...'
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
        ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSubmitWithConfirmation(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Submit Document?',
      content:
          'Are you sure you want to submit this document? This action cannot be undone.',
      confirmText: 'Submit',
      icon: Icons.check_circle_outline_rounded,
      iconBackground: const Color(0xFFECFDF5),
      iconColor: const Color(0xFF16A34A),
      confirmIcon: Icons.check_rounded,
      confirmColor: const Color(0xFF16A34A),
    );

    if (confirmed != true || !context.mounted) return;
    context.cubit<CreateShutterCubit>().save();
  }
}
