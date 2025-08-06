import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view3.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view4.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate%20_exit_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/widgets/loading_cnfm_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class LoadingCnfrmList extends StatelessWidget {
  const LoadingCnfrmList({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageView4<GateExitFilterCubit>(
      mode: PageMode4.loadingConfirmation,

      backgroundColor: AppColors.white,
      onNew: () => AppRoute.newGateExit.push(context),

      scaffoldBg: '',
      child: BlocListener<GateExitFilterCubit, PageViewFilters>(
        listener: (_, state) => _fetchInital(context),
        child: InfiniteListViewWidget<GateExitCubit, GateExitForm>(
          childBuilder:
              (context, entry) => LoadingCnfmWidget(
                gateExit: entry,
                onTap: () {
                  log('entry----:$entry');
                  AppRoute.newGateExit.push<bool?>(context, extra: entry);
                },
              ),
          fetchInitial: () => _fetchInital(context),
          fetchMore: () => fetchMore(context),
          emptyListText: 'No LoadingConfirmation Found.',
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<GateExitFilterCubit>().state;
    context.cubit<GateEntriesCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<GateExitFilterCubit>().state;

    context.cubit<GateEntriesCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
