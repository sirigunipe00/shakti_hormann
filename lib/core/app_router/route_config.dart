import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/app/presentation/ui/app-profile_page.dart';
import 'package:shakti_hormann/app/presentation/ui/app_home_page.dart';
import 'package:shakti_hormann/app/presentation/ui/app_splash_scrn.dart';
import 'package:shakti_hormann/app/presentation/ui/dashboard_page.dart';
import 'package:shakti_hormann/app/presentation/widgets/app_scaffold_widget.dart';
import 'package:shakti_hormann/app/presentation/widgets/notifcations_scrn.dart';
import 'package:shakti_hormann/core/app_router/app_route.dart';
import 'package:shakti_hormann/core/consts/messages.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/core/ext/context_ext.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/create/new_gate_entry.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/ui/widgets/gate_entry_list.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate%20_exit_form.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/create/new_gate_exit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/ui/widgets/gate_exit_list.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/widgets/loading_cnfrm_list.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/ui/widgets/logistic_request_list.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/ui/widgets/transport_cnfm_list.dart';
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
                    builder: (ctxt, state) =>  NotificationListScreen(),
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.gateEntry),
                    builder: (ctxt, state) => const GateEntryListScrn(),
                    routes: [
                      GoRoute(
                        path: _getPath(AppRoute.newGateEntry),
                        onExit: (context, state) async => await _promptConf(context),
                        builder: (_, state) {
                          
                          final gateEntryForm = state.extra as GateEntryForm?;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => GateEntryBlocProvider.get().companyNameList()..request()),
                              // BlocProvider(
                              //   create: (_) => GateExitBlocProvider.get().receiverAddressList()),
                              // BlocProvider(
                              //   create: (_) => GateEntryBlocProvider.get().materialNameList()..request()),
                              // BlocProvider(
                              //   create: (_) => GateEntryBlocProvider.get().supplierNameList()..request()),
                              // BlocProvider(
                              //   create: (_) {
                              //     final bloc = GateEntryBlocProvider.get().fetchGateEntryLines();
                              //     if (gateEntryForm != null) {
                              //       bloc.request(gateEntryForm.name);
                              //     }
                              //     return bloc;
                              //   },
                              // ),
                              //  BlocProvider(
                              //   create: (_) {
                              //     final bloc = GateEntryBlocProvider.get().attachmentsList();
                              //     if (gateEntryForm != null) {
                              //       bloc.request(gateEntryForm.name);
                              //     }
                              //     return bloc;
                              //   },
                              // ),
                              // BlocProvider(
                              //   create: (_) => GateExitBlocProvider.get().receiverNameList()..request()),
                              BlocProvider(create: (_) => $sl.get<CreateGateEntryCubit>()..initDetails(gateEntryForm)),
                            ],
                            child: const NewGateEntry(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.gatexit),
                    builder: (ctxt, state) => const GateExitListScrn(),
                    routes: [
                      GoRoute(
                        onExit: (context, state) async => await _promptConf(context),
                        path: _getPath(AppRoute.newGateExit),
                        builder: (_, state) {
                        
                          final blocprovider = GateEntryBlocProvider.get();
                        
                          final form = state.extra as GateExitForm?;
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => blocprovider.companyNameList()..request()),
                  //             BlocProvider(
                  //               create: (_) => blocprovider.receiverAddressList()),
                  //             BlocProvider(
                  //               create: (_) {
                  //                 final bloc = GateExitBlocProvider.get().fetchGateExitLines();
                  //                 if (form != null) bloc.request(form.name);
                  //                 return bloc;
                  //               },
                  //             ),
                  //               BlocProvider(
                  //               create: (_) {
                  //                 final bloc = GateEntryBlocProvider.get().attachmentsList();
                  //                 if (form != null) bloc.request(form.name);
                  //                 return bloc;
                  //               },
                  //             ),
                              BlocProvider(
                                create: (_) => GateExitBlocProvider.get().salesInvoiceList()..request('')),
                              BlocProvider(
                                create: (_) => $sl.get<CreateGateExitCubit>()..initDetails(form)),
                              // BlocProvider(
                              //   create: (_) => GateEntryBlocProvider.get().materialNameList()..request()),
                            ], 
                            child: const NewGateExit(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.logisticRequest),
                    builder: (_, state) => const LogisticRequestList(),
                    routes: [
                      // GoRoute(
                      //   path: _getPath(AppRoute.newLogisticRequest),
                      //   onExit: (context, state) async => await _promptConf(context),
                      //   builder: (_, state) {
                  //         final provider = IncidentRegisterBlocProvider.get();
                  //         final incRegForm = state.extra as IncidentRegisterForm?;
                  //         return MultiBlocProvider(
                  //           providers: [
                  //             BlocProvider(
                  //               create: (_) => provider.incidentTypeList()..request()),
                  //               BlocProvider(
                  //                 create: (_) => provider.companyNameList()..request()),
                  //               BlocProvider(
                  //                 create: (_) => $sl.get<CreateIncidentRegisterCubit>()..initDetails(incRegForm),
                  //               ),
                  //             ],
                  //             child: const NewIncidentRegister(),
                  //           );
                        //   },
                        // ),
                      ],
                    ),
                    GoRoute(
                      path: _getPath(AppRoute.transportConfirmation),
                      builder: (ctxt, state) => const TransportCnfmList(),
                      routes: [
                        // GoRoute(
                        //   path: _getPath(AppRoute.transportConfirmation),
                  //         onExit: (context, state) async => await _promptConf(context),
                  //         builder: (_, state) {
                  //           final blocprovider = InviteVisitorBlocProvider.get();
                  //           final form = state.extra;
                  //           return MultiBlocProvider(
                  //             providers: [
                  //               BlocProvider(create: (_) => blocprovider.inviteVisitor()),
                  //               BlocProvider(create: (_) => blocprovider.departmentList()..request()),
                  //               BlocProvider(
                  //                 create: (_) =>$sl.get<CreateInviteVisitorCubit>()..init(form),
                  //             ),
                  //           ],
                  //           child: const NewInviteVisitor(),
                  //         );
                  //       },
                      // )
                    ],
                  ),
                  GoRoute(
                    path: _getPath(AppRoute.vehcileReporting),
                    builder: (ctxt, state) => const VehicleReportingList(),
                    routes: [
                      // GoRoute(
                      //   path: _getPath(AppRoute.vehcileReporting),
                  //       onExit: (context, state) async => await _promptConf(context),
                  //       builder: (_, state) {
                  //         final blocprovider = VisitorInOutBlocProvider.get();
                  //         final form = state.extra;
                  //         return MultiBlocProvider(
                  //           providers: [
                  //             BlocProvider(create: (_) => blocprovider.inviteVisitor()),
                  //             BlocProvider(
                  //               create: (_) => $sl.get<CreateVisitorInOutCubit>()..init(form),
                  //             ),
                  //           ],
                  //           child: const NewVisitorInOut(),
                  //         );
                  //       },
                      // )
                    ],
                  ),
                   GoRoute(
                    path: _getPath(AppRoute.loadingConfirmation),
                    builder: (ctxt, state) => const LoadingCnfrmList(),
                    routes: [
                      // GoRoute(
                      //   path: _getPath(AppRoute.newLoadingConfirmation),
                  //       onExit: (context, state) async => await _promptConf(context),
                  //       builder: (_, state) {
                  //         final blocprovider = VisitorInOutBlocProvider.get();
                  //         final form = state.extra;
                  //         return MultiBlocProvider(
                  //           providers: [
                  //             BlocProvider(create: (_) => blocprovider.inviteVisitor()),
                  //             BlocProvider(
                  //               create: (_) => $sl.get<CreateVisitorInOutCubit>()..init(form),
                  //             ),
                  //           ],
                  //           child: const NewVisitorInOut(),
                  //         );
                  //       },
                      // )
                    ],
                  )
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

  static Future<bool> _promptConf(BuildContext context) async {
    final promptConf = shouldAskForConfirmation.value;
    if (!promptConf) return true;
    return await AppDialog.askForConfirmation<bool?>(
      context,
      title: 'Are you sure',
      confirmBtnText: 'Yes',
      content: Messages.clearConfirmation,

      onTapConfirm: () {
        context.pop(true);
      },
      onTapDismiss: () {

        context.exit(false);
      },
    ) ?? false;
  }

  static String _getPath(AppRoute route) => route.path.split('/').last;
}
