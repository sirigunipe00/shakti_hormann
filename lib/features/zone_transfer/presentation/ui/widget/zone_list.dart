import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/zone_filter_cubit.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/ui/widget/zone_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class ZoneListScrn extends StatefulWidget {
  const ZoneListScrn({super.key});

  @override
  State<ZoneListScrn> createState() => _ZoneListScrnState();
}

class _ZoneListScrnState extends State<ZoneListScrn> {
    String? status;
  String? query;

    @override
  void initState() {
    status = 'Draft';
    context.read<ZoneFilterCubit>().onChangeStatus('Draft');
    context.read<ZoneFilterCubit>().onSearch(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<ZoneFilterCubit>(
      mode: PageMode2.zoneTransfer,
      scaffoldBg: '',
      backgroundColor: AppColors.white,
     onNew: () async {
        final refresh = await AppRoute.newZoneTransfer.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<ZoneFilterCubit>().state;

          return context.cubit<ZoneCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<ZoneFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<ZoneCubit, Storage>(
            childBuilder: (context, entry) => ZoneWidget(
              gateEntry: entry,
              onTap: () async {
                      final refresh = await AppRoute.newZoneTransfer.push<bool?>(
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
            emptyListText: 'No Zone Transfer Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<ZoneFilterCubit>().state;
    context.cubit<ZoneCubit>().fetchInitial(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<ZoneFilterCubit>().state;

    context.cubit<ZoneCubit>().fetchMore(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }
}
