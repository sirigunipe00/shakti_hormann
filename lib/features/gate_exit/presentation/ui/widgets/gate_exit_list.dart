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
    context.read<GateExitFilterCubit>().onChangeStatus('Draft');
    context.read<GateExitFilterCubit>().onSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInital(context);
    });
    return AppPageView2<GateExitFilterCubit>(
      mode: PageMode2.gateexit,

      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newGateExit.push<bool?>(context);
        if (refresh == true) {
          _fetchInital(context);
        }
      },

      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh:
            () {
              final filters = context.read<GateExitFilterCubit>().state;
              return context.cubit<GateExitCubit>().fetchInitial(
              Pair(StringUtils.docStatusInt(filters.status), filters.query),
            );
            },
        child: BlocListener<GateExitFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<GateExitCubit, GateExitForm>(
            childBuilder:
                (context, entry) => GateExitWidget(
                  gateExit: entry,
                    onTap: () async {
                    final refresh = await AppRoute.newGateExit
                        .push<bool?>(context, extra: entry);
                    if (refresh == true) {
                      _fetchInital(context);
                    }
                  },
                ),
            fetchInitial: () => _fetchInital(context),
            fetchMore: () => fetchMore(context),
            emptyListText: 'No GateExists Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<GateExitFilterCubit>().state;

    context.cubit<GateExitCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<GateExitFilterCubit>().state;

    context.cubit<GateExitCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
