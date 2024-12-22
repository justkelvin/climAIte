// lib/services/notification_service.dart
import 'dart:convert';

import 'package:climaite/core/services/notification_handler.dart';
import 'package:climaite/data/models/weather_code.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:flutter/material.dart';
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

  // Add this method to your NotificationService class
  Future<void> triggerTestNotification() async {
    // Create a test weather data
    final testWeather = WeatherData(
      current: Current(
        temperature: 36.0, // High temperature to trigger alert
        windspeed: 55.0, // High wind speed to trigger alert
        winddirection: 180,
        weathercode: 95, // Thunderstorm code to trigger alert
        time: DateTime.now().toIso8601String(),
        interval: 900,
      ),
      daily: Daily(
        time: ['2024-12-22'],
        weathercode: [95],
        temperatureMax: [38.0],
        temperatureMin: [25.0],
        precipitationSum: [10.0],
      ),
      hourly: Hourly(
        time: ['2024-12-22T14:00'],
        temperature: [36.0],
        humidity: [70],
        windspeed: [55.0],
        weathercode: [95],
      ),
      latitude: -1.2921,
      longitude: 36.8219,
      timezone: 'Africa/Nairobi',
      generationtime_ms: 0.1,
      utc_offset_seconds: 10800,
      timezone_abbreviation: 'EAT',
      elevation: 1668.0,
    );

    // Show the weather alert
    await showWeatherAlert(
      weather: testWeather,
      location: 'Test Location',
    );

    // Also schedule a weather check
    await scheduleWeatherCheck(
      weather: testWeather,
      location: 'Test Location',
    );
  }

  Future<void> scheduleWeatherBriefings({
    required WeatherData weather,
    required String location,
  }) async {
    // Cancel existing briefings before scheduling new ones
    await _notifications.cancel(100); // Morning briefing ID
    await _notifications.cancel(101); // Evening briefing ID

    // ignore: unused_local_variable
    final now = tz.TZDateTime.now(tz.local);

    // Schedule morning briefing (7:00 AM)
    final morning = _getNextInstanceOfTime(7, 0); // 7:00 AM
    await _scheduleMorningBriefing(morning, weather, location);

    // Schedule evening briefing (8:00 PM)
    final evening = _getNextInstanceOfTime(20, 0); // 8:00 PM
    await _scheduleEveningBriefing(evening, weather, location);
  }

  tz.TZDateTime _getNextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _scheduleMorningBriefing(
    tz.TZDateTime scheduledDate,
    WeatherData weather,
    String location,
  ) async {
    final temp = weather.current.temperature;
    final weatherCode = WeatherCode.fromCode(weather.current.weathercode);

    final payload = json.encode({
      'weather': weather.toJson(),
      'location': location,
    });

    try {
      await _notifications.zonedSchedule(
        100, // Unique ID for morning briefing
        'Good Morning! Weather Update for $location',
        'Today will be ${weatherCode.description} with ${temp.round()}°C. ${_generateDailySummary(weather)}',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_weather',
            'Daily Weather Updates',
            channelDescription: 'Morning and evening weather briefings',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(
              'Today will be ${weatherCode.description} with ${temp.round()}°C. ${_generateDailySummary(weather)}',
            ),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling morning briefing: $e');
    }
  }

  Future<void> _scheduleEveningBriefing(
    tz.TZDateTime scheduledDate,
    WeatherData weather,
    String location,
  ) async {
    // Get tomorrow's weather from daily forecast
    final tomorrowMax = weather.daily.temperatureMax[1];
    final tomorrowMin = weather.daily.temperatureMin[1];
    final tomorrowCode = WeatherCode.fromCode(weather.daily.weathercode[1]);

    final payload = json.encode({
      'weather': weather.toJson(),
      'location': location,
    });

    try {
      await _notifications.zonedSchedule(
        101, // Unique ID for evening briefing
        'Evening Forecast for Tomorrow in $location',
        'Tomorrow: ${tomorrowCode.description}\nHigh: ${tomorrowMax.round()}°C, Low: ${tomorrowMin.round()}°C\n${_generateTomorrowSummary(weather)}',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_weather',
            'Daily Weather Updates',
            channelDescription: 'Morning and evening weather briefings',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(
              'Tomorrow: ${tomorrowCode.description}\nHigh: ${tomorrowMax.round()}°C, Low: ${tomorrowMin.round()}°C\n${_generateTomorrowSummary(weather)}',
            ),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling evening briefing: $e');
    }
  }

  String _generateDailySummary(WeatherData weather) {
    final conditions = <String>[];

    // Add precipitation info if available
    if (weather.daily.precipitationSum[0] > 0) {
      conditions.add('Expected rainfall: ${weather.daily.precipitationSum[0].round()}mm');
    }

    // Add temperature range
    conditions.add('High: ${weather.daily.temperatureMax[0].round()}°C, ' + 'Low: ${weather.daily.temperatureMin[0].round()}°C');

    // Add wind info if significant
    if (weather.current.windspeed > 20) {
      conditions.add('Windy conditions: ${weather.current.windspeed.round()} km/h');
    }

    return conditions.join('\n');
  }

  String _generateTomorrowSummary(WeatherData weather) {
    final conditions = <String>[];

    // Add precipitation info if available
    if (weather.daily.precipitationSum[1] > 0) {
      conditions.add('Expected rainfall: ${weather.daily.precipitationSum[1].round()}mm');
    }

    // Add significant weather warnings
    final tomorrowCode = WeatherCode.fromCode(weather.daily.weathercode[1]);
    if (_isExtremeWeather(weather.daily.weathercode[1])) {
      conditions.add('Warning: ${tomorrowCode.description} expected');
    }

    return conditions.join('\n');
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
