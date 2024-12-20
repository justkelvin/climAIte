// lib/services/background_service.dart
import 'package:climaite/data/repositories/weather_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;

      if (!notificationsEnabled) return true;

      final repository = WeatherRepository();
      final weather = await repository.getWeather(
        latitude: inputData?['latitude'] ?? 0.0,
        longitude: inputData?['longitude'] ?? 0.0,
      );

      await NotificationService.instance.showWeatherAlert(
        weather: weather,
        location: inputData?['location'] ?? 'Unknown Location',
      );

      return true;
    } catch (e) {
      print('Background task failed: $e');
      return false;
    }
  });
}

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerPeriodicTask({
    required double latitude,
    required double longitude,
    required String location,
  }) async {
    await Workmanager().registerPeriodicTask(
      'weatherCheck',
      'checkWeather',
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      inputData: {
        'latitude': latitude,
        'longitude': longitude,
        'location': location,
      },
    );
  }

  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }
}
