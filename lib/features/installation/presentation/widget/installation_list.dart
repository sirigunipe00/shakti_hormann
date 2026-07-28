import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/installation/model/installation_model.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/installation_filter_cubit.dart';
import 'package:shakti_hormann/features/installation/presentation/widget/installation_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class InstallationList extends StatefulWidget {
  const InstallationList({super.key});

  @override
  State<InstallationList> createState() => _InstallationListState();
}

class _InstallationListState extends State<InstallationList>
    with StatusModeSelectionMixin {
  String? status;
  String? query;

  @override
  void initState() {
    status = 'Draft';
    context.read<InstallationFilterCubit>().onChangeStatus('Draft');
    context.read<InstallationFilterCubit>().onSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView2<InstallationFilterCubit>(
      mode: PageMode2.installation,

      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newinstallation.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<InstallationFilterCubit>().state;

          return context.cubit<InstallationCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<InstallationFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<InstallationCubit, InstallationModel>(
            childBuilder:
                (context, entry) => InstallationWidget(
                  installation: entry,
                  onTap: () async {
                    final refresh = await AppRoute.newinstallation.push<bool?>(
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
            emptyListText: 'No Installation Entry Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<InstallationFilterCubit>().state;
    context.cubit<InstallationCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<InstallationFilterCubit>().state;
    context.cubit<InstallationCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
