import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/gate_management_filter.dart';
import 'package:shakti_hormann/features/gate_management/presentation/ui/widget/gate_management_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';

class GateManagementList extends StatefulWidget {
  const GateManagementList({super.key});

  @override
  State<GateManagementList> createState() => _GateManagementListState();
}

class _GateManagementListState extends State<GateManagementList>
    with StatusModeSelectionMixin {
  String? status;
  String? query;

  @override
  void initState() {
    status = 'Draft';
    context.read<GateManagementFilter>().onChangeStatus('Draft');
    context.read<GateManagementFilter>().onSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInital(context);
    });
    return AppPageView2<GateManagementFilter>(
      mode: PageMode2.gateManagement,

      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newGateManagement.push<bool?>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },

      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh:
            () {
              final filters = context.read<GateManagementFilter>().state;
              return context.cubit<GateMangementCubit>().fetchInitial(
              Pair(StringUtils.docStatusInt(filters.status), filters.query),
            );
            },
            child: BlocListener<GateManagementFilter, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<GateMangementCubit, GateManagementForm>(
            childBuilder:
                (context, entry) => GateManagementWidget(
                  gateEntry: entry,
                  onTap: () async {
                    final refresh = await AppRoute.newGateManagement.push<bool?>(
                      context,
                      extra: entry,
                    );
                    if(!context.mounted) return;
                    if (refresh == true) {
                      _fetchInital(context);
                    }
                  },
                ),
            fetchInitial: () => _fetchInital(context),
            fetchMore: () => fetchMore(context),
            emptyListText: 'No GateEntries Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<GateManagementFilter>().state;

    context.cubit<GateMangementCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<GateManagementFilter>().state;

    context.cubit<GateMangementCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
