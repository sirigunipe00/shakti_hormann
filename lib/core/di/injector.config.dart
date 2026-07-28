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
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../app/data/app_repo.dart' as _i820;
import '../../app/data/app_version.dart' as _i346;
import '../../app/presentation/bloc/app_update_bloc_provider.dart' as _i117;
import '../../features/auth/data/auth_repo.dart' as _i585;
import '../../features/auth/data/auth_repo_impl.dart' as _i328;
import '../../features/auth/presentation/bloc/auth/auth_cubit.dart' as _i190;
import '../../features/auth/presentation/ui/sign_in/sign_in_cubit.dart'
    as _i947;
import '../../features/dashboard/data/dashboard_repoimpl.dart' as _i959;
import '../../features/dashboard/data/dashboardrepo.dart' as _i886;
import '../../features/dashboard/presentation/bloc_provider.dart' as _i627;
import '../../features/frame_packing/data/frame_packing_repo.dart' as _i117;
import '../../features/frame_packing/data/frame_packing_repoimpl.dart' as _i210;
import '../../features/frame_packing/presentation/bloc/bloc_provider.dart'
    as _i637;
import '../../features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart'
    as _i271;
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
import '../../features/gate_management/data/gate_management_repo.dart'
    as _i1021;
import '../../features/gate_management/data/gate_management_repoimpl.dart'
    as _i431;
import '../../features/gate_management/presentation/bloc/bloc_provider.dart'
    as _i1008;
import '../../features/gate_management/presentation/bloc/create_gate_management_cubit.dart/gate_management_cubit.dart'
    as _i326;
import '../../features/hardware_packing/data/hardware_repo.dart' as _i1009;
import '../../features/hardware_packing/data/hardware_repo_impl.dart' as _i989;
import '../../features/hardware_packing/presentation/bloc/bloc_provider.dart'
    as _i574;
import '../../features/hardware_packing/presentation/bloc/create_hardware_cubit/create_hardware_cubit.dart'
    as _i911;
import '../../features/hardware_packing/presentation/bloc/create_hardware_cubit/hardware_items_cubit.dart'
    as _i28;
import '../../features/installation/data/installation_repo.dart' as _i591;
import '../../features/installation/data/installation_repo_impl.dart' as _i814;
import '../../features/installation/presentation/bloc/bloc_provider.dart'
    as _i516;
import '../../features/installation/presentation/bloc/create_installation_entry_cubit/create_installation_entry_cubit.dart'
    as _i733;
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
import '../../features/pallet_creation/data/pallet_repo.dart' as _i1;
import '../../features/pallet_creation/data/pallet_repo_impl.dart' as _i876;
import '../../features/pallet_creation/presentation/bloc/bloc_provider.dart'
    as _i29;
import '../../features/pallet_creation/presentation/bloc/create_pallet_cubit.dart/create_pallet_cubit.dart'
    as _i925;
import '../../features/proof_of_delivery/data/pod_repo.dart' as _i25;
import '../../features/proof_of_delivery/data/pod_repo_impl.dart' as _i690;
import '../../features/proof_of_delivery/presentation/bloc/bloc_provider.dart'
    as _i110;
import '../../features/proof_of_delivery/presentation/bloc/create_pd_cubit/create_pod_cubit.dart'
    as _i971;
import '../../features/push_notifications.dart/data/notification_repo.dart'
    as _i1001;
import '../../features/push_notifications.dart/data/notification_repoimpl.dart'
    as _i601;
import '../../features/push_notifications.dart/ui/bloc/bloc_provider.dart'
    as _i185;
import '../../features/shutter_packing/data/shutter_packaging_repo.dart'
    as _i1047;
import '../../features/shutter_packing/data/shutter_packaging_repoimpl.dart'
    as _i823;
import '../../features/shutter_packing/presentation/bloc/bloc_provider.dart'
    as _i857;
import '../../features/shutter_packing/presentation/bloc/create_shutter_cubit.dart/create_shutter_cubit.dart'
    as _i1073;
import '../../features/storage_allocation/data/storage_repo.dart' as _i791;
import '../../features/storage_allocation/data/storage_repo_impl.dart' as _i99;
import '../../features/storage_allocation/presentation/bloc/bloc_provider.dart'
    as _i708;
import '../../features/storage_allocation/presentation/bloc/create_storage_cubit/create_storage_cubit.dart'
    as _i8;
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
import '../../features/vision_panel/data/vision_panel_repo.dart' as _i792;
import '../../features/vision_panel/data/vision_panel_repo_impl.dart' as _i557;
import '../../features/vision_panel/presentation/bloc/bloc_provider.dart'
    as _i576;
import '../../features/vision_panel/presentation/bloc/create_vision_panel/create_vision_panel.dart'
    as _i789;
import '../../features/zone_transfer/data/zone_repo.dart' as _i710;
import '../../features/zone_transfer/data/zone_repo_impl.dart' as _i981;
import '../../features/zone_transfer/presentation/bloc/bloc_provider.dart'
    as _i601;
import '../../features/zone_transfer/presentation/bloc/create_zone_cubit/create_zone_cubit.dart'
    as _i327;
import '../core.dart' as _i351;
import '../local_storage/key_vale_storage.dart' as _i1012;
import '../network/api_client.dart' as _i557;
import '../network/internet_check.dart' as _i402;
import '../network/network.dart' as _i855;
import '../utils/notification_usecase.dart' as _i970;
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
    await gh.singletonAsync<_i655.PackageInfo>(
      () => thirdPartyDependencies.packageInfo,
      preResolve: true,
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
    gh.lazySingleton<_i346.AppVersion>(
      () => _i346.AppVersion(gh<_i655.PackageInfo>()),
    );
    gh.factory<_i557.ApiClient>(
      () => _i557.ApiClient(
        gh<_i519.Client>(),
        gh<_i351.InternetConnectionChecker>(),
      ),
    );
    gh.lazySingleton<_i1047.ShutterPackingRepo>(
      () => _i823.ShutterPackingRepoImpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i791.StorageRepo>(
      () => _i99.StorageRepoImp(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i1009.HardWareRepo>(
      () => _i989.HardWareRepoImp(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i117.FramePackingRepo>(
      () => _i210.FramePackingRepoImpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i585.AuthRepo>(
      () => _i328.AuthRepoImpl(
        gh<_i351.ApiClient>(),
        gh<_i351.KeyValueStorage>(),
      ),
    );
    gh.lazySingleton<_i574.HardwareBlocProvider>(
      () => _i574.HardwareBlocProvider(gh<_i1009.HardWareRepo>()),
    );
    gh.factory<_i28.HardwarePackingItemsCubit>(
      () => _i28.HardwarePackingItemsCubit(gh<_i1009.HardWareRepo>()),
    );
    gh.factory<_i911.CreateHardwareCubit>(
      () => _i911.CreateHardwareCubit(gh<_i1009.HardWareRepo>()),
    );
    gh.lazySingleton<_i1.PalletRepo>(
      () => _i876.PalletRepoImpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i25.ProofOfDeliveryRepo>(
      () => _i690.PodRepoImpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i857.ShutterBlocProvider>(
      () => _i857.ShutterBlocProvider(gh<_i1047.ShutterPackingRepo>()),
    );
    gh.factory<_i1073.CreateShutterCubit>(
      () => _i1073.CreateShutterCubit(gh<_i1047.ShutterPackingRepo>()),
    );
    gh.lazySingleton<_i1021.GateManagementRepo>(
      () => _i431.GateManagementRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i66.LoadingCnfmRepo>(
      () => _i186.LoadingCnfmRepoimpl(gh<_i351.ApiClient>()),
    );
    gh.factory<_i271.CreateFrameCubit>(
      () => _i271.CreateFrameCubit(gh<_i117.FramePackingRepo>()),
    );
    gh.lazySingleton<_i637.FrameBlocProvider>(
      () => _i637.FrameBlocProvider(gh<_i117.FramePackingRepo>()),
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
    gh.lazySingleton<_i591.InstallationRepo>(
      () => _i814.InstallationRepoImpl(gh<_i351.ApiClient>()),
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
    gh.lazySingleton<_i886.Dashboardrepo>(
      () => _i959.DashboardRepoimpl(gh<_i855.ApiClient>()),
    );
    gh.factory<_i947.SignInCubit>(
      () => _i947.SignInCubit(gh<_i585.AuthRepo>()),
    );
    gh.factory<_i190.AuthCubit>(() => _i190.AuthCubit(gh<_i585.AuthRepo>()));
    gh.lazySingleton<_i1001.NotificationRepo>(
      () => _i601.NoticationRepoImpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i792.VisionPanelRepo>(
      () => _i557.VisionPanelRepoImpl(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i820.AppRepository>(
      () => _i820.AppRepository(gh<_i351.ApiClient>(), gh<_i346.AppVersion>()),
    );
    gh.factory<_i789.CreateVisionPanelCubit>(
      () => _i789.CreateVisionPanelCubit(gh<_i792.VisionPanelRepo>()),
    );
    gh.lazySingleton<_i576.VisionPanelBlocProvider>(
      () => _i576.VisionPanelBlocProvider(gh<_i792.VisionPanelRepo>()),
    );
    gh.factory<_i8.CreateStorageCubit>(
      () => _i8.CreateStorageCubit(gh<_i791.StorageRepo>()),
    );
    gh.lazySingleton<_i708.StorageBlocProvider>(
      () => _i708.StorageBlocProvider(gh<_i791.StorageRepo>()),
    );
    gh.lazySingleton<_i29.PalletBlocProvider>(
      () => _i29.PalletBlocProvider(gh<_i1.PalletRepo>()),
    );
    gh.factory<_i925.CreatePalletCubit>(
      () => _i925.CreatePalletCubit(gh<_i1.PalletRepo>()),
    );
    gh.lazySingleton<_i710.ZoneRepo>(
      () => _i981.ZoneRepoImp(gh<_i351.ApiClient>()),
    );
    gh.lazySingleton<_i516.InstallationBlocProvider>(
      () => _i516.InstallationBlocProvider(gh<_i591.InstallationRepo>()),
    );
    gh.factory<_i733.CreateInstallationEntryCubit>(
      () => _i733.CreateInstallationEntryCubit(gh<_i591.InstallationRepo>()),
    );
    gh.lazySingleton<_i1008.GateManagementBlocProvider>(
      () => _i1008.GateManagementBlocProvider(gh<_i1021.GateManagementRepo>()),
    );
    gh.factory<_i326.CreateGateManagementCubit>(
      () => _i326.CreateGateManagementCubit(gh<_i1021.GateManagementRepo>()),
    );
    gh.factory<_i92.CreateGateEntryCubit>(
      () => _i92.CreateGateEntryCubit(gh<_i936.GateEntryRepo>()),
    );
    gh.lazySingleton<_i210.GateEntryBlocProvider>(
      () => _i210.GateEntryBlocProvider(gh<_i936.GateEntryRepo>()),
    );
    gh.lazySingleton<_i601.ZoneBlocProvider>(
      () => _i601.ZoneBlocProvider(gh<_i710.ZoneRepo>()),
    );
    gh.factory<_i327.CreateZoneCubit>(
      () => _i327.CreateZoneCubit(gh<_i710.ZoneRepo>()),
    );
    gh.factory<_i297.CreateGateExitCubit>(
      () => _i297.CreateGateExitCubit(gh<_i495.GateExitRepo>()),
    );
    gh.lazySingleton<_i565.GateExitBlocProvider>(
      () => _i565.GateExitBlocProvider(gh<_i495.GateExitRepo>()),
    );
    gh.lazySingleton<_i117.AppUpdateBlocprovider>(
      () => _i117.AppUpdateBlocprovider(gh<_i820.AppRepository>()),
    );
    gh.lazySingleton<_i627.DashBoardBlocProvider>(
      () => _i627.DashBoardBlocProvider(gh<_i886.Dashboardrepo>()),
    );
    gh.factory<_i0.CreateTransportCubit>(
      () => _i0.CreateTransportCubit(gh<_i271.TransportConfrimationRepo>()),
    );
    gh.lazySingleton<_i351.TransportCnfmBlocProvider>(
      () => _i351.TransportCnfmBlocProvider(
        gh<_i271.TransportConfrimationRepo>(),
      ),
    );
    gh.lazySingleton<_i110.ProofOfDeliveryBlocProvider>(
      () => _i110.ProofOfDeliveryBlocProvider(gh<_i25.ProofOfDeliveryRepo>()),
    );
    gh.factory<_i971.CreatePodCubit>(
      () => _i971.CreatePodCubit(gh<_i25.ProofOfDeliveryRepo>()),
    );
    gh.factory<_i714.CreateLogisticCubit>(
      () => _i714.CreateLogisticCubit(gh<_i876.LogisticPlanningRepo>()),
    );
    gh.lazySingleton<_i614.LogisticPlanningBlocProvider>(
      () =>
          _i614.LogisticPlanningBlocProvider(gh<_i876.LogisticPlanningRepo>()),
    );
    gh.lazySingleton<_i185.NotificationBlocProvider>(
      () => _i185.NotificationBlocProvider(gh<_i1001.NotificationRepo>()),
    );
    gh.lazySingleton<_i970.NotificationUsecase>(
      () => _i970.NotificationUsecase(repo: gh<_i1001.NotificationRepo>()),
    );
    return this;
  }
}

class _$ThirdPartyDependencies extends _i811.ThirdPartyDependencies {}
