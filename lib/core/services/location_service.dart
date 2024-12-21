// lib/core/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _latKey = 'last_known_latitude';
  static const String _lonKey = 'last_known_longitude';

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      await _saveLastKnownLocation(position);
      return position;
    } catch (e) {
      return null;
    }
  }

  Future<Position?> getLastKnownLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_latKey);
    final lon = prefs.getDouble(_lonKey);

    if (lat != null && lon != null) {
      return Position(
        latitude: lat,
        longitude: lon,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
    return null;
  }

  Future<void> _saveLastKnownLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, position.latitude);
    await prefs.setDouble(_lonKey, position.longitude);
  }
}
