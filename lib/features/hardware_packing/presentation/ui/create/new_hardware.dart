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
  bool _needsListRefresh = false;

  void _refreshListCubit() {
    if (!mounted) return;
    final filters = context.read<HardWareFilterCubit>().state;
    context.cubit<HardwareCubit>().fetchInitial(
      Pair(filters.status, filters.query),
    );
  }

  void _showSaveHint(CreateHardwareState state) {
    final needsSo = state.form.salesOrderNo?.trim().isEmpty ?? true;
    final needsItems = state.lines.isEmpty;
    final message = needsSo
        ? 'Capture an MES sticker first to fill Sales Order'
        : needsItems
            ? 'Capture at least one MES sticker with items before saving'
            : 'Please wait for processing to finish';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateHardwareCubit, CreateHardwareState>(
      builder: (context, hardwareState) {
        final form = hardwareState.form;
        final status = form.docStatus;
        final name = form.name;
        final isDraft =
            name != null && name.isNotEmpty && (status == null || status == 0);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            Navigator.of(context).pop(_needsListRefresh);
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: (name == null || name.isEmpty)
                ? SimpleAppBar(
                    title: 'New Hardware Packing',
                    actionButton: BlocBuilder<CreateHardwareCubit,
                        CreateHardwareState>(
                      builder: (context, createState) {
                        return BlocBuilder<HardwarePackingItemsCubit,
                            HardwarePackingItemsState>(
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
                              bgColor: canSave
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : const Color(0xFFCBD5E1),
                              textStyle: TextStyle(
                                color: canSave
                                    ? AppColors.darkBlue
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              isLoading: createState.isLoading ||
                                  packingItemsState.isLoading,
                              label: 'Save',
                              onPressed: () {
                                if (!canSave) {
                                  _showSaveHint(createState);
                                  return;
                                }
                                context.read<CreateHardwareCubit>().save();
                              },
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
                    actionButton: !isDraft
                        ? null
                        : BlocBuilder<CreateHardwareCubit, CreateHardwareState>(
                            builder: (context, createState) {
                              return BlocBuilder<HardwarePackingItemsCubit,
                                  HardwarePackingItemsState>(
                                builder: (context, packingItemsState) {
                                  final cubit =
                                      context.read<CreateHardwareCubit>();
                                  final isBusy = createState.isLoading ||
                                      packingItemsState.isLoading;
                                  final showUpdate = createState.isModified;

                                  return AppButton(
                                    borderColor: Colors.grey,
                                    bgColor: showUpdate
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
                                    label: showUpdate ? 'Update' : 'Submit',
                                    onPressed: isBusy
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
                  ) as PreferredSizeWidget,
            body: BlocBuilder<CreateHardwareCubit, CreateHardwareState>(
              builder: (context, createOverlay) {
                return BlocBuilder<HardwarePackingItemsCubit,
                    HardwarePackingItemsState>(
                  builder: (context, itemsOverlay) {
                    return FormPageLoadingStack(
                      isLoading: createOverlay.isLoading ||
                          itemsOverlay.isLoading,
                      message: 'Please wait...',
                      statusLabel: 'Processing...',
                      child: BlocListener<CreateHardwareCubit,
                          CreateHardwareState>(
                        listener: (_, state) async {
                          if (state.isSuccess && state.successMsg.isNotNull) {
                            await AppDialog.showSuccessDialog(
                              context,
                              title: 'Success',
                              content: state.successMsg.valueOrEmpty,
                              onTapDismiss: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            );

                            if (!context.mounted) return;
                            final docName = state.form.name;
                            _needsListRefresh = true;
                            context
                                .cubit<CreateHardwareCubit>()
                                .errorHandled();
                            _refreshListCubit();

                            if (state.form.docStatus == 1) {
                              shouldAskForConfirmation.value = false;
                              Navigator.pop(context, true);
                            } else {
                              if (docName != null && docName.isNotEmpty) {
                                context
                                    .read<HardwareItemsCubit>()
                                    .request(docName);
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            );
                            if (!context.mounted) return;
                            context
                                .cubit<CreateHardwareCubit>()
                                .errorHandled();
                          }
                        },
                        child: HardwareFormWidget(
                          key: ValueKey(
                            '${name}_${status}_${hardwareState.view}',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
