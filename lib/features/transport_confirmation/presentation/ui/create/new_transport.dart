import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/transport_filter_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/ui/create/transport_cnfm_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewTransportCnfm extends StatefulWidget {
  const NewTransportCnfm({super.key});

  @override
  State<NewTransportCnfm> createState() => _NewTransportCnfmState();
}

class _NewTransportCnfmState extends State<NewTransportCnfm> {
  SalesOrderForm? orderForm;

  @override
  Widget build(BuildContext context) {
    final transportState = context.read<CreateTransportCubit>().state;

    final isCreating = transportState.view == TransportView.create;

    final newform = transportState.form;
    final status = newform.docstatus;
    final name = newform.name;

    final isNew = transportState.view == TransportView.create;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Logistic Request',
                actionButton: AppButton(
                  label: isCreating ? 'Create' : 'Update',

                  onPressed: context.cubit<CreateTransportCubit>().approve,
                ),
              )
              : TitleStatusAppBar(
                    title: name,
                    status: StringUtils.docStatus(status ?? 0),

                    onSubmit:
                        status == 1
                            ? () {}
                            : () {
                              context.cubit<CreateTransportCubit>().approve();
                            },
                    onReject:
                        status == 1
                            ? () {}
                            : () {
                             
                              context.cubit<CreateTransportCubit>().reject();
                            },
                    textColor: Colors.white,
                    pageMode: PageMode2.transportConfirmation,
                    showRejectButton: true,
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateTransportCubit, CreateTransportState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateTransportCubit>().errorHandled();

              final gateEntryFilters =
                  context.read<TransportFilterCubit>().state;
              context.cubit<TransportCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatuslogistic(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
              Navigator.pop(context);
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
            context.cubit<CreateTransportCubit>().errorHandled();
          }
        },
        child: TransportCnfmFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
