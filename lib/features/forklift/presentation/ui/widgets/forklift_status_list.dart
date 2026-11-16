import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';
import 'package:shakti_hormann/features/forklift/presentation/bloc/forklift_bloc_provider.dart';
import 'package:shakti_hormann/features/forklift/presentation/bloc/forklift_filter_cubit.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/widgets/forklift_status_card.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/widgets/forklift_status_detail_sheet.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class ForkliftStatusList extends StatefulWidget {
  const ForkliftStatusList({super.key});

  @override
  State<ForkliftStatusList> createState() => _ForkliftStatusListState();
}

class _ForkliftStatusListState extends State<ForkliftStatusList> {
  @override
  void initState() {
    super.initState();
    context.read<ForkliftStatusFilterCubit>().onChangeStatus('All');
    context.read<ForkliftStatusFilterCubit>().onSearch(null);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView2<ForkliftStatusFilterCubit>(
      mode: PageMode2.forkliftStatus,
      scaffoldBg: '',
      backgroundColor: const Color(0xFFF5F7FB),
      onNew: () {},
      child: RefreshIndicator(
        onRefresh: () async => _fetchInitial(context),
        child: BlocListener<ForkliftStatusFilterCubit, PageViewFilters>(
          listener: (_, __) => _fetchInitial(context),
          child: InfiniteListViewWidget<ForkliftStatusCubit, ForkliftInfo>(
            childBuilder: (context, entry) => ForkliftStatusCard(
              info: entry,
              onTap: () => _showDetail(context, entry),
            ),
            fetchInitial: () => _fetchInitial(context),
            fetchMore: () {},
            emptyListText: 'No forklifts found for this plant.',
          ),
        ),
      ),
    );
  }

  void _fetchInitial(BuildContext context) {
    final filters = context.read<ForkliftStatusFilterCubit>().state;
    context.cubit<ForkliftStatusCubit>().fetchInitial(
          Pair(filters.status, filters.query),
        );
  }

  Future<void> _showDetail(BuildContext context, ForkliftInfo info) async {
    final id = info.forklift ?? info.forkliftNo;
    if (id == null || id.isEmpty) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(color: Color(0xFFF2A93B)),
          ),
        ),
      ),
    );

    final result = await $sl.get<ForkliftRepo>().getForkliftDetail(id);
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // loading
    if (!context.mounted) return;

    result.fold(
      (l) => AppDialog.showErrorDialog(
        context,
        title: 'Error',
        content: l.error,
        onTapDismiss: context.exit,
      ),
      (detail) => showForkliftStatusDetailSheet(
        context: context,
        info: info,
        detail: detail,
      ),
    );
  }
}
