import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_widget.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/hardware_filter_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class HardwareListScrn extends StatefulWidget {
  const HardwareListScrn({super.key});

  @override
  State<HardwareListScrn> createState() => _HardwareListScrnState();
}

class _HardwareListScrnState extends State<HardwareListScrn> {
    String? status;
  String? query;

    @override
  void initState() {
    status = 'Draft';
    context.read<HardWareFilterCubit>().onChangeStatus('Draft');
    context.read<HardWareFilterCubit>().onSearch(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<HardWareFilterCubit>(
      mode: PageMode2.hardwarePackaging,
      scaffoldBg: '',
      backgroundColor: AppColors.white,
     onNew: () async {
        final refresh = await AppRoute.newHardwarePackaging.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<HardWareFilterCubit>().state;

          return context.cubit<FrameCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<HardWareFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<FrameCubit, FramePacking>(
            childBuilder: (context, entry) => FrameWidget(
              frame: entry,
              onTap: () async {
                      final refresh = await AppRoute.newHardwarePackaging.push<bool?>(
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
    final filters = context.read<HardWareFilterCubit>().state;
    context.cubit<FrameCubit>().fetchInitial(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<HardWareFilterCubit>().state;

    context.cubit<FrameCubit>().fetchMore(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }
}
