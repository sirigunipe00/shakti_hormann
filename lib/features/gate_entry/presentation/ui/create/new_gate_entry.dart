import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/reject_scrn.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/gate_entry_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/create/gate_entry_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewGateEntry extends StatefulWidget {
  const NewGateEntry({super.key});

  @override
  State<NewGateEntry> createState() => _NewGateEntryState();
}

class _NewGateEntryState extends State<NewGateEntry> {
  PurchaseOrderForm? purchaseOrder;
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
              ? SimpleAppBar(
                title: 'New Gate Entry',
                actionButton:
                    BlocBuilder<CreateGateEntryCubit, CreateGateEntryState>(
                      builder: (context, state) {
                        return AppButton(
                          isLoading: state.isLoading,
                          label: state.view.toName(),
                          onPressed: () {
                            context.cubit<CreateGateEntryCubit>().save();
                          },
                        );
                      },
                    ),

                dropdown: BlocBuilder<PurchaseOrderList, PurchaseOrderState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <PurchaseOrderForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<PurchaseOrderForm>(
                      title: 'Purchase Order No',
                      hint: 'Search Purchase Order',
                      color: AppColors.white,
                      items: names,
                      readOnly: status == 1,
                      isloading: state.isLoading,
                      futureRequest: (query) async {
                        return names.toList();
                      },
                      headerBuilder: (_, item, __) => Text(item.name ?? ''),
                      listItemBuilder:
                          (_, item, __, ___) =>
                              CompactListTile(title: item.name ?? ''),
                      onSelected: (selected) {
                        setState(() {
                          purchaseOrder = selected;
                        });
                        context.cubit<CreateGateEntryCubit>().onValueChanged(
                          purchaseOrder: selected.name,
                          plantName: selected.plantName,
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
                      {
                        showRejectBottomSheet(
                          context: context,
                          onSubmit: (reason) {},
                        );
                      }
                    },

                    textColor: Colors.white,
                    pageMode: PageMode2.gateentry,
                    showRejectButton: false,
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
              if (!context.mounted) return;
              context.cubit<CreateGateEntryCubit>().errorHandled();
              Navigator.pop(context, true);
              if (!context.mounted) return;

              final gateEntryFilters =
                  context.read<GateEntryFilterCubit>().state;
              context.cubit<GateEntriesCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatusInt(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
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
