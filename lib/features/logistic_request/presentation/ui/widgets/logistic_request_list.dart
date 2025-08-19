import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/logistic_planning_filter_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/widgets/logistic_request_widget.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class LogisticRequestList extends StatefulWidget {
  const LogisticRequestList({super.key});

  @override
  State<LogisticRequestList> createState() => _LogisticRequestListState();
}

class _LogisticRequestListState extends State<LogisticRequestList> with StatusModeSelectionMixin {
  
    String? status;
  String? query;
   @override
  void initState() {
    status = 'Draft';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<LogisticPlanningFilterCubit>(
      mode: PageMode2.logisticRequest,

      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      onNew: () async {
        final refresh = await AppRoute.newLogisticRequest.push<bool?>(context);
        if (refresh == true) {
          _fetchInital(context, query, status!);
        }
      },

      scaffoldBg: '',

      child: RefreshIndicator(
        onRefresh: () => context.cubit<LogisticPlanningCubit>().fetchInitial(
          Pair(StringUtils.docStatuslogistic(status), query),
        ),
        child: BlocListener<LogisticPlanningFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context,state.query, state.status),
          child:
              InfiniteListViewWidget<LogisticPlanningCubit, LogisticPlanningForm>(
                childBuilder:
                    (context, entry) => LogisticRequestWidget(
                      logistic: entry,
                      onTap: () {
                        AppRoute.newLogisticRequest.push<bool?>(
                          context,
                          extra: entry,
                        );
                      },
                    ),
                fetchInitial: () => _fetchInital(context, query, status),
                fetchMore: () => fetchMore(context),
                emptyListText: 'No Logistic Requests Found.',
              ),
        ),
      ),
      onSearch: () async {
        final selected = await showOptions(context, defaultValue: status, pageMode: PageMode2.logisticRequest);
        if (selected == null || !context.mounted) return;

        setState(() {
          status = selected;
          query = null;
          context.cubit<LogisticPlanningFilterCubit>().onChangeStatus(status ?? '');
        });

        _fetchInital(context, query, status!);
      },
    );
  }

  void _fetchInital(BuildContext context,String? query, String? status) {
    context.cubit<LogisticPlanningCubit>().fetchInitial(
      Pair(StringUtils.docStatuslogistic(status), query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<LogisticPlanningFilterCubit>().state;

    context.cubit<LogisticPlanningCubit>().fetchMore(
      Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
    );
  }
}
