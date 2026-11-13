import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/storage_filter_cubit.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/ui/widget/storage_widget.dart';
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
        await AppRoute.newStorageAllocation.push<bool>(context);
        if (!context.mounted) return;
        _fetchInital(context);
      },
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<StorageFilterCubit>().state;
          return context.cubit<StorageCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<StorageFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<StorageCubit, Storage>(
            childBuilder: (context, entry) => StorageWidget(
              gateEntry: entry,
              onTap: () async {
                await AppRoute.newStorageAllocation.push<bool?>(
                  context,
                  extra: entry,
                );
                if (!context.mounted) return;
                _fetchInital(context);
              },
            ),
            fetchInitial: () => _fetchInital(context),
            fetchMore: () => fetchMore(context),
            emptyListText:
                'No storage / zone records yet.\nTap New to scan a pallet and assign a zone.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<StorageFilterCubit>().state;
    context.cubit<StorageCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<StorageFilterCubit>().state;
    context.cubit<StorageCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
