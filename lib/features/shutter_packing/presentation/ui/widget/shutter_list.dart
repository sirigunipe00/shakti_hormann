import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_packing.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/shutter_filter_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/shutter_packing_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class ShutterListScrn extends StatefulWidget {
  const ShutterListScrn({super.key});

  @override
  State<ShutterListScrn> createState() => _ShutterListScrnState();
}

class _ShutterListScrnState extends State<ShutterListScrn> {
    String? status;
  String? query;

    @override
  void initState() {
    status = 'Draft';
    context.read<ShutterFilterCubit>().onChangeStatus('Draft');
    context.read<ShutterFilterCubit>().onSearch(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<ShutterFilterCubit>(
      mode: PageMode2.shutterPacking,
      scaffoldBg: '',
      backgroundColor: AppColors.white,
     onNew: () async {
        final refresh = await AppRoute.newshutterPackaging.push<bool>(context);
        if(!context.mounted) return;
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<ShutterFilterCubit>().state;

          return context.cubit<ShutterCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<ShutterFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child: InfiniteListViewWidget<ShutterCubit, ShutterPacking>(
            childBuilder: (context, entry) => ShutterPackingWidget(
              shutter: entry,
              onTap: () async {
                      final refresh = await AppRoute.newshutterPackaging.push<bool?>(
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
            emptyListText: 'No Shutter Packing Found.',
          ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<ShutterFilterCubit>().state;
    context.cubit<ShutterCubit>().fetchInitial(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<ShutterFilterCubit>().state;

    context.cubit<ShutterCubit>().fetchMore(
        Pair(StringUtils.docStatusInt(filters.status), filters.query));
  }
}
