import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/reject_scrn.dart';
import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/gate_entry_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/create/gate_entry_form_widget.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';

import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewGateEntry extends StatefulWidget {
  const NewGateEntry({super.key});

  @override
  State<NewGateEntry> createState() => _NewGateEntryState();
}

class _NewGateEntryState extends State<NewGateEntry> {
  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateGateEntryCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    final isNew = gateEntryState.view == GateEntryView.create;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(title: 'New Gate Exit',
              status:  StringUtils.docStatus(status ?? 0),
              onSubmit: status ==1 ? (){}
              :(){
                context.cubit<CreateGateExitCubit>().save();
              }, 
              )
              : TitleStatusAppBar(
                    title: '$name',
                    status: StringUtils.docStatus(status ?? 0),
                    onSubmit:
                        status == 1
                            ? () {}
                            : () {
                              context.cubit<CreateGateEntryCubit>().save();
                            },
                    onReject: () {
                      {
                        showRejectBottomSheet(
                          context: context,
                          onSubmit: (reason) {
                            // handle rejection reason
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Rejected with reason: $reason'),
                              ),
                            );
                          },
                        );
                      }
                    },

                    textColor: Colors.white,
                  )
                  as PreferredSizeWidget,
      body: BlocListener<CreateGateEntryCubit, CreateGateEntryState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              final docName = state.form.name;
              if (!context.mounted) return;
              context.cubit<CreateGateEntryCubit>().errorHandled();

              final gateEntryFilters =
                  context.read<GateEntryFilterCubit>().state;
              context.cubit<GateEntriesCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
              setState(() {});
            });
          }
          if (state.error.isNotNull) {
            await AppDialog.showErrorDialog(
              context,
              title: state.error!.title,
              content: state.error!.error,
              onTapDismiss: context.exit,
            );
            if (!context.mounted) return;
            context.cubit<CreateGateEntryCubit>().errorHandled();
          }
        },
        child: GateEntryFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
