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
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewShutter extends StatefulWidget {
  const NewShutter({super.key});

  @override
  State<NewShutter> createState() => _NewShutterState();
}

class _NewShutterState extends State<NewShutter> {
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateShutterCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;


    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New Shutter Packing',
                actionButton:
                    BlocBuilder<CreateShutterCubit, CreateShutterState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == ShutterView.create
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
                            context.cubit<CreateShutterCubit>().save();
                          },
                        );
                      },
                    ),
              )
              : TitleStatusAppBar(
                    title: '  $name',
                    status: StringUtils.docStatus(status),
                    textColor: AppColors.white,
                    pageMode: PageMode2.shutterPacking,
                    onSubmit: () {},
                    onReject: () {},
                    actionButton:
                        (status == 1 && !gateEntryState.isModified)
                            ? null
                            : BlocBuilder<CreateShutterCubit,CreateShutterState>(
                              builder: (context, state) {
                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label:
                                      state.newLines.isNotEmpty 
                                          ? 'Update'
                                          : 'Submit',
                                  onPressed: () {
                                    context.cubit<CreateShutterCubit>().save();
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateShutterCubit, CreateShutterState>(
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
              context.cubit<CreateShutterCubit>().errorHandled();
              context.cubit<ShutterLinesCubit>().request(docName);
              final gateEntryFilters = context.read<ShutterFilterCubit>().state;
              context.cubit<ShutterCubit>().fetchInitial(
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
            context.cubit<CreateShutterCubit>().errorHandled();
          }
        },
        child: BlocProvider(
          create: (context) => ShutterBlocProvider.get().getItemsLines(),
          child: ShutterPackingFormWidget(key: ValueKey(status)),
        ),
      ),
    );
  }
}
