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

class _LogisticRequestListState extends State<LogisticRequestList>
    with StatusModeSelectionMixin {
  String? status;
  String? query;
  @override
  void initState() {
    status = 'Draft';
    context.read<LogisticPlanningFilterCubit>().onChangeStatus('Draft');
    context.read<LogisticPlanningFilterCubit>().onSearch(null);
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
          _fetchInital(context);
        }
      },

      scaffoldBg: '',

      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<LogisticPlanningFilterCubit>().state;
          return context.cubit<LogisticPlanningCubit>().fetchInitial(
            Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
          );
        },
        child: BlocListener<LogisticPlanningFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<
            LogisticPlanningCubit,
            LogisticPlanningForm
          >(
            childBuilder:
                (context, entry) => LogisticRequestWidget(
                  logistic: entry,
                  onTap: () async {
                    final refresh = await AppRoute.newLogisticRequest
                        .push<bool?>(context, extra: entry);
                    if (refresh == true) {
                      _fetchInital(context);
                    }
                  },
                ),
            fetchInitial: () => _fetchInital(context),
            fetchMore: () => fetchMore(context),
            emptyListText: 'No Logistic Requests Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<LogisticPlanningFilterCubit>().state;
    context.cubit<LogisticPlanningCubit>().fetchInitial(
      Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<LogisticPlanningFilterCubit>().state;
    context.cubit<LogisticPlanningCubit>().fetchMore(
      Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
    );
  }
}
