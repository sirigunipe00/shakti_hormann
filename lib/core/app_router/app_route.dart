import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class _AppRoutePaths {
  static const initial = '/';
  static const login = '/login';
  static const home = '/home';
  static const account = '/account';
  static const dashboard = '/dashboard';
  static const gateEntry='/home/gateentry';
  static const gateExit='/home/gateexit';
  static const newGateEntry='/home/gateentry/newGateEntry';
  static const newGateExit='/home/gateexit/newGateExit';
  static const notifications='/home/notifications';
  static const logisticRequest='/home/logisticrRequest';
  static const newLogisticRequest='/home/logisticrRequest/newLogisticRequest';
  static const transportConfirmation='/home/transportConfirmation';
  static const newTarnsportCnfrm='/home/transportConfirmation/newTarnsportCnfrm';
  static const vehcileReporting='/home/vehiclereporting';
  static const newVehiclereporting='/home/vehiclereporting/newvehiclereporting';
  static const loadingConfirmation='/home/loadingConfirmation';
  static const newloadingConfirmation='/home/loadingConfirmation/newLoadingConfirmation';
  static const proofOfDelivery ='/home/proofOfDelivery';
  static const newproofOfDelivery='/home/proofOfDelivery/newproofOfDelivery';
  static const gateManagement = '/home/gatemanagement';
  static const newGateManagement = '/home/gatemanagement/newGateManagement';
  static const storageAllocation = '/home/storageallocation';
  static const newStorageAllocation = '/home/storageallocation/newStorageAllocation';
  static const zoneTransfer = '/home/zonetransfer';
  static const newZoneTransfer = '/home/zonetransfer/newZoneTransfer';  
  static const hardwarePackaging = '/home/hardwarepackaging';
  static const newHardwarePackaging = '/home/hardwarepackaging/newHardwarePackaging';
  static const shutterPackaging = '/home/shutterPackaging';
  static const newshutterPackaging = '/home/shutterPackaging/newshutterPackaging';
  static const framePackaging = '/home/framePackaging';
  static const newframePackaging = '/home/framePackaging/newframePackaging';
}

enum AppRoute {
  initial(_AppRoutePaths.initial),
  login(_AppRoutePaths.login),
  home(_AppRoutePaths.home),
  dashboard(_AppRoutePaths.dashboard),
  gateEntry(_AppRoutePaths.gateEntry),
  gateManagement(_AppRoutePaths.gateManagement),
  newGateManagement(_AppRoutePaths.newGateManagement),
  gatexit(_AppRoutePaths.gateExit),
  newGateEntry(_AppRoutePaths.newGateEntry),
  newGateExit(_AppRoutePaths.newGateExit),
  newLogisticRequest(_AppRoutePaths.newLogisticRequest),
  newLoadingConfirmation(_AppRoutePaths.newloadingConfirmation),
  newTarnsportCnfrm(_AppRoutePaths.newTarnsportCnfrm),
  newVehiclereporting(_AppRoutePaths.newVehiclereporting),
  newproofOfDelivery(_AppRoutePaths.newproofOfDelivery),
  account(_AppRoutePaths.account),
  logisticRequest(_AppRoutePaths.logisticRequest),
  transportConfirmation(_AppRoutePaths.transportConfirmation),
  vehcileReporting(_AppRoutePaths.vehcileReporting),
  loadingConfirmation(_AppRoutePaths.loadingConfirmation),
  proofOfDelivery(_AppRoutePaths.proofOfDelivery), 
  notifications(_AppRoutePaths.notifications),
  storageAllocation(_AppRoutePaths.storageAllocation),
  newStorageAllocation(_AppRoutePaths.newStorageAllocation),
  zoneTransfer(_AppRoutePaths.zoneTransfer),
  newZoneTransfer(_AppRoutePaths.newZoneTransfer),
  hardwarePackaging(_AppRoutePaths.hardwarePackaging),
  newHardwarePackaging(_AppRoutePaths.newHardwarePackaging),
  shutterPackaging(_AppRoutePaths.shutterPackaging),
  newshutterPackaging(_AppRoutePaths.newshutterPackaging),
  framePackaging(_AppRoutePaths.framePackaging),
  newframePackaging(_AppRoutePaths.newframePackaging);



  const AppRoute(this.path);
  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go(BuildContext context, {Object? extra}) {
    context.go(path, extra: extra);
  }

  void goNamed(BuildContext context, {Object? extra}) {
    context.goNamed(path, extra: extra);
  }

  Future<T?> push<T>(BuildContext context, {Object? extra}) async {
    return await context.push(path, extra: extra);
  }
}
