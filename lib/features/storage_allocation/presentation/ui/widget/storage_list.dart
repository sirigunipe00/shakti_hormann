import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_widget.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/storage_filter_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class StorageListScrn extends StatefulWidget {
  const StorageListScrn({super.key});

  @override
  State<StorageListScrn> createState() => _StorageListScrnState();
}

class _StorageListScrnState extends State<StorageListScrn> {
    String? status;
  String? query;

    @override
  void initState() {
    status = 'Draft';
    context.read<StorageFilterCubit>().onChangeStatus('Draft');
    context.read<StorageFilterCubit>().onSearch(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<StorageFilterCubit>(
      mode: PageMode2.storageAllocation,
      scaffoldBg: '',
      backgroundColor: AppColors.white,
     onNew: () async {
        final refresh = await AppRoute.newStorageAllocation.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<StorageFilterCubit>().state;

          return context.cubit<FrameCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<StorageFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<FrameCubit, FramePacking>(
            childBuilder: (context, entry) => FrameWidget(
              frame: entry,
              onTap: () async {
                      final refresh = await AppRoute.newStorageAllocation.push<bool?>(
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
            emptyListText: 'No Storage Allocation Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<StorageFilterCubit>().state;
    context.cubit<FrameCubit>().fetchInitial(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<StorageFilterCubit>().state;

    context.cubit<FrameCubit>().fetchMore(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }
}
