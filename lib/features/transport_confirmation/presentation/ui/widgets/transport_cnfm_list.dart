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
    status = 'Pending From Transporter';
    context.read<TransportFilterCubit>().onChangeStatus(
      'Pending From Transporter',
    );
    context.read<TransportFilterCubit>().onSearch(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageView2<TransportFilterCubit>(
      mode: PageMode2.transportConfirmation,
      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newTarnsportCnfrm.push<bool>(context);
        if (refresh == true) {
          _fetchInital(context);
        }
      },
      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh:
            () {
              final filters = context.read<TransportFilterCubit>().state;
              return context.cubit<TransportCubit>().fetchInitial(
              Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
            );
            },
        child: BlocListener<TransportFilterCubit, PageViewFilters>(
          listener: (_, state) => _fetchInital(context),
          child:
              InfiniteListViewWidget<TransportCubit, TransportConfirmationForm>(
                childBuilder:
                    (context, entry) => TransportCnfrmWidget(
                      transport: entry,
                        onTap: () async {
                    final refresh = await AppRoute.newTarnsportCnfrm
                        .push<bool?>(context, extra: entry);
                    if (refresh == true) {
                      _fetchInital(context);
                    }
                  },
                    ),
                fetchInitial: () => _fetchInital(context),
                fetchMore: () => fetchMore(context),
                emptyListText: 'No Transports Found.',
              ),
        ),
      ),
    );
  }

  void _fetchInital(BuildContext context) {
    final filters = context.read<TransportFilterCubit>().state;
    context.cubit<TransportCubit>().fetchInitial(
      Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    final filters = context.read<TransportFilterCubit>().state;
    context.cubit<TransportCubit>().fetchMore(
      Pair(StringUtils.docStatuslogistic(filters.status), filters.query),
    );
  }
}
