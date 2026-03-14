import 'package:geolocator/geolocator.dart';

/// Location Service — Gets farmer's GPS coordinates for weather & location features
///
/// Uses: geolocator package
/// Permissions required:
///   Android: ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION (in AndroidManifest.xml)
///   iOS: NSLocationWhenInUseUsageDescription (in Info.plist)
class LocationService {
  Position? _lastPosition;

  Position? get lastPosition => _lastPosition;
  double? get latitude => _lastPosition?.latitude;
  double? get longitude => _lastPosition?.longitude;

  /// Check if location services are enabled and permissions granted.
  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current position. Returns null if permissions not granted.
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;

      _lastPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
      return _lastPosition;
    } catch (e) {
      return null;
    }
  }

  /// Get distance between two coordinates in kilometers.
  double getDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Open app settings so user can enable location permission.
  Future<bool> openSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings on the device.
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
