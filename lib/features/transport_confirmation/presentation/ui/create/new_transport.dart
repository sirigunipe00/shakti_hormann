import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/ui/create/transport_cnfm_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/rejectreasondailog.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Transporter Confirmation',
                actionButton: AppButton(
                  label: isCreating ? 'Create' : 'Update',
                  onPressed: context.cubit<CreateTransportCubit>().approve,
                ),
                dropdown: const SizedBox(),
              )
              : TitleStatusAppBar(
                    title: name ?? '',
                    status: StringUtils.docStatus(status ?? 0),
                    onSubmit: () {
                      context.cubit<CreateTransportCubit>().approve();
                    },
                    onReject: () {
                      showRejectDialog(context);
                    },
                    textColor: Colors.white,
                    pageMode: PageMode2.transportConfirmation,
                    showRejectButton: true,
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateTransportCubit, CreateTransportState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            final isReject = state.successMsg!.toLowerCase().contains('reject');

            if (isReject) {
              AppDialog.showErrorDialog(
                context,
                title: 'Transporter Rejected',
                content: state.successMsg.valueOrEmpty,
                onTapDismiss: context.exit,
              ).then((_) {
                if (!context.mounted) return;
                context.cubit<CreateTransportCubit>().errorHandled();
                Navigator.pop(context, true);
              });
            } else {
              AppDialog.showSuccessDialog(
                context,
                title: 'Success',
                content: state.successMsg.valueOrEmpty,
                onTapDismiss: context.exit,
              ).then((_) {
                if (!context.mounted) return;
                context.cubit<CreateTransportCubit>().errorHandled();
                Navigator.pop(context, true);
              });
            }
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
