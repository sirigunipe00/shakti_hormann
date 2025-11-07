import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shakti_hormann/core/core.dart';
import 'dart:math';

import 'package:shakti_hormann/core/cubit/base/base_cubit.dart';

enum GeoLocationState { initial, loading, success, failure }

class LocationDistanceCubit extends AppBaseCubit<LocationDistanceState> {
  LocationDistanceCubit() : super(LocationDistanceState.initial());

    Timer? timer;
  void getDistance([String? latitude, String? longitude]) async {
    try {
      final targetLatitude = double.tryParse(latitude.valueOrEmpty);
      final targetLongitude = double.tryParse(longitude.valueOrEmpty);
      if (targetLatitude.isNull || targetLongitude.isNull) return;
      _updateLocation(targetLatitude, targetLongitude);
      timer = Timer.periodic(const Duration(seconds: 15),
          (Timer t) => _updateLocation(targetLatitude, targetLongitude));
    } on Exception catch (e, st) {
      $logger.error('[LocationDistanceCubit]', e, st);
    }
  }

  void _updateLocation(double? latitude, double? longitude) async {
    try {
      emitSafeState(LocationDistanceState.loading());
      if (latitude.isNull || longitude.isNull) return;
      final currentPosition = await Geolocator.getCurrentPosition();
      // final startLatitude = kDebugMode ? double.tryParse('12.4139') : currentPosition.latitude;
      // final startLongitude = kDebugMode ? double.tryParse('76.6888') : currentPosition.longitude;
      final startLatitude = currentPosition.latitude;
      final startLongitude = currentPosition.longitude;

      final bearing = haversine(
        startLatitude,
        startLongitude,
        latitude!,
        longitude!,
      );

      final distanceMeters = bearing * 1000;
      // if (distanceMeters < 1000) {
      //   final processedState = LocationDistanceState.processed(
      //       '${distanceMeters.toStringAsFixed(2)} m');
      //   emitSafeState(processedState);
      // } else {
      //   final distanceKm = distanceMeters / 1000;
      //   final processedState = LocationDistanceState.processed(
      //       '${distanceKm.toStringAsFixed(2)} Km');
      //   emitSafeState(processedState);
      // }
    } on Exception catch (e, st) {
      $logger.error('[LocationDistanceCubit]', e, st);
    }
  }

  Future<Position> getCurrentLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    print('currentPosition...:$currentPosition');
    return currentPosition;
  }

Future<void> enableLocation() async {
  try {
    emitSafeState(LocationDistanceState.loading());

    // ✅ 1. Check if location service (GPS) is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 🚫 GPS turned off → ask user to enable
      emitSafeState(
        LocationDistanceState.failure('Location service is disabled'),
      );

      // Optional: open settings automatically
      await Geolocator.openLocationSettings();
      return;
    }

    // ✅ 2. Check app permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emitSafeState(
          LocationDistanceState.failure('Location permission denied'),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emitSafeState(
        LocationDistanceState.failure('Location permission permanently denied'),
      );
      await Geolocator.openAppSettings();
      return;
    }

    // ✅ 3. Now it’s safe to get position
    final currentPosition = await Geolocator.getCurrentPosition();
    emitSafeState(LocationDistanceState.processed(currentPosition));
  } catch (e, st) {
    $logger.error('[LocationDistanceCubit.enableLocation]', e, st);
    emitSafeState(LocationDistanceState.failure(e.toString()));
  }
}


  static Future<String> getAddressStr(
    double? latitude,
    double? longitude,
  ) async {
    if (latitude == null || longitude == null) return '';
    final placemarks = await GeocodingPlatform.instance
        ?.placemarkFromCoordinates(latitude, longitude);
    final place = placemarks?.firstOrNull;
    return StringUtils.readPlacemark(place);
  }

  double haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void emitLoading() => emitSafeState(LocationDistanceState.loading());
  void clearLoading() => emitSafeState(LocationDistanceState.initial());

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}

class LocationDistanceState extends Equatable {
  const LocationDistanceState({
    required this.state,
    this.distance,
    this.failure,
  });

  factory LocationDistanceState.initial() =>
      const LocationDistanceState(state: GeoLocationState.initial);
  factory LocationDistanceState.loading() =>
      const LocationDistanceState(state: GeoLocationState.loading);
  factory LocationDistanceState.failure(String? error) =>
      LocationDistanceState(state: GeoLocationState.failure, failure: error);

  factory LocationDistanceState.processed(Position? distance) =>
      LocationDistanceState(
        state: GeoLocationState.success,
        distance: distance,
      );

  final GeoLocationState state;
  final Position? distance;
  final String? failure;

  @override
  List<Object?> get props => [distance, state, failure];
}

extension GeoLocationStateApi on LocationDistanceState {
  bool get isSuccess => state == GeoLocationState.success;
  bool get isLoading => state == GeoLocationState.loading;
  bool get isInitial => state == GeoLocationState.initial;
  bool get isNotFailure => state != GeoLocationState.failure;

  // bool get isWithInRange => _validateRange();
  // bool _validateRange() {
  //   // if(kDebugMode) return true;
  //   if (isSuccess) {
  //     final distanceStr = distance;

  //     final regex = RegExp(r'\d+(\.\d+)?');
  //     final match = regex.stringMatch(distanceStr);
  //     if (match != null) {
  //       double range = double.parse(match);

  //       if (distanceStr.contains('Km')) {
  //         range *= 1000;
  //       }

  //       return (range < 300);
  //     }
  //     return false;
  //   }
  //   return false;
  // }
}
