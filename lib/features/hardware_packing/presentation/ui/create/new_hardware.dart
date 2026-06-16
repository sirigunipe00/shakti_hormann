import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/frame_fliter_cubit.dart';
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
    final gateEntryState = context.read<CreateFrameCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New HardWare Packing',
                actionButton:
                    BlocBuilder<CreateFrameCubit, CreateFrameState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == FrameView.create
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
                            context.cubit<CreateFrameCubit>().save();
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
                    actionButton:
                        (status == 1 && !gateEntryState.isModified)
                            ? null
                            : BlocBuilder<CreateFrameCubit,CreateFrameState>(
                              builder: (context, state) {
                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label:
                                      state.newLines.isNotEmpty 
                                          ? 'Update'
                                          : 'Submit',
                                  onPressed: () {
                                    context.cubit<CreateFrameCubit>().save();
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateFrameCubit, CreateFrameState>(
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
              context.cubit<CreateFrameCubit>().errorHandled();
              context.cubit<FrameLinesCubit>().request(docName);
              final gateEntryFilters = context.read<FrameFliterCubit>().state;
              context.cubit<FrameCubit>().fetchInitial(
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
            context.cubit<CreateFrameCubit>().errorHandled();
          }
        },
        child: HardwareFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
