// lib/core/services/notification_handler.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../features/weather/screens/detailed_weather_screen.dart';
import '../services/navigation_service.dart';
import '../../data/models/weather_model.dart';

class NotificationHandler {
  static Future<void> handleNotificationTap(String? payload) async {
    if (payload == null) return;

    try {
      final data = json.decode(payload);
      final weather = WeatherData.fromJson(data['weather']);
      final location = data['location'] as String;

      NavigationService.navigator.push(
        MaterialPageRoute(
          builder: (context) => DetailedWeatherScreen(
            weather: weather,
            location: location,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }
}
