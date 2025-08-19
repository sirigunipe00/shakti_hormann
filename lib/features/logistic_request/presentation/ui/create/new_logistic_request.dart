import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/logistic_planning_filter_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/create/logistic_request_form_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/buttons/app_btn.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/compact_listtile.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/simple_app_bar.dart';
import 'package:shakti_hormann/widgets/title_status_app_bar.dart';

class NewLogisticRequest extends StatefulWidget {
  const NewLogisticRequest({super.key});

  @override
  State<NewLogisticRequest> createState() => _NewLogisticRequestState();
}

class _NewLogisticRequestState extends State<NewLogisticRequest> {
  SalesOrderForm? orderForm;

  @override
  Widget build(BuildContext context) {
    final logisticState = context.read<CreateLogisticCubit>().state;

    final isCreating = logisticState.view == LogisticPlanningView.create;
    final newform = logisticState.form;
    final status = newform.docstatus;
    final name = newform.name;
       


    final isNew = logisticState.view == LogisticPlanningView.create;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:
          isNew
              ? SimpleAppBar(
                title: 'New Logistic Request',
                actionButton: AppButton(
                  label: isCreating ? 'Create' : 'Update',

                  onPressed: context.cubit<CreateLogisticCubit>().save,
                ),

                dropdown: BlocBuilder<SalesOrderList, SalesOrderState>(
                  builder: (_, state) {
                    final allData = state.maybeWhen(
                      orElse: () => <SalesOrderForm>[],
                      success: (data) => data,
                    );

                    final names = allData.toList();

                    return SearchDropDownList<SalesOrderForm>(
                      title: 'Sales No',

                      hint: 'Search Order No',
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
                          orderForm = selected;
                        });
                        String cleanAddress(String? htmlAddress) {
                          if (htmlAddress == null) return '';
                          return htmlAddress
                              .replaceAll('<br>', '\n')
                              .replaceAll('<br/>', '\n')
                              .replaceAll(RegExp(r'\\n'), '\n')
                              .trim();
                        }

                        context.cubit<CreateLogisticCubit>().onValueChanged(
                          salesOrder: selected.name,
                          plantName: selected.plantName,
                          deliveryAddress: cleanAddress(
                            selected.addressDisplay,
                          ),
                        );
                      },
                      focusNode: FocusNode(),
                    );
                  },
                ),
              )
              : TitleStatusAppBar(
                    title: name,
                    status: newform.docstatus.toString(),

                    onSubmit:
                        status == 1
                            ? () {}
                            : () {
                              context.cubit<CreateLogisticCubit>().save();
                            },

                    textColor: Colors.white,
                    pageMode: PageMode2.logisticRequest,
                    onReject: () {
                      
                    },
                  )
                  as PreferredSizeWidget,

      body: BlocListener<CreateLogisticCubit, CreateLogisticState>(
        listener: (_, state) async {
          if (state.isSuccess && state.successMsg!.isNotNull) {
            AppDialog.showSuccessDialog(
              context,
              title: 'Success',
              content: state.successMsg.valueOrEmpty,
              onTapDismiss: context.exit,
            ).then((_) {
              if (!context.mounted) return;
              context.cubit<CreateLogisticCubit>().errorHandled();

              final gateEntryFilters =
                  context.read<LogisticPlanningFilterCubit>().state;
              context.cubit<LogisticPlanningCubit>().fetchInitial(
                Pair(
                  StringUtils.docStatuslogistic(gateEntryFilters.status),
                  gateEntryFilters.query,
                ),
              );
               Navigator.pop(context,true);
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
            context.cubit<CreateLogisticCubit>().errorHandled();
          }
        },
        child: LogisticPlanningFormWidget(key: ValueKey(status)),
      ),
    );
  }
}
