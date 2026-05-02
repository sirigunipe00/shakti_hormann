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
  String? status;
  String? query;

  @override
  void initState() {
    status = 'Reported';
    context.read<LoadingCnfmFiltersCubit>().onChangeStatus('Reported');
    context.read<LoadingCnfmFiltersCubit>().onSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCnfmFiltersCubit, PageViewFilters>(
      builder: (context, filters) {
        return AppPageView2<LoadingCnfmFiltersCubit>(
          mode: PageMode2.loadingConfirmation,
          backgroundColor: AppColors.white,
          scaffoldBg: '',
          onNew: () async {
            final refresh = await AppRoute.newLoadingConfirmation.push<bool>(
              context,
            );
            if (!context.mounted) return;
            if (refresh == true) {
              _fetchInital(context);
            }
          },
          trailingAction: BlocBuilder<LoadingCnfmFiltersCubit, PageViewFilters>(
            builder:
                (context, filters) => BlocProvider(
                  create: (context) => LogisticPlanningBlocProvider.get().salesOrderList()..request(),
                  child: SalesOrderFilterButton(
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
                ),
          ),

          child: RefreshIndicator(
            onRefresh: () {
              final filters = context.read<LoadingCnfmFiltersCubit>().state;
              return context.cubit<LoadingCnfmCubit>().fetchInitial(
                Triple(
                  StringUtils.docStatusVehicle(filters.status),
                  filters.query,
                  filters.salesOrder
                ),
              );
            },
            child: BlocListener<LoadingCnfmFiltersCubit, PageViewFilters>(
              listener: (_, state) => _fetchInital(context),
              child: InfiniteListViewWidget<LoadingCnfmCubit, LoadingCnfmForm>(
                childBuilder:
                    (context, entry) => LoadingCnfmWidget(
                      loadingCnfmForm: entry,
                      onTap: () async {
                        final refresh = await AppRoute.newLoadingConfirmation
                            .push<bool>(context, extra: entry);
                        if (!context.mounted) return;
                        if (refresh == true) {
                          _fetchInital(context);
                        }
                      },
                    ),
                fetchInitial: () => _fetchInital(context),
                fetchMore: () => fetchMore(context),
                emptyListText: 'No LoadingConfirmation Found.',
              ),
            ),
          ),
        );
      },
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
    context.cubit<LoadingCnfmCubit>().fetchInitial(
      Triple(StringUtils.docStatusVehicle(filters.status), filters.query,filters.salesOrder),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
    context.cubit<LoadingCnfmCubit>().fetchMore(
      Triple(StringUtils.docStatusVehicle(filters.status), filters.query,filters.salesOrder),
    );
  }

  List<String> _availableSalesOrders() {
    return [];
    // Return from your cubit state or a separate loaded list
    // e.g. context.read<LoadingCnfmCubit>().state.salesOrders ?? []
    // return context.read<LoadingCnfmCubit>().state.availableSalesOrders ?? [];
  }
}
