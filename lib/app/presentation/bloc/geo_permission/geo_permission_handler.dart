import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/app/presentation/bloc/geo_permission/geo_permission_state.dart';
import 'package:shakti_hormann/core/cubit/base/base_cubit.dart';

class GeoPermissionHandler extends AppBaseCubit<GeoPermissionState> {
  GeoPermissionHandler() : super(const Initial());

  int count = 0;
  void checkPermission() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      emitSafeState(const Initial());
      final isServEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServEnabled) await Geolocator.requestPermission();

      final permissionStatus = await Geolocator.checkPermission();
      if(permissionStatus != LocationPermission.whileInUse) {
        if (permissionStatus == LocationPermission.denied) {
          count++;
          if(count > 2) {
            return emitSafeState(const GeoLocationDeniedForever());
          }
          return emitSafeState(const GeoLocationDenied());
        }
        if (permissionStatus == LocationPermission.deniedForever) {
          return emitSafeState(const GeoLocationDeniedForever());
        }
      }
      const location = Permission.location;
      final locationStatus = await location.status;

      if(locationStatus == PermissionStatus.denied) {
        return emitSafeState(const LocationPermissionDenied(location));
      } else if(locationStatus == PermissionStatus.restricted) {
        return emitSafeState(const LocationPermissionDenied(location));
      } else if(locationStatus == PermissionStatus.permanentlyDenied) {
        return emitSafeState(const LocationPermissionPermDenied(location));
      }

      final currentPosition = await Geolocator.getCurrentPosition();
      final placemarks = await GeocodingPlatform.instance?.placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      
      emitSafeState(LocationPermissionGranted(placemarks?.firstOrNull));
    } on Exception catch (e, st) {
      $logger.error('[GeoPermissionHandler]', e, st);
    }
  }
}
