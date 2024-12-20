// lib/core/providers/settings_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  static const String _tempUnitKey = 'temperature_unit';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _aiInsightsKey = 'ai_insights_enabled';

  bool _isCelsius = true;
  bool _notificationsEnabled = false;
  bool _aiInsightsEnabled = true;
  bool _isInitialized = false;

  bool get isCelsius => _isCelsius;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get aiInsightsEnabled => _aiInsightsEnabled;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadSettings() {
    _isCelsius = _prefs.getBool(_tempUnitKey) ?? true;
    _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? false;
    _aiInsightsEnabled = _prefs.getBool(_aiInsightsKey) ?? true;
  }

  Future<void> setTemperatureUnit(bool isCelsius) async {
    _isCelsius = isCelsius;
    await _prefs.setBool(_tempUnitKey, isCelsius);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs.setBool(_notificationsKey, enabled);
    notifyListeners();
  }

  Future<void> setAiInsightsEnabled(bool enabled) async {
    _aiInsightsEnabled = enabled;
    await _prefs.setBool(_aiInsightsKey, enabled);
    notifyListeners();
  }

  double convertTemperature(double temperature) {
    if (_isCelsius) return temperature;
    return (temperature * 9 / 5) + 32;
  }

  String get temperatureUnit => _isCelsius ? '°C' : '°F';
}
