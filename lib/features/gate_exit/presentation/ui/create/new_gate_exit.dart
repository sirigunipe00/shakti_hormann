import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/reject_scrn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/create/gate_exit_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewGateExit extends StatefulWidget {
  const NewGateExit({super.key});

  @override
  State<NewGateExit> createState() => _NewGateExitState();
}

class _NewGateExitState extends State<NewGateExit> {
  SalesInvoiceForm? invoiceform;

  @override
  Widget build(BuildContext context) {
    final gateEntryState = context.read<CreateGateExitCubit>().state;
    final newform = gateEntryState.form;
    final status = newform.docStatus;
    final name = newform.name;

    final isNew = gateEntryState.view == GateExitView.create;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Gate Exit',
                status: StringUtils.docStatus(status ?? 0),
                onSubmit:
                    status == 1
                        ? () {}
                        : () {
                          context.cubit<CreateGateExitCubit>().save();
                        },
                dropdown: BlocBuilder<SalesInvoiceList, SalesInvoiceState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <SalesInvoiceForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<SalesInvoiceForm>(
                      title: "Invoice No",
                      hint: "Search Invoice No",
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      futureRequest: (query) async {
                        return names.toList();
                      },
                      headerBuilder: (_, item, __) => Text(item.name),
                      listItemBuilder:
                          (_, item, __, ___) =>
                              CompactListTile(title: item.name),
                      onSelected: (selected) {
                        setState(() {
                          invoiceform = selected;
                        });
                        context.cubit<CreateGateExitCubit>().onValueChanged(
                          salesInvoiceNo: selected.name,
                        );
                      },
                      focusNode: FocusNode(),
                    );
                  },
                ),
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
                      showRejectBottomSheet(
                        context: context,
                        onSubmit: (reason) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Rejected with reason: $reason'),
                            ),
                          );
                        },
                      );
                    },
                    textColor: Colors.white,
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateGateExitCubit, CreateGateExitState>(
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
              context.cubit<CreateGateExitCubit>().errorHandled();

              final gateEntryFilters =
                  context.read<GateExitFilterCubit>().state;
              context.cubit<GateExitCubit>().fetchInitial(
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
            context.cubit<CreateGateExitCubit>().errorHandled();
          }
        },
        child: GateExitFormWidget(key: ValueKey(status), form: invoiceform),
      ),
    );
  }
}
