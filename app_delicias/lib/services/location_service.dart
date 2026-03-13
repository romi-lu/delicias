import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<void> ensurePermissions() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw const LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const PermissionDeniedException('Permiso de ubicación denegado');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException('Permiso de ubicación denegado permanentemente');
    }
  }

  Future<Position?> lastKnown() => Geolocator.getLastKnownPosition();

  Future<Position> current({LocationAccuracy accuracy = LocationAccuracy.high}) {
    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: accuracy),
    );
  }

  Stream<Position> stream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilterMeters = 20,
  }) {
    final settings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
    );

    return Geolocator.getPositionStream(locationSettings: settings);
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}

