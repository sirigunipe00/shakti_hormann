import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/pallet_filter_cubit.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/ui/widget/pallet_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class PalletList extends StatefulWidget {
  const PalletList({super.key});

  @override
  State<PalletList> createState() => _PalletListState();
}

class _PalletListState extends State<PalletList> {
    String? status;
  String? query;

    @override
  void initState() {
    status = 'Draft';
    context.read<PalletFilterCubit>().onChangeStatus('Draft');
    context.read<PalletFilterCubit>().onSearch(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<PalletFilterCubit>(
      mode: PageMode2.palletCreation,
      scaffoldBg: '',
      backgroundColor: AppColors.white,
     onNew: () async {
        final refresh = await AppRoute.newPalletCreation.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<PalletFilterCubit>().state;

          return context.cubit<PalletCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<PalletFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<PalletCubit, FramePacking>(
            childBuilder: (context, entry) => PalletWidget(
              frame: entry,
              onTap: () async {
                      final refresh = await AppRoute.newPalletCreation.push<bool?>(
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
            emptyListText: 'No Pallet Creation Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<PalletFilterCubit>().state;
    context.cubit<PalletCubit>().fetchInitial(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<PalletFilterCubit>().state;

    context.cubit<PalletCubit>().fetchMore(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }
}