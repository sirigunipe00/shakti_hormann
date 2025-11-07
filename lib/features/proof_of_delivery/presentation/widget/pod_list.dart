import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/bloc/location_distance/location_distance_cubit.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_page_view2.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/features/proof_of_delivery/model/proof_of_delivery.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/create_pd_cubit/create_pod_cubit.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/pod_filters_cubit.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/widget/pod_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/infinite_list_widget.dart';
import 'package:shakti_hormann/app/presentation/widgets/staticlist_tile.dart';
import 'package:shakti_hormann/widgets/inputs/geolocator.dart';

class PodListScrn extends StatefulWidget {
  const PodListScrn({super.key});

  @override
  State<PodListScrn> createState() => _PodListScrnState();
}

class _PodListScrnState extends State<PodListScrn>
    with StatusModeSelectionMixin, WidgetsBindingObserver {
  String? status;
  String? query;
  //   double? _latitude;
  //   double? _longitude;

  //      @override
  //   void initState() {
  //     super.initState();
  //     WidgetsBinding.instance.addObserver(this);
  //     _fillCurrentLocation();
  //   }
  // @override
  //   void dispose() {
  //     WidgetsBinding.instance.removeObserver(this);
  //     super.dispose();
  //   }
  //  @override
  //   void didChangeAppLifecycleState(AppLifecycleState state) {
  //     if (state == AppLifecycleState.resumed) {
  //       _fillCurrentLocation();
  //     }
  //   }

  // void _fillCurrentLocation() async {
  //   final position = await determinePositionWithAlert(context);

  //   if (!mounted) return;

  //   if (position != null) {
  //     if (mounted) {
  //       setState(() {
  //         _latitude = position.latitude;
  //         _longitude = position.longitude;
  //       });
  //     }

  //     $logger.devLog('Current Position: Lat=$_latitude, Lng=$_longitude');

  //     if (mounted) {
  //       context.read<CreatePodCubit>().onValueChanged(
  //             geoLatitude: _latitude,
  //             geoLongitude: _longitude,
  //           );
  //     }
  //   } else {
  //     $logger.devLog('Could not fetch user location.');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return AppPageView2<PodFiltersCubit>(
      mode: PageMode2.proofOfDelivery,
      backgroundColor: AppColors.white,
      onNew: () async {
        final refresh = await AppRoute.newproofOfDelivery.push<bool?>(context);
        if (!context.mounted) return;
        if (refresh == true) {
          _fetchInitial(context);
        }
      },
      scaffoldBg: '',
      child: RefreshIndicator(
        onRefresh: () {
          final filters = context.read<PodFiltersCubit>().state;
          return context.cubit<ProofOfDeliveryCubit>().fetchInitial(
            Pair(StringUtils.docStatusInt(filters.status), filters.query),
          );
        },
        child: BlocListener<PodFiltersCubit, PageViewFilters>(
          listener: (_, state) {
            if (mounted) _fetchInitial(context);
          },
          child: BlocBuilder<LocationDistanceCubit, LocationDistanceState>(
            builder: (context, state) {
              print('state...:$state');

              // if (state.failure != null || state.distance = null) {
              context.cubit<LocationDistanceCubit>().enableLocation();

              // }

              if (state.distance != null) {
                print('sattaelksgksg..:${state.distance}');
              }

              return InfiniteListViewWidget<
                ProofOfDeliveryCubit,
                ProofOfDelivery
              >(
                childBuilder:
                    (context, entry) => PodWidget(
                      pod: entry,
                      onTap: () async {
                        final refresh = await AppRoute.newproofOfDelivery
                            .push<bool?>(context, extra: entry);
                        if (!context.mounted) return;
                        if (refresh == true && mounted) {
                          _fetchInitial(context);
                        }
                      },
                    ),
                fetchInitial: () => _fetchInitial(context),
                fetchMore: () => fetchMore(context),
                emptyListText: 'No POD Found.',
              );
            },
          ),
        ),
      ),
    );
  }

  void _fetchInitial(BuildContext context) {
    if (!mounted) return;
    final filters = context.read<PodFiltersCubit>().state;

    context.cubit<ProofOfDeliveryCubit>().fetchInitial(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }

  void fetchMore(BuildContext context) {
    if (!mounted) return;
    final filters = context.read<PodFiltersCubit>().state;

    context.cubit<ProofOfDeliveryCubit>().fetchMore(
      Pair(StringUtils.docStatusInt(filters.status), filters.query),
    );
  }
}
