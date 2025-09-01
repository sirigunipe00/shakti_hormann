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
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class LoadingCnfrmList extends StatefulWidget {
  const LoadingCnfrmList({super.key});

  @override
  State<LoadingCnfrmList> createState() => _LoadingCnfrmListState();
}

class _LoadingCnfrmListState extends State<LoadingCnfrmList>  with StatusModeSelectionMixin{
  String? status;
  String? query;

  @override
 void initState(){
  status = 'Reported';
  context.read<LoadingCnfmFiltersCubit>().onChangeStatus(
    'Reported'
  );
  context.read<LoadingCnfmFiltersCubit>().onSearch(null);
  super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return AppPageView2<LoadingCnfmFiltersCubit>(
      mode: PageMode2.loadingConfirmation,

      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newLoadingConfirmation.push<bool>(context);
        if (refresh == true) {
          _fetchInital(context);
        }
      },

      scaffoldBg: '',

      child: RefreshIndicator(
        onRefresh: (){
          final filters =context.read<LoadingCnfmFiltersCubit>().state;
          return context.cubit<LoadingCnfmCubit>().fetchInitial(
            Pair(StringUtils.docStatusVehicle(filters.status), filters.query)
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
                          .push<bool?>(context, extra: entry);
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
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
    context.cubit<LoadingCnfmCubit>().fetchInitial(
      Pair(StringUtils.docStatusVehicle(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<LoadingCnfmFiltersCubit>().state;
     context.cubit<LoadingCnfmCubit>().fetchMore(
      Pair(StringUtils.docStatusVehicle(filters.status), filters.query),
    );
  }
}
