// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/auth_repo.dart' as _i585;
import '../../features/auth/data/auth_repo_impl.dart' as _i328;
import '../../features/auth/presentation/bloc/auth/auth_cubit.dart' as _i190;
import '../../features/auth/presentation/ui/sign_in/sign_in_cubit.dart'
    as _i947;
import '../../features/gate_entry/data/gate_entry.repo.dart' as _i936;
import '../../features/gate_entry/data/gate_entry_repoimpl.dart' as _i403;
import '../../features/gate_entry/presentation/bloc/bloc_provider.dart'
    as _i210;
import '../../features/gate_entry/presentation/bloc/create_gate_cubit/gate_entry_cubit.dart'
    as _i92;
import '../../features/gate_exit/data/gate_exit_repo.dart' as _i495;
import '../../features/gate_exit/data/gate_exit_repo_impl.dart' as _i100;
import '../../features/gate_exit/presentation/bloc/bloc_provider.dart' as _i565;
import '../../features/gate_exit/presentation/bloc/create_gate_cubit/gate_exit_cubit.dart'
    as _i297;
import '../../features/loading_confirmation/data/loading_cnfm_repo.dart'
    as _i66;
import '../../features/loading_confirmation/data/loading_cnfm_repoimpl.dart'
    as _i186;
import '../../features/loading_confirmation/presentation/bloc/bloc_provider.dart'
    as _i811;
import '../../features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart'
    as _i345;
import '../../features/logistic_request/data/logistic_planning_repo.dart'
    as _i876;
import '../../features/logistic_request/data/logistic_planning_repoimpl.dart'
    as _i510;
import '../../features/logistic_request/presentation/bloc/bloc_provider.dart'
    as _i614;
import '../../features/logistic_request/presentation/bloc/create_lr_cubit/logistic_planning_cubit.dart'
    as _i714;
import '../../features/transport_confirmation/data/transport_confrimation_repo.dart'
    as _i271;
import '../../features/transport_confirmation/data/transport_confrimation_repoimpl.dart'
    as _i585;
import '../../features/transport_confirmation/presentation/bloc/bloc_provider.dart'
    as _i351;
import '../../features/transport_confirmation/presentation/bloc/create_transport_cubit.dart/create_transport_cubit.dart'
    as _i0;
import '../../features/vehicle_reporting/data/vehicle_reorting_repoimpl.dart'
    as _i969;
import '../../features/vehicle_reporting/data/vehicle_reporting_repo.dart'
    as _i906;
import '../../features/vehicle_reporting/presentation/bloc/bloc_provider.dart'
    as _i429;
import '../../features/vehicle_reporting/presentation/bloc/create_vr_cubit/create_vehicle_cubit.dart'
    as _i585;
import '../core.dart' as _i351;
import '../local_storage/key_vale_storage.dart' as _i1012;
import '../network/api_client.dart' as _i557;
import '../network/internet_check.dart' as _i402;
import 'injector.dart' as _i811;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyDependencies = _$ThirdPartyDependencies();
    gh.factory<DateTime>(() => thirdPartyDependencies.defaultDateTime);
    gh.singleton<_i519.Client>(() => thirdPartyDependencies.httpClient);
    gh.singleton<_i895.Connectivity>(() => thirdPartyDependencies.connectivity);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => thirdPartyDependencies.secureStorage,
    );
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => thirdPartyDependencies.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i402.InternetConnectionChecker>(
      () => _i402.InternetConnectionChecker(gh<_i895.Connectivity>()),
    );
    gh.factory<_i1012.KeyValueStorage>(
      () => _i1012.KeyValueStorage(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i557.ApiClient>(
      () => _i557.ApiClient(
        gh<_i519.Client>(),
        gh<_i351.InternetConnectionChecker>(),
      ),
    );
    gh.lazySingleton<_i585.AuthRepo>(
      () => _i328.AuthRepoImpl(
        gh<_i351.ApiClient>(),
        gh<_i351.KeyValueStorage>(),
      ),
    );
    gh.lazySingleton<_i66.LoadingCnfmRepo>(
      () => _i186.LoadingCnfmRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.factory<_i345.CreateLoadingCnfmCubit>(
      () => _i345.CreateLoadingCnfmCubit(gh<_i66.LoadingCnfmRepo>()),
    );
    gh.lazySingleton<_i811.LoadingCnfmBlocProvider>(
      () => _i811.LoadingCnfmBlocProvider(gh<_i66.LoadingCnfmRepo>()),
    );
    gh.lazySingleton<_i876.LogisticPlanningRepo>(
      () => _i510.LogisticPlanningRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i271.TransportConfrimationRepo>(
      () => _i585.TransportCnfrmRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i906.VehicleReportingRepo>(
      () => _i969.VehicleReportingRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i495.GateExitRepo>(
      () => _i100.GateExitRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i936.GateEntryRepo>(
      () => _i403.GateEntryRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i429.VehicleBlocProvider>(
      () => _i429.VehicleBlocProvider(gh<_i906.VehicleReportingRepo>()),
    );
    gh.factory<_i585.CreateVehicleCubit>(
      () => _i585.CreateVehicleCubit(gh<_i906.VehicleReportingRepo>()),
    );
    gh.factory<_i947.SignInCubit>(
      () => _i947.SignInCubit(gh<_i585.AuthRepo>()),
    );
    gh.factory<_i190.AuthCubit>(() => _i190.AuthCubit(gh<_i585.AuthRepo>()));
    gh.factory<_i92.CreateGateEntryCubit>(
      () => _i92.CreateGateEntryCubit(gh<_i936.GateEntryRepo>()),
    );
    gh.lazySingleton<_i210.GateEntryBlocProvider>(
      () => _i210.GateEntryBlocProvider(gh<_i936.GateEntryRepo>()),
    );
    gh.factory<_i297.CreateGateExitCubit>(
      () => _i297.CreateGateExitCubit(gh<_i495.GateExitRepo>()),
    );
    gh.lazySingleton<_i565.GateExitBlocProvider>(
      () => _i565.GateExitBlocProvider(gh<_i495.GateExitRepo>()),
    );
    gh.factory<_i0.CreateTransportCubit>(
      () => _i0.CreateTransportCubit(gh<_i271.TransportConfrimationRepo>()),
    );
    gh.lazySingleton<_i351.TransportCnfmBlocProvider>(
      () => _i351.TransportCnfmBlocProvider(
        gh<_i271.TransportConfrimationRepo>(),
      ),
    );
    gh.factory<_i714.CreateLogisticCubit>(
      () => _i714.CreateLogisticCubit(gh<_i876.LogisticPlanningRepo>()),
    );
    gh.lazySingleton<_i614.LogisticPlanningBlocProvider>(
      () =>
          _i614.LogisticPlanningBlocProvider(gh<_i876.LogisticPlanningRepo>()),
    );
    return this;
  }
}

class _$ThirdPartyDependencies extends _i811.ThirdPartyDependencies {}
