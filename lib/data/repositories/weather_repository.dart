// lib/data/repositories/weather_repository.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  final WeatherService _weatherService;
  static const String _cachedWeatherKey = 'cached_weather_data';
  static const String _cachedTimestampKey = 'weather_cache_timestamp';
  static const Duration _cacheValidity = Duration(minutes: 30);

  WeatherRepository({WeatherService? weatherService}) : _weatherService = weatherService ?? WeatherService();

  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
    bool isDefaultLocation = true,
    bool forceRefresh = false,
  }) async {
    if (isDefaultLocation && !forceRefresh) {
      final cachedData = await _getCachedWeather();
      if (cachedData != null) {
        if (kDebugMode) {
          print('Weather data loaded from cache');
        }
        return cachedData;
      }
    }

    final weatherData = await _weatherService.getWeather(
      latitude: latitude,
      longitude: longitude,
    );

    if (kDebugMode) {
      print('Weather data loaded from API');
    }

    // await _cacheWeatherData(weatherData);
    if (isDefaultLocation) {
      if (kDebugMode) {
        print('Caching weather data for default location');
      }
      await _cacheWeatherData(weatherData);
    }

    return weatherData;
  }

  Future<WeatherData?> _getCachedWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedWeather = prefs.getString(_cachedWeatherKey);
      final timestamp = prefs.getInt(_cachedTimestampKey);

      if (cachedWeather == null || timestamp == null) {
        return null;
      }

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cachedTime) > _cacheValidity) {
        await _clearCache();
        return null;
      }

      final weatherJson = jsonDecode(cachedWeather);

      return WeatherData.fromJson(weatherJson);
    } catch (e) {
      if (kDebugMode) {
        print('Cache error: $e');
      }
      await _clearCache();
      return null;
    }
  }

  Future<void> _cacheWeatherData(WeatherData weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final weatherJson = weather.toJson();

      await prefs.setString(_cachedWeatherKey, jsonEncode(weatherJson));
      await prefs.setInt(_cachedTimestampKey, DateTime.now().millisecondsSinceEpoch);
      // Print the cached data for debugging
      if (kDebugMode) {
        print('Weather data cached: $weatherJson');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Caching error: $e');
      }
      await _clearCache();
    }
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedWeatherKey);
    await prefs.remove(_cachedTimestampKey);
  }
}
