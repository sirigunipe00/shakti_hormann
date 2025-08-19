import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/transport_filter_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/ui/widgets/transport_cnfrm_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';

class TransportCnfmList extends StatefulWidget {
  const TransportCnfmList({super.key});

  @override
  State<TransportCnfmList> createState() => _TransportCnfmListState();
}

class _TransportCnfmListState extends State<TransportCnfmList>
    with StatusModeSelectionMixin {
  String? status;
  String? query;
  @override
  void initState() {
    status = 'Draft';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInital(context, query, status!);
    });
    return AppPageView2<TransportFilterCubit>(
      mode: PageMode2.transportConfirmation,
      backgroundColor: AppColors.white,
      onNew: () => AppRoute.newTarnsportCnfrm.push(context),
      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh:
            () => context.cubit<TransportCubit>().fetchInitial(
              Pair(StringUtils.docStatuslogistic(status), query),
            ),
        child: BlocListener<TransportFilterCubit, PageViewFilters>(
          listener:
              (_, state) => _fetchInital(context, state.query, state.status),
          child:
              InfiniteListViewWidget<TransportCubit, TransportConfirmationForm>(
                childBuilder:
                    (context, entry) => TransportCnfrmWidget(
                      transport: entry,
                      onTap: () {
                        AppRoute.newTarnsportCnfrm.push<bool?>(
                          context,
                          extra: entry,
                        );
                      },
                    ),
                fetchInitial: () => _fetchInital(context, query, status),
                fetchMore: () => fetchMore(context),
                emptyListText: 'No Transports Found.',
              ),
        ),
      ),
      onSearch: () async {
        final selected = await showOptions(
          context,
          defaultValue: status,
          pageMode: PageMode2.transportConfirmation,
        );
        if (selected == null || !context.mounted) return;

        setState(() {
          status = selected;
          query = null;
          context.cubit<TransportFilterCubit>().onChangeStatus(status ?? '');
        });

        _fetchInital(context, query, status!);
      },
    );
  }

  void _fetchInital(BuildContext context, String? query, String? status) {
    context.cubit<TransportCubit>().fetchInitial(
      Pair(StringUtils.docStatuslogistic(status), query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<TransportFilterCubit>().state;

    context.cubit<TransportCubit>().fetchMore(
      Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
    );
  }
}
