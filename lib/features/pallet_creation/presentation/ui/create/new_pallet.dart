import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/create_pallet_cubit.dart/create_pallet_cubit.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/pallet_filter_cubit.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/ui/create/pallet_form_widget.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewPallet extends StatefulWidget {
  const NewPallet({super.key});

  @override
  State<NewPallet> createState() => _NewPalletState();
}

class _NewPalletState extends State<NewPallet> {
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreatePalletCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New Pallet Creation',
                actionButton: BlocBuilder<CreatePalletCubit, CreatePalletState>(
                  builder: (context, state) {
                    return AppButton(
                      borderColor: Colors.grey,
                      bgColor:
                          state.view == PalletView.create
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
                        context.cubit<CreatePalletCubit>().save();
                      },
                    );
                  },
                ),
              )
              : TitleStatusAppBar(
                    title: '  $name',
                    status: StringUtils.docStatus(status),
                    textColor: AppColors.white,
                    pageMode: PageMode2.palletCreation,
                    onSubmit: () {},
                    onReject: () {},
                    actionButton:
                        (status == 1 && !gateEntryState.isModified)
                            ? null
                            : BlocBuilder<CreatePalletCubit, CreatePalletState>(
                              builder: (context, state) {
                                final currentStatus = state.form.docStatus;

                                if (currentStatus == 1 && !state.isModified) {
                                  return const SizedBox.shrink();
                                }
                                final isReadyToSubmit =
                                    currentStatus == 0 && !state.isModified;

                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label:
                                      isReadyToSubmit
                                          ? 'Submit'
                                          : state.view.toName(),
                                  onPressed: () {
                                    if (isReadyToSubmit) {
                                      context
                                          .cubit<CreatePalletCubit>()
                                          .submit();
                                    } else {
                                      context.cubit<CreatePalletCubit>().save();
                                    }
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
                  body: BlocListener<CreatePalletCubit, CreatePalletState>(
  listener: (_, state) async {
    if (state.isSuccess && state.successMsg.isNotNull) {
      final isSubmitted = state.view == PalletView.completed;

      AppDialog.showSuccessDialog(
        context,
        title: 'Success',
        content: state.successMsg.valueOrEmpty,
        onTapDismiss: context.exit,
      ).then((_) {
        final docName = state.form.name;
        if (!context.mounted) return;

        context.cubit<CreatePalletCubit>().errorHandled();
        context.cubit<PalletItemCubit>().request(docName);

        final gateEntryFilters = context.read<PalletFilterCubit>().state;
        context.cubit<PalletCubit>().fetchInitial(
          Pair(
            StringUtils.docStatusInt(gateEntryFilters.status),
            gateEntryFilters.query,
          ),
        );

        if (isSubmitted) {
          Navigator.pop(context, true);
        } else {
          setState(() {});
        }
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
      context.cubit<CreatePalletCubit>().errorHandled();
    }
  },
  child: BlocProvider(
    create:
        (context) => ShutterBlocProvider.get().getPalletSize()..request(),
    child: PalletFormWidget(key: ValueKey(status)),
  ),
),
      // body: BlocListener<CreatePalletCubit, CreatePalletState>(
      //   listener: (_, state) async {
      //     if (state.isSuccess && state.successMsg.isNotNull) {
      //       AppDialog.showSuccessDialog(
      //         context,
      //         title: 'Success',
      //         content: state.successMsg.valueOrEmpty,
      //         onTapDismiss: context.exit,
      //       ).then((_) {
      //         final docName = state.form.name;
      //         if (!context.mounted) return;
      //         context.cubit<CreatePalletCubit>().errorHandled();
      //         context.cubit<PalletItemCubit>().request(docName);
      //         final gateEntryFilters = context.read<PalletFilterCubit>().state;
      //         context.cubit<PalletCubit>().fetchInitial(
      //           Pair(
      //             StringUtils.docStatusInt(gateEntryFilters.status),
      //             gateEntryFilters.query,
      //           ),
      //         );
      //         Navigator.pop(context, true);
      //         setState(() {});
      //       });
      //     }
      //     if (state.error.isNotNull) {
      //       await AppDialog.showErrorDialog(
      //         context,
      //         title: state.error?.title,
      //         content: state.error!.error,
      //         onTapDismiss: context.exit,
      //       );
      //       if (!context.mounted) return;
      //       context.cubit<CreatePalletCubit>().errorHandled();
      //     }
      //   },
      //   child: BlocProvider(
      //     create:
      //         (context) => ShutterBlocProvider.get().getPalletSize()..request(),
      //     child: PalletFormWidget(key: ValueKey(status)),
      //   ),
      // ),
    );
  }
}
