// lib/services/notification_service.dart
import 'dart:convert';

import 'package:climaite/core/services/notification_handler.dart';
import 'package:climaite/data/models/weather_code.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationService._() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        NotificationHandler.handleNotificationTap(response.payload);
      },
    );
  }

  Future<bool> requestPermission() async {
    final androidInfo =
        await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    final iosInfo = await _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return androidInfo ?? iosInfo ?? false;
  }

  Future<void> showWeatherAlert({
    required WeatherData weather,
    required String location,
  }) async {
    final weatherCode = WeatherCode.fromCode(weather.current.weathercode);

    if (_shouldShowAlert(weather)) {
      // Create notification payload
      final payload = json.encode({
        'weather': weather.toJson(),
        'location': location,
      });

      await _notifications.show(
        0,
        'Weather Alert for $location',
        _generateAlertMessage(weather, weatherCode),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weather_alerts',
            'Weather Alerts',
            channelDescription: 'Important weather alerts and updates',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    }
  }

  Future<void> scheduleWeatherCheck({
    required WeatherData weather,
    required String location,
  }) async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 1,
    );

    // Create notification payload
    final payload = json.encode({
      'weather': weather.toJson(),
      'location': location,
    });

    await _notifications.zonedSchedule(
      1,
      'Weather Update',
      'Checking current weather conditions...',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weather_updates',
          'Weather Updates',
          channelDescription: 'Regular weather condition updates',
        ),
      ),
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  bool _shouldShowAlert(WeatherData weather) {
    // Define conditions for weather alerts
    final temp = weather.current.temperature;
    final windSpeed = weather.current.windspeed;
    final weatherCode = weather.current.weathercode;

    return temp >= 35 || // Heat alert
        temp <= 0 || // Frost alert
        windSpeed >= 50 || // Strong wind alert
        _isExtremeWeather(weatherCode); // Extreme weather conditions
  }

  bool _isExtremeWeather(int code) {
    final weatherType = WeatherCode.fromCode(code);
    return [
      WeatherCode.thunderstorm,
      WeatherCode.thunderstormWithSlightHail,
      WeatherCode.thunderstormWithHeavyHail,
      WeatherCode.rainHeavy,
      WeatherCode.snowFallHeavy,
    ].contains(weatherType);
  }

  String _generateAlertMessage(WeatherData weather, WeatherCode weatherCode) {
    final conditions = <String>[];

    if (weather.current.temperature >= 35) {
      conditions.add('Extreme heat conditions');
    }
    if (weather.current.temperature <= 0) {
      conditions.add('Freezing conditions');
    }
    if (weather.current.windspeed >= 50) {
      conditions.add('Strong winds');
    }
    if (_isExtremeWeather(weather.current.weathercode)) {
      conditions.add(weatherCode.description);
    }

    return 'Current conditions: ${conditions.join(', ')}. Take necessary precautions.';
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
