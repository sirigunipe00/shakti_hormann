import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/loading_cnfm_filters_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/widgets/loading_cnfm_widget.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/widgets/sales_filter.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class LoadingCnfrmList extends StatefulWidget {
  const LoadingCnfrmList({super.key});

  @override
  State<LoadingCnfrmList> createState() => _LoadingCnfrmListState();
}

class _LoadingCnfrmListState extends State<LoadingCnfrmList>
    with StatusModeSelectionMixin {
  late final SalesOrderList _salesOrderList;

  @override
  void initState() {
    super.initState();
    _salesOrderList = LogisticPlanningBlocProvider.get().salesOrderList();
    // Defer filter + first fetch until after the first frame so we never
    // look up ancestors on a widget that is still mounting / rebuilding.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final filters = context.read<LoadingCnfmFiltersCubit>();
      filters.onChangeStatus('Reported');
      filters.onSearch(null);
      _fetchInital();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _salesOrderList,
      child: BlocListener<LoadingCnfmFiltersCubit, PageViewFilters>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (!mounted) return;
          _fetchInital();
        },
        child: BlocBuilder<LoadingCnfmFiltersCubit, PageViewFilters>(
          builder: (context, filters) {
            return AppPageView2<LoadingCnfmFiltersCubit>(
              mode: PageMode2.loadingConfirmation,
              backgroundColor: AppColors.white,
              scaffoldBg: '',
              onNew: () async {
                final refresh =
                    await AppRoute.newLoadingConfirmation.push<bool>(context);
                if (!mounted) return;
                if (refresh == true) {
                  _fetchInital();
                }
              },
              trailingAction: SalesOrderFilterButton(
                selectedSalesOrder: filters.salesOrder,
                onSelect:
                    (so) => context
                        .read<LoadingCnfmFiltersCubit>()
                        .onChangeSalesOrder(so),
                onClear:
                    () => context
                        .read<LoadingCnfmFiltersCubit>()
                        .onChangeSalesOrder(null),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  if (!mounted) return;
                  await _fetchInitalAsync();
                },
                child: InfiniteListViewWidget<
                  LoadingCnfmCubit,
                  LoadingCnfmForm
                >(
                  childBuilder:
                      (itemContext, entry) => LoadingCnfmWidget(
                        loadingCnfmForm: entry,
                        onTap: () => _openEntry(itemContext, entry),
                      ),
                  fetchInitial: _fetchInital,
                  fetchMore: _fetchMore,
                  emptyListText: 'No Dispatch Loading records found.',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEntry(
    BuildContext itemContext,
    LoadingCnfmForm entry,
  ) async {
    final refresh = await AppRoute.newLoadingConfirmation.push<bool>(
      itemContext,
      extra: entry,
    );
    if (!mounted) return;
    if (refresh == true) {
      _fetchInital();
    }
  }

  void _fetchInital() {
    if (!mounted) return;
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
    context.cubit<LoadingCnfmCubit>().fetchInitial(
      Triple(
        StringUtils.docStatusVehicle(filters.status),
        filters.query,
        filters.salesOrder,
      ),
    );
  }

  Future<void> _fetchInitalAsync() async {
    if (!mounted) return;
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
    await context.cubit<LoadingCnfmCubit>().fetchInitial(
      Triple(
        StringUtils.docStatusVehicle(filters.status),
        filters.query,
        filters.salesOrder,
      ),
    );
  }

  void _fetchMore() {
    if (!mounted) return;
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
    context.cubit<LoadingCnfmCubit>().fetchMore(
      Triple(
        StringUtils.docStatusVehicle(filters.status),
        filters.query,
        filters.salesOrder,
      ),
    );
  }
}
