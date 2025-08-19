import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/widgets/gate_exit_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';

class GateExitListScrn extends StatefulWidget {
  const GateExitListScrn({super.key});

  @override
  State<GateExitListScrn> createState() => _GateExitListScrnState();
}

class _GateExitListScrnState extends State<GateExitListScrn>
    with StatusModeSelectionMixin {
  String? status;
  String? query;

  @override
  void initState() {
    status = 'Draft';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView2<GateExitFilterCubit>(
      mode: PageMode2.gateexit,

      backgroundColor: AppColors.white,
      onNew: () => AppRoute.newGateExit.push(context),

      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh:
            () => context.cubit<GateExitCubit>().fetchInitial(
              Pair(StringUtils.docStatusInt(status), query),
            ),
        child: BlocListener<GateExitFilterCubit, PageViewFilters>(
          listener:
              (_, state) => _fetchInital(context, state.query, state.status),
          child: InfiniteListViewWidget<GateExitCubit, GateExitForm>(
            childBuilder:
                (context, entry) => GateExitWidget(
                  gateExit: entry,
                  onTap: () {
                    AppRoute.newGateExit.push<bool?>(context, extra: entry);
                  },
                ),
            fetchInitial: () => _fetchInital(context, query, status),
            fetchMore: () => fetchMore(context),
            emptyListText: 'No GateExists Found.',
          ),
        ),
      ),
      onSearch: () async {
        final selected = await showOptions(
          context,
          defaultValue: status,
          pageMode: PageMode2.gateexit,
        );
        if (selected == null || !context.mounted) return;

        setState(() {
          status = selected;
          query = null;
          context.cubit<GateExitFilterCubit>().onChangeStatus(status ?? '');
        });
        _fetchInital(context, query, status!);
      },
    );
  }

  void _fetchInital(BuildContext context, String? query, String? status) {
    context.cubit<GateExitCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(status), query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<GateExitFilterCubit>().state;

    context.cubit<GateExitCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
