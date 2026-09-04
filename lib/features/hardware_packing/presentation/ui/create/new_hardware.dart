import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/create_hardware_cubit/create_hardware_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/create_hardware_cubit/hardware_items_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/hardware_filter_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/create/hardware_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewHardware extends StatefulWidget {
  const NewHardware({super.key});

  @override
  State<NewHardware> createState() => _NewHardwareState();
}

class _NewHardwareState extends State<NewHardware> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateHardwareCubit, CreateHardwareState>(
      builder: (context, hardwareState) {
        final form = hardwareState.form;
        final status = form.docStatus;
        final name = form.name;
        final isDraft =
            name != null && name.isNotEmpty && (status == null || status == 0);

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar:
              (name == null || name.isEmpty)
                  ? SimpleAppBar(
                    title: 'New HardWare Packing',
                    actionButton: BlocBuilder<CreateHardwareCubit,CreateHardwareState>(
                      builder: (context, createState) {
                        return BlocBuilder<HardwarePackingItemsCubit,HardwarePackingItemsState>(
                          builder: (context, packingItemsState) {
                            final canSave =
                                (createState.form.salesOrderNo
                                        ?.trim()
                                        .isNotEmpty ??
                                    false) &&
                                createState.lines.isNotEmpty &&
                                !createState.isLoading &&
                                !packingItemsState.isLoading;

                            return AppButton(
                              borderColor: Colors.grey,
                              bgColor: const Color.fromARGB(255, 250, 193, 47),
                              textStyle: const TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              isLoading:
                                  createState.isLoading ||
                                  packingItemsState.isLoading,
                              label: 'Save',
                              onPressed:
                                  canSave
                                      ? () =>
                                          context
                                              .read<CreateHardwareCubit>()
                                              .save()
                                      : null,
                            );
                          },
                        );
                      },
                    ),
                  )
                  : TitleStatusAppBar(
                        title: '  $name',
                        status: StringUtils.docStatus(status ?? 0),
                        textColor: AppColors.white,
                        pageMode: PageMode2.hardwarePacking,
                        onSubmit: () {},
                        onReject: () {},
                        showRejectButton: false,
                        actionButton:
                            !isDraft
                                ? null
                                : BlocBuilder<CreateHardwareCubit,CreateHardwareState>(
                                  builder: (context, createState) {
                                    return BlocBuilder<HardwarePackingItemsCubit,HardwarePackingItemsState>(
                                      builder: (context, packingItemsState) {
                                        final cubit =
                                            context.read<CreateHardwareCubit>();
                                        final isBusy =
                                            createState.isLoading ||
                                            packingItemsState.isLoading;
                                        final showUpdate =
                                            createState.isModified;

                                        return AppButton(
                                          borderColor: Colors.grey,
                                          bgColor:
                                              showUpdate
                                                  ? const Color.fromARGB(
                                                    255,
                                                    250,
                                                    193,
                                                    47,
                                                  )
                                                  : AppColors.green,
                                          textStyle: const TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                          isLoading: isBusy,
                                          label:
                                              showUpdate ? 'Update' : 'Submit',
                                          onPressed:
                                              isBusy
                                                  ? null
                                                  : () {
                                                    if (showUpdate) {
                                                      cubit.update();
                                                    } else {
                                                      cubit.submit();
                                                    }
                                                  },
                                        );
                                      },
                                    );
                                  },
                                ),
                      )
                      as PreferredSizeWidget,
          body: BlocBuilder<CreateHardwareCubit, CreateHardwareState>(
            builder: (context, createOverlay) {
              return BlocBuilder<HardwarePackingItemsCubit,
                  HardwarePackingItemsState>(
                builder: (context, itemsOverlay) {
                  return FormPageLoadingStack(
                    isLoading:
                        createOverlay.isLoading || itemsOverlay.isLoading,
                    message: 'Please wait...',
                    statusLabel: 'Processing...',
                    child: BlocListener<CreateHardwareCubit, CreateHardwareState>(
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
                final docName = state.form.name;
                context.cubit<CreateHardwareCubit>().errorHandled();
                final filters = context.read<HardWareFilterCubit>().state;
                context.cubit<HardwareCubit>().fetchInitial(
                  Pair(
                    filters.status,
                    filters.query,
                  ),
                );

                if (state.form.docStatus == 1) {
                  shouldAskForConfirmation.value = false;
                  Navigator.pop(context, true);
                } else {
                  if (docName != null && docName.isNotEmpty) {
                    context.read<HardwareItemsCubit>().request(docName);
                  }
                  setState(() {});
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
                context.cubit<CreateHardwareCubit>().errorHandled();
              }
            },
            child: HardwareFormWidget(
              key: ValueKey('${name}_${status}_${hardwareState.view}'),
            ),
          ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
