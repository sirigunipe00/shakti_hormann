import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/vision_panel_filter_cubit.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/widget/vision_panel_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class VisionPanelList extends StatefulWidget {
  const VisionPanelList({super.key});

  @override
  State<VisionPanelList> createState() => _VisionPanelListState();
}

class _VisionPanelListState extends State<VisionPanelList>
    with StatusModeSelectionMixin {
  String? status;
  String? query;

  @override
  void initState() {
    status = 'Draft';
    context.read<VisionPanelFilterCubit>().onChangeStatus('Draft');
    context.read<VisionPanelFilterCubit>().onSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView2<VisionPanelFilterCubit>(
      mode: PageMode2.visionPanel,

      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newvisionPanel.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<VisionPanelFilterCubit>().state;

          return context.cubit<VisionPanelCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<VisionPanelFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<VisionPanelCubit, VisionModel>(
            childBuilder:
                (context, entry) => VisionPanelWidget(
                  vision: entry,
                  onTap: () async {
                    final refresh = await AppRoute.newvisionPanel.push<bool?>(
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
            emptyListText: 'No Vision Panels Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<VisionPanelFilterCubit>().state;
    context.cubit<VisionPanelCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<VisionPanelFilterCubit>().state;
    context.cubit<VisionPanelCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
