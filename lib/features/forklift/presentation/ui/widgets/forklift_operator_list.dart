import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';
import 'package:shakti_hormann/features/forklift/presentation/bloc/forklift_bloc_provider.dart';
import 'package:shakti_hormann/features/forklift/presentation/bloc/forklift_filter_cubit.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/widgets/forklift_operator_card.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class ForkliftOperatorList extends StatefulWidget {
  const ForkliftOperatorList({super.key});

  @override
  State<ForkliftOperatorList> createState() => _ForkliftOperatorListState();
}

class _ForkliftOperatorListState extends State<ForkliftOperatorList> {
  @override
  Widget build(BuildContext context) {
    return AppPageView2<ForkliftOperatorFilterCubit>(
      mode: PageMode2.forkliftOperator,
      scaffoldBg: '',
      backgroundColor: const Color(0xFFF5F7FB),
      onNew: () async {
        final refreshed = await AppRoute.newForkliftOperator.push<bool>(
          context,
        );
        if (!context.mounted) return;
        if (refreshed == true) _fetchInitial(context);
      },
      appBarActions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Tooltip(
            message: 'Forklift Status',
            child: Semantics(
              label: 'Forklift Status',
              button: true,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => AppRoute.forkliftStatus.push(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.forklift,
                      size: 26,
                      color: Color(0xFF0E1446),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async => _fetchInitial(context),
        child: BlocListener<ForkliftOperatorFilterCubit, PageViewFilters>(
          listener: (_, __) => _fetchInitial(context),
          child: InfiniteListViewWidget<ForkliftOperatorCubit, ForkliftSession>(
            childBuilder: (context, entry) => ForkliftOperatorCard(
              session: entry,
              onTap: () async {
                await AppRoute.forkliftOperatorDetail.push<bool?>(
                  context,
                  extra: entry,
                );
                if (!context.mounted) return;
                _fetchInitial(context);
              },
            ),
            fetchInitial: () => _fetchInitial(context),
            fetchMore: () => _fetchMore(context),
            emptyListText:
                'No forklift sessions yet.\nTap New to scan a forklift QR.',
          ),
        ),
      ),
    );
  }

  void _fetchInitial(BuildContext context) {
    final filters = context.read<ForkliftOperatorFilterCubit>().state;
    context.cubit<ForkliftOperatorCubit>().fetchInitial(
          Pair(filters.status, filters.query),
        );
  }

  void _fetchMore(BuildContext context) {
    final filters = context.read<ForkliftOperatorFilterCubit>().state;
    context.cubit<ForkliftOperatorCubit>().fetchMore(
          Pair(filters.status, filters.query),
        );
  }
}
