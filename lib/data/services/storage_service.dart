import 'dart:convert';
import 'package:climaite/data/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _timestampKey = 'weather_timestamp';
  static const Duration _cacheValidity = Duration(minutes: 30); // Cache for 30 minutes

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> cacheWeatherData(WeatherData weather) async {
    await _prefs.setString(_weatherKey, jsonEncode(weather.toJson()));
    await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherData?> getCachedWeather() async {
    final cachedData = _prefs.getString(_weatherKey);
    final timestamp = _prefs.getInt(_timestampKey);

    if (cachedData == null || timestamp == null) {
      return null;
    }

    // Check if cache is still valid
    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cachedTime) > _cacheValidity) {
      return null;
    }

    try {
      return WeatherData.fromJson(jsonDecode(cachedData));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearCache() async {
    await _prefs.remove(_weatherKey);
    await _prefs.remove(_timestampKey);
  }
}
