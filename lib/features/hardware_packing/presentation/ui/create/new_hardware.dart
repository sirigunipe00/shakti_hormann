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
    final gateEntryState = context.read<CreateHardwareCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New HardWare Packing',
                actionButton: BlocBuilder<
                  CreateHardwareCubit,
                  CreateHardwareState
                >(
                  builder: (context, createState) {
                    return BlocBuilder<
                      HardwarePackingItemsCubit,
                      HardwarePackingItemsState
                    >(
                      builder: (context, hardwareState) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              createState.view == HardwareView.create
                                  ? const Color.fromARGB(255, 250, 193, 47)
                                  : AppColors.green,
                          textStyle: const TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),

                          isLoading:
                              createState.isLoading || hardwareState.isLoading,

                          label: createState.view.toName(),

                          onPressed:
                              hardwareState.isLoading
                                  ? null
                                  : () {
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
                    status: StringUtils.docStatus(status),
                    textColor: AppColors.white,
                    pageMode: PageMode2.hardwarePacking,
                    onSubmit: () {},
                    onReject: () {},
                    showRejectButton: false,
                    actionButton:
                        gateEntryState.view == HardwareView.completed
                            ? null
                            : BlocBuilder<
                              CreateHardwareCubit,
                              CreateHardwareState
                            >(
                              builder: (context, createState) {
                                return BlocBuilder<
                                  HardwarePackingItemsCubit,
                                  HardwarePackingItemsState
                                >(
                                  builder: (context, hardwareState) {
                                    return AppButton(
                                      borderColor: Colors.grey,

                                      textStyle: const TextStyle(
                                        color: AppColors.darkBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),

                                      isLoading:
                                          createState.isLoading ||
                                          hardwareState.isLoading,

                                      label: createState.view.toName(),

                                      onPressed:
                                          hardwareState.isLoading
                                              ? null
                                              : () {
                                                context
                                                    .read<CreateHardwareCubit>()
                                                    .save();
                                              },
                                    );
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateHardwareCubit, CreateHardwareState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              final docName = state.form.name;
              if (!context.mounted) return;
              context.cubit<CreateHardwareCubit>().errorHandled();
              context.cubit<HardwareItemsCubit>().request(docName);
              final gateEntryFilters =
                  context.read<HardWareFilterCubit>().state;
              context.cubit<HardwareCubit>().fetchInitial(
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
            context.cubit<CreateHardwareCubit>().errorHandled();
          }
        },
        child: HardwareFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
