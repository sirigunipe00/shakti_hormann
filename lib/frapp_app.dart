import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:shakti_hormann/features/auth/presentation/ui/sign_in/sign_in_cubit.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_entry/presentation/bloc/gate_entry_filter_cubit.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/gate_exit/presentation/bloc/gate_exit_filter_cubit.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/logistic_request/presentation/bloc/logistic_planning_filter_cubit.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/transport_confirmation/presentation/bloc/transport_filter_cubit.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/vehicle_reporting/presentation/bloc/vehicle_reporting_filtercubit.dart';
import 'package:shakti_hormann/styles/material_theme.dart';

class ShaktiHormann extends StatelessWidget {
  const ShaktiHormann({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => $sl.get<AuthCubit>()..authCheckRequested()),
        BlocProvider(create: (_) => $sl.get<SignInCubit>()),
        BlocProvider(create: (_) => GateEntryFilterCubit()),
        BlocProvider(create: (_)=> GateExitFilterCubit()),
        BlocProvider(create: (_)=> LogisticPlanningFilterCubit()),
        BlocProvider(create: (_)=> TransportFilterCubit()),
        BlocProvider(create: (_)=> VehicleReportingFilterCubit()),


        BlocProvider(
          create: (_) => GateEntryBlocProvider.get().fetchGateEntries(),
        ),
         BlocProvider(
          create: (_) => GateExitBlocProvider.get().fetchGateExit(),
        ),
        BlocProvider(
          create: (_) => LogisticPlanningBlocProvider.get().fetchLogistics(),
        ),
         BlocProvider(
          create: (_) => TransportCnfmBlocProvider.get().fetchTransport(),
        ),
         BlocProvider(
          create: (_) => VehicleBlocProvider.get().fetchVehicle(),
        ),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (_, state) {
          final routerCtxt = AppRouterConfig.parentNavigatorKey.currentContext;
          if (routerCtxt == null) return;
          state.maybeWhen(
            authenticated: () {
              final filters = Pair(StringUtils.docStatusInt('Draft'), null);
              final filter =Pair(StringUtils.docStatuslogistic('Draft'), null);
              routerCtxt.cubit<GateEntriesCubit>().fetchInitial(filters);
              routerCtxt.cubit<GateExitCubit>().fetchInitial(filters);
              routerCtxt.cubit<LogisticPlanningCubit>().fetchInitial(filter);
              routerCtxt.cubit<TransportCubit>().fetchInitial(filter);
              routerCtxt.cubit<VehicleReportingCubit>().fetchInitial(filters);


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
        builder: (_, state) {
           return MaterialApp.router(
            title: 'Shakti Hormann',
            theme: AppMaterialTheme.lightTheme,
            darkTheme: AppMaterialTheme.lightTheme,
            routerConfig: AppRouterConfig.router,
            debugShowCheckedModeBanner: false,
          );
          
        },
      ),
    );
  }
}
