import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/create_zone_cubit/create_zone_cubit.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/zone_filter_cubit.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/ui/create/zone_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewZone extends StatefulWidget {
  const NewZone({super.key});

  @override
  State<NewZone> createState() => _NewZoneState();
}

class _NewZoneState extends State<NewZone> {
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateZoneCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          status == null
              ? SimpleAppBar(
                title: 'New Zone Transfer',
                actionButton:
                    BlocBuilder<CreateZoneCubit, CreateZoneState>(
                      builder: (context, state) {
                        return AppButton(
                          borderColor: Colors.grey,
                          bgColor:
                              state.view == ZoneView.create
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
                            context.cubit<CreateZoneCubit>().save();
                          },
                        );
                      },
                    ),
              )
              : TitleStatusAppBar(
                    title: '  $name',
                    status: StringUtils.docStatus(status),
                    textColor: AppColors.white,
                    pageMode: PageMode2.zoneTransfer,
                    onSubmit: () {},
                    onReject: () {},
                    showRejectButton: false,
                    actionButton:
                        gateEntryState.view == ZoneView.completed
                            ? null
                            : BlocBuilder<
                              CreateZoneCubit,
                              CreateZoneState
                            >(
                              builder: (context, state) {
                                return AppButton(
                                  borderColor: Colors.grey,
                                  isLoading: state.isLoading,
                                  label: 'Save',
                                  onPressed: () {
                                    context.cubit<CreateZoneCubit>().save();
                                  },
                                );
                              },
                            ),
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateZoneCubit, CreateZoneState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              // final docName = state.form.name;
              if (!context.mounted) return;
              context.cubit<CreateZoneCubit>().errorHandled();
              // context.cubit<FrameLinesCubit>().request(docName);
              final gateEntryFilters = context.read<ZoneFilterCubit>().state;
              context.cubit<ZoneCubit>().fetchInitial(
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
            context.cubit<CreateZoneCubit>().errorHandled();
          }
        },
        child: ZoneFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
