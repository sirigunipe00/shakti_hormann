import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/app/presentation/bloc/geo_permission/geo_permission_handler.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:shakti_hormann/features/auth/presentation/ui/sign_in/sign_in_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/gate_entry_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/bloc_provider.dart';

import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/loading_cnfm_filters_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/logistic_planning_filter_cubit.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/pod_filters_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/transport_filter_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/vehicle_reporting_filtercubit.dart';
import 'package:shakti_hormann/styles/material_theme.dart';

import 'features/gate_management/presentation/bloc/gate_management_filter.dart';


class ShaktiHormann extends StatefulWidget {
  const ShaktiHormann({super.key});

  @override
  State<ShaktiHormann> createState() => _ShaktiHormannState();
}

class _ShaktiHormannState extends State<ShaktiHormann>
    with WidgetsBindingObserver {
  bool _shouldRequestPermission = false;

  @override
  void initState() {
    // $sl.get<NotificationUsecase>().updateOSDetails();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (_shouldRequestPermission) {
        _shouldRequestPermission = false;
        handleCallBack();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => $sl.get<AuthCubit>()..authCheckRequested()),
        BlocProvider(create: (_) => $sl.get<SignInCubit>()),
        BlocProvider(create: (_) => GateEntryFilterCubit()),
        BlocProvider(create: (_) => GateExitFilterCubit()),
        BlocProvider(create: (_) => LogisticPlanningFilterCubit()),
        BlocProvider(create: (_) => TransportFilterCubit()),
        BlocProvider(create: (_) => VehicleReportingFilterCubit()),
        BlocProvider(create: (_) => LoadingCnfmFiltersCubit()),
        BlocProvider(create: (_) => PodFiltersCubit()),
        BlocProvider(create: (_) => GateManagementFilter()),


        // BlocProvider<GeoPermissionHandler>(
        //   create: (_) => GeoPermissionHandler(),
        // ),

        BlocProvider(
          create: (_) => GateEntryBlocProvider.get().fetchGateEntries(),
        ),
        BlocProvider(create: (_) => GateExitBlocProvider.get().fetchGateExit()),
        BlocProvider(
          create: (_) => LogisticPlanningBlocProvider.get().fetchLogistics(),
        ),
        BlocProvider(
          create: (_) => TransportCnfmBlocProvider.get().fetchTransport(),
        ),
        BlocProvider(create: (_) => VehicleBlocProvider.get().fetchVehicle()),
        BlocProvider(
          create: (_) => LoadingCnfmBlocProvider.get().fetchLoadingCnfmList(),
        ),
        BlocProvider(
          create:
              (_) => ProofOfDeliveryBlocProvider.get().fetchProofOfDelivery(),
        ),
        BlocProvider(create: (_) => GateManagementBlocProvider.get().fetchGateManagements())
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (_, state) {
              final routerCtxt =
                  AppRouterConfig.parentNavigatorKey.currentContext;
              if (routerCtxt == null) return;
              state.maybeWhen(
                authenticated: () {



                    // routerCtxt.cubit<GeoPermissionHandler>().checkPermission();


                  final filters = Pair(StringUtils.docStatusInt('Draft'), null);
                  final filter = Pair(
                    StringUtils.docStatuslogistic('Draft'),
                    null,
                  );
                  final filterss = Pair(
                    StringUtils.docStatusVehicle('Reported'),
                    null,
                  );
                  routerCtxt.cubit<GateEntriesCubit>().fetchInitial(filters);
                  routerCtxt.cubit<GateExitCubit>().fetchInitial(filters);
                  routerCtxt.cubit<LogisticPlanningCubit>().fetchInitial(
                    filter,
                  );
                  routerCtxt.cubit<TransportCubit>().fetchInitial(filter);
                  routerCtxt.cubit<VehicleReportingCubit>().fetchInitial(
                    filterss,
                  );
                  routerCtxt.cubit<LoadingCnfmCubit>().fetchInitial(filterss);
                  routerCtxt.cubit<ProofOfDeliveryCubit>().fetchInitial(
                    filters,
                  );
                  routerCtxt.cubit<GateMangementCubit>().fetchInitial(
                    filters,
                  );

                  AppRoute.home.go(routerCtxt);
                },
                unAuthenticated: () {
                  AppRoute.login.go(routerCtxt);
                },
                orElse: () {
                  AppRoute.login.go(routerCtxt);
                },
              );
            },
          ),

          // BlocListener<GeoPermissionHandler, GeoPermissionState>(
          //   listenWhen: (previous, current) => previous != current,
          //   listener: (_, state) async {
          //     final routerCtxt = AppRouterConfig.context;
          //     if (state is GeoLocationDenied) {
          //       log('GeoLocationDenied     ........');
          //       Geolocator.requestPermission().then((_) {
          //         routerCtxt.cubit<GeoPermissionHandler>().checkPermission();
          //       });
          //       return;
          //     }
          //     if (state is GeoLocationDeniedForever ||
          //         state is LocationPermissionPermDenied) {

          //       log('GeoLocationDeniedForever     ........');
          //       AppDialog.showErrorDialog<bool?>(
          //         routerCtxt,
          //         barrierDismissible: false,
          //         title: 'Grant Location Permission',
          //         content: 'Shakti Hormann needs your location permission',
          //         buttonText: 'Allow',
          //         onTapDismiss: () => routerCtxt.exit(true),
          //       ).then((value) async {
          //         if (value.isTrue) {
          //           _shouldRequestPermission = true;
          //           await Geolocator.openAppSettings();
          //         }
          //       });
          //     }
          //   },
          // ),
        ],
        child: MaterialApp.router(
          title: 'Shakti Hormann',
          theme: AppMaterialTheme.lightTheme,
          darkTheme: AppMaterialTheme.lightTheme,
          routerConfig: AppRouterConfig.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  void handleCallBack() {
    final context = AppRouterConfig.context;
    context.cubit<GeoPermissionHandler>().checkPermission();
  }
}