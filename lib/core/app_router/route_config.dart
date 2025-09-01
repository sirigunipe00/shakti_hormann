import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/app/presentation/ui/app_profile_page.dart';
import 'package:shakti_hormann/app/presentation/ui/app_home_page.dart';
import 'package:shakti_hormann/app/presentation/ui/app_splash_scrn.dart';
import 'package:shakti_hormann/app/presentation/ui/dashboard_page.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_scaffold_widget.dart';
import 'package:shakti_hormann/app/presentation/widgets/notifcations_scrn.dart';
import 'package:shakti_hormann/core/consts/messages.dart';
import 'package:shakti_hormann/core/core.dart';
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
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';

class AppRouterConfig {
  static final parentNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: AppRoute.login.path,
    routes: <RouteBase>[
      // GoRoute(
      //   path: AppRoute.initial.path,
      //   builder: (_, state) => const AppSplashScrn(),
      // ),
      GoRoute(
        path: AppRoute.login.path,
        builder: (_, state) => const AppSplashScrn(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffoldWidget(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                builder: (_, state) => const AppHomePage(),
                routes: [
                  GoRoute(
                    path: _getPath(AppRoute.notifications),
                    builder: (ctxt, state) => NotificationListScreen(),
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
                            (context) => GateEntryBlocProvider.get().fetchGateEntries()..fetchInitial(filters),
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
                                        $sl.get<CreateGateEntryCubit>()
                                          ..initDetails(gateEntryForm),
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
                            (context) => GateExitBlocProvider.get().fetchGateExit()..fetchInitial(filters),
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
                    
                      final filters = Pair(
                        StringUtils.docStatuslogistic('Draft'),
                        null,
                      );
                      return BlocProvider(
                        create: (context) => LogisticPlanningBlocProvider.get().fetchLogistics()..fetchInitial(filters),
                        child: const LogisticRequestList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newLogisticRequest),
                        onExit:
                            (context, state) async{
                              final form = state.extra as LogisticPlanningForm?;
                                final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Draft';
                               return  _promptConf(context, formStatus: formStatus);
                            },
                        builder: (_, state) {
                          final bloc = LogisticPlanningBlocProvider.get();
                          final lofisticForm =
                              state.extra as LogisticPlanningForm?;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) =>
                                        $sl.get<CreateLogisticCubit>()
                                          ..initDetails(lofisticForm),
                              ),
                              BlocProvider(
                                create:
                                    (_) => bloc.salesOrderList()..request(''),
                              ),
                              BlocProvider(
                                create:
                                    (_) => bloc.transportersList()..request(''),
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
                        StringUtils.docStatuslogistic('Pending From Transporter'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) => TransportCnfmBlocProvider.get().fetchTransport()..fetchInitial(filters),
                        child: const TransportCnfmList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newTarnsportCnfrm),
                        onExit:
                            (context, state) async {
                                   final form = state.extra as TransportConfirmationForm?;
                                final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Draft';
                               return  _promptConf(context, formStatus: formStatus);
                            },
                        builder: (_, state) {
                          final bloc = LogisticPlanningBlocProvider.get();

                          final form = state.extra;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (_) => bloc.transportersList()..request(''),
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
                        StringUtils.docStatusVehicle('Reported'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) => VehicleBlocProvider.get().fetchVehicle()..fetchInitial(filters),
                        child: const VehicleReportingList(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newVehiclereporting),
                        onExit:
                            (context, state) async 
                            {
                               final form = state.extra as VehicleReportingForm?;
                                final formStatus =
                              form?.docstatus == 1 ? 'Submitted' : 'Reported';
                               return  _promptConf(context, formStatus: formStatus);
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
                      final filters = Pair(
                        StringUtils.docStatusVehicle('Reported'),
                        null,
                      );
                      return BlocProvider(
                        create:
                            (context) => LoadingCnfmBlocProvider.get().fetchLoadingCnfmList()..fetchInitial(filters),
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
                               return  _promptConf(context, formStatus: formStatus);
                            },
                            builder: (_, state) {
                              final blocprovider = LoadingCnfmBlocProvider.get();
                              final form = state.extra;
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider(create: (_) => blocprovider.fetchLoadingCnfmList()),
                                  BlocProvider(create: (_)=> blocprovider.itemList()..request('')),
                                  BlocProvider(
                                    create: (_) => $sl.get<CreateLoadingCnfmCubit>()..initDetails(form),
                                  ),
                                ],
                                child: const NewLoadingConfirmation(),
                              );
                            },
                      )
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

    if (formStatus == 'Submitted') {
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