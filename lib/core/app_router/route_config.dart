import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/app/presentation/bloc/app_update_bloc_provider.dart';
import 'package:shakti_hormann/app/presentation/bloc/geo_permission/geo_permission_handler.dart';
import 'package:shakti_hormann/app/presentation/bloc/location_distance/location_distance_cubit.dart';
import 'package:shakti_hormann/app/presentation/ui/app_profile_page.dart';
import 'package:shakti_hormann/app/presentation/ui/app_home_page.dart';
import 'package:shakti_hormann/app/presentation/ui/app_splash_scrn.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/dashboard/presentation/dashboard_page.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_scaffold_widget.dart';
import 'package:shakti_hormann/core/consts/messages.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/create/new_frame.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_list.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/create/new_gate_entry.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/widgets/gate_entry_list.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/create/new_gate_exit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/widgets/gate_exit_list.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_management/presentation/bloc/create_gate_management_cubit.dart/gate_management_cubit.dart';
import 'package:shakti_hormann/features/gate_management/presentation/ui/create/new_gate_management.dart';
import 'package:shakti_hormann/features/gate_management/presentation/ui/widget/gate_management_list.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/create_hardware_cubit/create_hardware_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/create_hardware_cubit/hardware_items_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/create/new_hardware.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/widget/hardware_list.dart';
import 'package:shakti_hormann/features/installation/model/installation_model.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/installation/presentation/bloc/create_installation_entry_cubit/create_installation_entry_cubit.dart';
import 'package:shakti_hormann/features/installation/presentation/ui/new_installation_entry.dart';
import 'package:shakti_hormann/features/installation/presentation/widget/installation_list.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/create/new_loading_confirmation.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/widgets/loading_cnfrm_list.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/create/new_logistic_request.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/widgets/logistic_request_list.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/bloc/create_pallet_cubit.dart/create_pallet_cubit.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/ui/create/new_pallet.dart';
import 'package:shakti_hormann/features/pallet_creation/presentation/ui/widget/pallet_list.dart';
import 'package:shakti_hormann/features/proof_of_delivery/model/proof_of_delivery.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/bloc/create_pd_cubit/create_pod_cubit.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/ui/new_pod.dart';
import 'package:shakti_hormann/features/proof_of_delivery/presentation/widget/pod_list.dart';
import 'package:shakti_hormann/features/push_notifications.dart/ui/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/push_notifications.dart/ui/notification_scrn.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_packing.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/create_shutter_cubit.dart/create_shutter_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/create/new_shutter.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/shutter_list.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/ui/create/new_storage.dart';
import 'package:shakti_hormann/features/storage_allocation/presentation/ui/widget/storage_list.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/ui/create/new_transport.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/ui/widgets/transport_cnfm_list.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/ui/create/new_vehicle_reporting.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/ui/widgets/vehicle_reporting_list.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/ui/new_vision.dart';
import 'package:shakti_hormann/features/vision_panel/presentation/ui/vision_panel_list.dart';
import 'package:shakti_hormann/features/zone_transfer/model/zone_transfer.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/create_zone_cubit/create_zone_cubit.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/ui/widget/zone_list.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';

class AppRouterConfig {
  static final parentNavigatorKey = GlobalKey<NavigatorState>();
  static final context = parentNavigatorKey.currentState!.context;

  static int dashboardStatus = 0;

  static void setDashboardStatus(int status) {
    dashboardStatus = status;
  }

  static final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: AppRoute.login.path,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.login.path,
        builder: (_, state) => const AppSplashScrn(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          LoggedInUser? loggedInUser;

          try {
            loggedInUser =
                $sl.isRegistered<LoggedInUser>() ? $sl<LoggedInUser>() : null;
          } catch (_) {
            loggedInUser = null;
          }

          final roleStatus = loggedInUser?.roleStatus;
          AppRouterConfig.setDashboardStatus(
            roleStatus?.showDashboards == 1 ? 1 : 0,
          );

          return AppScaffoldWidget(
            navigationShell: navigationShell,
            roleStatus: roleStatus,
          );
        },

        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                builder:
                    (_, state) => BlocProvider(
                      create:
                          (_) =>
                              AppUpdateBlocprovider.get().appversionCubit()
                                ..request(),
                      child: const AppHomePage(),
                    ),
                routes: [
                  GoRoute(
                    path: _getPath(AppRoute.notifications),
                    builder:
                        (ctxt, state) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create:
                                  (_) =>
                                      NotificationBlocProvider.get()
                                          .fetchNotifications()
                                        ..request(),
                            ),
                          ],
                          child: const NotificationListScreen(),
                        ),
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.gateEntry),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                GateEntryBlocProvider.get().fetchGateEntries()
                                  ..fetchInitial(filters),
                        child: const GateEntryListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newGateEntry),
                        onExit: (context, state) async {
                          final form = state.extra as GateEntryForm?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final gateEntryForm = state.extra as GateEntryForm?;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) =>
                                        GateEntryBlocProvider.get()
                                            .purchaseOrderList()
                                          ..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        GateEntryBlocProvider.get()
                                            .gateNumberList()
                                          ..request(''),
                              ),

                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateGateEntryCubit>()
                                          ..initDetails(gateEntryForm),
                              ),

                              BlocProvider(
                                create:
                                    (_) =>
                                        GateEntryBlocProvider.get()
                                            .getPurchase()
                                          ..request(gateEntryForm?.name ?? ''),
                              ),
                            ],
                            child: const NewGateEntry(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.gatexit),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                GateExitBlocProvider.get().fetchGateExit()
                                  ..fetchInitial(filters),
                        child: const GateExitListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        onExit: (context, state) async {
                          final form = state.extra as GateExitForm?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        path: _getPath(AppRoute.newGateExit),
                        builder: (_, state) {
                          final form = state.extra as GateExitForm?;

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) =>
                                        GateExitBlocProvider.get()
                                            .salesInvoiceList()
                                          ..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        GateExitBlocProvider.get().getSales()
                                          ..request(form?.name ?? ''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateGateExitCubit>()
                                          ..initDetails(form),
                              ),
                            ],
                            child: const NewGateExit(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.logisticRequest),
                    builder: (ctxt, state) {
                      final filters = Triple(
                        StringUtils.docStatuslogistic('Draft'),
                        null,
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                LogisticPlanningBlocProvider.get()
                                    .fetchLogistics()
                                  ..fetchInitial(filters),
                        child: const LogisticRequestList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newLogisticRequest),
                        onExit: (context, state) async {
                          final form = state.extra as LogisticPlanningForm?;
                          final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Draft';
                          return _promptConf(context, formStatus: formStatus);
                        },
                        builder: (_, state) {
                          final bloc = LogisticPlanningBlocProvider.get();
                          final logisticForm =
                              state.extra as LogisticPlanningForm?;

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateLogisticCubit>()
                                          ..initDetails(logisticForm),
                              ),
                              BlocProvider(
                                create:
                                    (_) => bloc.salesOrderList()..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) => bloc.transportersList()..request(''),
                              ),
                              BlocProvider(
                                create: (_) => bloc.vehicleList()..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        bloc.salesList()
                                          ..request(logisticForm?.name ?? ''),
                              ),
                            ],
                            child: const NewLogisticRequest(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.transportConfirmation),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatuslogistic(
                          'Pending From Transporter',
                        ),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                TransportCnfmBlocProvider.get().fetchTransport()
                                  ..fetchInitial(filters),
                        child: const TransportCnfmList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newTarnsportCnfrm),
                        onExit: (context, state) async {
                          final form =
                              state.extra as TransportConfirmationForm?;
                          final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Draft';
                          return _promptConf(context, formStatus: formStatus);
                        },
                        builder: (_, state) {
                          final bloc = LogisticPlanningBlocProvider.get();

                          final form = state.extra;
                          final logisticform =
                              state.extra as TransportConfirmationForm?;

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) => bloc.transportersList()..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        bloc.salesList()
                                          ..request(logisticform?.name ?? ''),
                              ),

                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateLogisticCubit>()
                                          ..initDetails(logisticform),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateTransportCubit>()
                                          ..initDetails(form),
                              ),
                            ],
                            child: const NewTransportCnfm(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.vehcileReporting),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusVehicle('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                VehicleBlocProvider.get().fetchVehicle()
                                  ..fetchInitial(filters),
                        child: const VehicleReportingList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newVehiclereporting),
                        onExit: (context, state) async {
                          final form = state.extra as VehicleReportingForm?;
                          final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Reported';
                          return _promptConf(context, formStatus: formStatus);
                        },
                        builder: (_, state) {
                          final bloc = VehicleBlocProvider.get();
                          final blocprovider =
                              LogisticPlanningBlocProvider.get();
                          final form = state.extra;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateVehicleCubit>()
                                          ..initDetails(form),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        blocprovider.transportersList()
                                          ..request(''),
                              ),
                              BlocProvider(
                                create: (_) => bloc.logisticList()..request(''),
                              ),
                            ],
                            child: const NewVehicleReporting(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.loadingConfirmation),
                    builder: (ctxt, state) {
                      final filters = Triple(
                        StringUtils.docStatusVehicle('Reported'),
                        null,
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                LoadingCnfmBlocProvider.get()
                                    .fetchLoadingCnfmList()
                                  ..fetchInitial(filters),
                        child: const LoadingCnfrmList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newLoadingConfirmation),
                        onExit: (context, state) async {
                          final form = state.extra as LoadingCnfmForm?;
                          final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Reported';
                          return _promptConf(context, formStatus: formStatus);
                        },
                        builder: (_, state) {
                          final blocprovider = LoadingCnfmBlocProvider.get();
                          final form = state.extra as LoadingCnfmForm;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) => blocprovider.fetchLoadingCnfmList(),
                              ),
                              BlocProvider(
                                create: (_) => blocprovider.itemList(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        blocprovider.getItems()
                                          ..request(form.name ?? ''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        blocprovider.getLogisticList()
                                          ..request(form.name ?? ''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateLoadingCnfmCubit>()
                                          ..initDetails(form),
                              ),
                            ],
                            child: const NewLoadingConfirmation(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.proofOfDelivery),
                    builder: (ctxt, state) {
                      final form = state.extra as ProofOfDelivery?;

                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create:
                                (context) =>
                                    ProofOfDeliveryBlocProvider.get()
                                        .fetchProofOfDelivery()
                                      ..fetchInitial(filters),
                          ),
                          BlocProvider<GeoPermissionHandler>(
                            create:
                                (_) =>
                                    GeoPermissionHandler()..checkPermission(),
                          ),

                          BlocProvider(
                            create:
                                (_) =>
                                    $sl.get<CreatePodCubit>()
                                      ..initDetails(form),
                          ),
                        ],
                        child: const PodListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newproofOfDelivery),
                        onExit: (context, state) async {
                          final form = state.extra as ProofOfDelivery?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Reported';
                          return _promptConf(context, formStatus: formStatus);
                        },
                        builder: (_, state) {
                          final blocprovider =
                              ProofOfDeliveryBlocProvider.get();
                          final form = state.extra as ProofOfDelivery?;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) => blocprovider.fetchProofOfDelivery(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        blocprovider.salesInvoiceList()
                                          ..request(''),
                              ),

                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<LocationDistanceCubit>()
                                          ..getCurrentLocation(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreatePodCubit>()
                                          ..initDetails(form),
                              ),
                            ],
                            child: const NewPod(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.gateManagement),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                GateManagementBlocProvider.get()
                                    .fetchGateManagements()
                                  ..fetchInitial(filters),
                        child: const GateManagementList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newGateManagement),
                        onExit: (context, state) async {
                          final form = state.extra as GateManagementForm?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final gateEntryForm =
                              state.extra as GateManagementForm?;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateGateManagementCubit>()
                                          ..initDetails(gateEntryForm),
                              ),
                            ],
                            child: const NewGateManagement(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.storageAllocation),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                StorageBlocProvider.get().fetchStorage()
                                  ..fetchInitial(filters),
                        child: const StorageListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newStorageAllocation),
                        onExit: (context, state) async {
                          final form = state.extra as Storage?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final storageForm = state.extra as Storage?;
                          final storageBloc = StorageBlocProvider.get();
                          final zoneBloc = ZoneBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => storageBloc.fetchStorage(),
                              ),
                              BlocProvider(create: (_) => zoneBloc.fetchZone()),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateZoneCubit>()
                                          ..initDetails(storageForm),
                              ),
                            ],
                            child: const NewEntry(),
                          );
                        },
                        // builder: (_, state) {
                        //   final storageForm = state.extra as Storage?;
                        //   final blocprovider = StorageBlocProvider.get();
                        //   return MultiBlocProvider(
                        //     providers: [
                        //       BlocProvider(
                        //         create: (_) => blocprovider.fetchStorage(),
                        //       ),
                        //       BlocProvider(
                        //         create:
                        //             (_) =>
                        //                 $sl.get<CreateStorageCubit>()
                        //                   ..initDetails(storageForm),
                        //       ),
                        //     ],
                        //     child: const NewStorage(),
                        //   );
                        // },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.hardwarePackaging),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                HardwareBlocProvider.get().fetchHardware()
                                  ..fetchInitial(filters),
                        child: const HardwareListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newHardwarePackaging),
                        onExit: (context, state) async {
                          final form = state.extra as HardwarePacking?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final hardwareForm = state.extra as HardwarePacking?;
                          final blocprovider = HardwareBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.fetchHardware(),
                              ),
                              BlocProvider(
                                create: (_) {
                                  final itemsCubit =
                                      blocprovider.getItemsLines();
                                  final docName = hardwareForm?.name;
                                  if (docName != null && docName.isNotEmpty) {
                                    itemsCubit.request(docName);
                                  }
                                  return itemsCubit;
                                },
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateHardwareCubit>()
                                          ..initDetails(hardwareForm),
                              ),
                              BlocProvider(
                                create:
                                    (_) => $sl.get<HardwarePackingItemsCubit>(),
                              ),
                            ],
                            child: const NewHardware(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.zoneTransfer),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                ZoneBlocProvider.get().fetchZone()
                                  ..fetchInitial(filters),
                        child: const ZoneListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newZoneTransfer),
                        onExit: (context, state) async {
                          final extra = state.extra;
                          final form = extra is ZoneTransfer ? extra : null;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        // onExit: (context, state) async {
                        //   final form = state.extra as ZoneTransfer?? extra : null;
                        //   final formStatus =
                        //       form?.docStatus == 1 ? 'Submitted' : 'Draft';
                        //   return await _promptConf(
                        //     context,
                        //     formStatus: formStatus,
                        //   );
                        // },
                        builder: (_, state) {
                          final extra = state.extra;
                          final zoneForm = extra is ZoneTransfer ? extra : null;
                          final moveFromStorage =
                              extra is Storage ? extra : null;
                          final blocprovider = ZoneBlocProvider.get();

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.fetchZone(),
                              ),
                              BlocProvider(
                                create: (_) {
                                  final cubit = $sl.get<CreateZoneCubit>();
                                  if (zoneForm != null) {
                                    cubit.initDetails(zoneForm);
                                  } else if (moveFromStorage != null) {
                                    cubit.initFromStorage(moveFromStorage);
                                  }
                                  return cubit;
                                },
                              ),
                            ],
                            child: const NewEntry(),
                          );
                        },
                        // builder: (_, state) {
                        //   final zoneForm = state.extra as ZoneTransfer?;
                        //   final zoneBloc = ZoneBlocProvider.get();
                        //   final storageBloc = StorageBlocProvider.get();
                        //   return MultiBlocProvider(
                        //     providers: [
                        //       BlocProvider(create: (_) => zoneBloc.fetchZone()),
                        //       BlocProvider(
                        //         create:
                        //             (_) =>
                        //                 $sl.get<CreateZoneCubit>()
                        //                   ..initDetails(zoneForm),
                        //       ),
                        //       BlocProvider(
                        //         create: (_) => storageBloc.fetchStorage(),
                        //       ),
                        //       BlocProvider(
                        //         create:
                        //             (_) =>
                        //                 $sl.get<CreateStorageCubit>()
                        //                   ..initDetails(null),
                        //       ),
                        //     ],
                        //     child: const NewEntry(),
                        //   );
                        // },
                        // builder: (_, state) {
                        //   final zoneForm = state.extra as ZoneTransfer?;
                        //   final blocprovider = ZoneBlocProvider.get();
                        //   return MultiBlocProvider(
                        //     providers: [
                        //       BlocProvider(
                        //         create: (_) => blocprovider.fetchZone(),
                        //       ),
                        //       BlocProvider(
                        //         create:
                        //             (_) =>
                        //                 $sl.get<CreateZoneCubit>()
                        //                   ..initDetails(zoneForm),
                        //       ),
                        //     ],
                        //     child: const NewZone(),
                        //   );
                        // },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.shutterPackaging),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                ShutterBlocProvider.get().fetchShutter()
                                  ..fetchInitial(filters),
                        child: const ShutterListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newshutterPackaging),
                        onExit: (context, state) async {
                          final form = state.extra as ShutterPacking?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final shutter = state.extra as ShutterPacking?;
                          final blocprovider = ShutterBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.fetchShutter(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        ShutterBlocProvider.get()
                                            .getSales()
                                          ..request(''),
                              ),
                              BlocProvider(
                                create: (_) => blocprovider.getPalletSize()..request(),
                              ),
                              BlocProvider(
                                create: (_) {
                                  final linesCubit =
                                      blocprovider.getShutterLines();
                                  final docName = shutter?.name;
                                  if (docName != null && docName.isNotEmpty) {
                                    linesCubit.request(docName);
                                  }
                                  return linesCubit;
                                },
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateShutterCubit>()
                                          ..initDetails(shutter),
                              ),
                            ],
                            child: const NewShutter(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.framePackaging),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                FrameBlocProvider.get().fetchFrames()
                                  ..fetchInitial(filters),
                        child: const FrameListScrn(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newframePackaging),
                        onExit: (context, state) async {
                          final form = state.extra as FramePacking?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final frame = state.extra as FramePacking?;
                          final blocprovider = FrameBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.fetchFrames(),
                              ),
                              BlocProvider(
                                create: (_) => blocprovider.fetchPalletSize()..request(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        ShutterBlocProvider.get()
                                            .getSales()
                                          ..request(''),
                              ),
                              BlocProvider(
                                create: (_) {
                                  final linesCubit =
                                      blocprovider.getFrameLines();
                                  final docName = frame?.name;
                                  if (docName != null && docName.isNotEmpty) {
                                    linesCubit.request(docName);
                                  }
                                  return linesCubit;
                                },
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateFrameCubit>()
                                          ..initDetails(frame),
                              ),
                            ],
                            child: const NewFrame(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.palletCreation),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                PalletBlocProvider.get().getPallet()
                                  ..fetchInitial(filters),
                        child: const PalletList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newPalletCreation),
                        onExit: (context, state) async {
                          final form = state.extra as PalletModel?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final frame = state.extra as PalletModel?;
                          final blocprovider = PalletBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.getPallet(),
                              ),
                               BlocProvider(
                                create: (_) => blocprovider.getPalletItems()..request(frame?.name ?? ''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        PalletBlocProvider.get()
                                            .saleOrder()
                                          ..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreatePalletCubit>()
                                          ..initDetails(frame),
                              ),
                            ],
                            child: const NewPallet(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.visionPanel),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                VisionPanelBlocProvider.get().fetchVision()
                                  ..fetchInitial(filters),
                        child: const VisionPanelList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newvisionPanel),
                        onExit: (context, state) async {
                          final form = state.extra as VisionModel?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final shutter = state.extra as VisionModel?;
                          final blocprovider = VisionPanelBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.fetchVision(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        VisionPanelBlocProvider.get()
                                            .getVisionLines()
                                          ..request(shutter?.name),
                              ),
                              BlocProvider(
                                create: (_) => PalletBlocProvider.get().saleOrder()..request(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        blocprovider.getentryLines()
                                          ..request(shutter?.name ?? ''),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        VisionPanelBlocProvider.get().getProduct()
                                          ..request(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateVisionPanelCubit>()
                                          ..initDetails(shutter),
                              ),
                            ],
                            child: const NewVision(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.installation),
                    builder: (ctxt, state) {
                      final filters = Pair(
                        StringUtils.docStatusInt('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) =>
                                InstallationBlocProvider.get().getInstallation()
                                  ..fetchInitial(filters),
                        child: const InstallationList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newinstallation),
                        onExit: (context, state) async {
                          final form = state.extra as InstallationModel?;
                          final formStatus =
                              form?.docStatus == 1 ? 'Submitted' : 'Draft';
                          return await _promptConf(
                            context,
                            formStatus: formStatus,
                          );
                        },
                        builder: (_, state) {
                          final shutter = state.extra as InstallationModel?;
                          final blocprovider = InstallationBlocProvider.get();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.getInstallation(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        InstallationBlocProvider.get()
                                            .getInstallationLines()
                                          ..request(shutter?.name),
                              ),
                              BlocProvider(
                                create: (_) => PalletBlocProvider.get().saleOrder()..request(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        VisionPanelBlocProvider.get().getProduct()
                                          ..request(),
                              ),
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateInstallationEntryCubit>()
                                          ..initDetails(shutter),
                              ),
                            ],
                            child: const NewInstallationEntry(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.dashboard.path,
                redirect:
                    (_, __) => dashboardStatus == 1 ? null : AppRoute.home.path,
                builder: (_, __) => const AppDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.account.path,
                builder: (_, __) => const AppProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static Future<bool> _promptConf(
    BuildContext context, {
    required String formStatus,
  }) async {
    final promptConf = shouldAskForConfirmation.value;
    if (!promptConf) return true;
    if (formStatus == 'Submitted' || formStatus == 'Pending From Transporter') {
      return true;
    }
    final result = await AppDialog.askForConfirmation<bool?>(
      context,
      title: 'Are you sure?',
      confirmBtnText: 'Yes',
      content: Messages.clearConfirmation,
      onTapConfirm: () => context.pop(true),
      onTapDismiss: () => context.pop(false),
    );
    return result ?? false;
  }

  static String _getPath(AppRoute route) => route.path.split('/').last;
}
