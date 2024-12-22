// lib/features/weather/screens/settings_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:climaite/core/constants/app_constants.dart';
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/services/background_service.dart';
import 'package:climaite/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _tempUnitKey = 'temperature_unit';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _aiInsightsKey = 'ai_insights_enabled';

  late SharedPreferences _prefs;
  bool _isLoading = true;

  // Settings state
  bool _isCelsius = true;
  bool _notificationsEnabled = false;
  bool _aiInsightsEnabled = true;
  bool _dailyBriefingsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = _prefs.getBool(_tempUnitKey) ?? true;
      _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? false;
      _aiInsightsEnabled = _prefs.getBool(_aiInsightsKey) ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool(_tempUnitKey, _isCelsius);
    await _prefs.setBool(_notificationsKey, _notificationsEnabled);
    await _prefs.setBool(_aiInsightsKey, _aiInsightsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const _SettingsHeader(title: 'General'),
          SwitchListTile(
            title: const Text('Temperature Unit'),
            subtitle: Text(_isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)'),
            value: _isCelsius,
            onChanged: (value) {
              setState(() {
                _isCelsius = value;
                _saveSettings();
              });
            },
          ),
          const Divider(),
          const _SettingsHeader(title: 'Notifications'),
          SwitchListTile(
            title: const Text('Weather Alerts'),
            subtitle: const Text('Get notified about severe weather conditions'),
            value: _notificationsEnabled,
            onChanged: (value) async {
              if (value) {
                final granted = await NotificationService.instance.requestPermission();
                if (!granted) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification permission denied'),
                      ),
                    );
                  }
                  return;
                }
              }

              setState(() {
                _notificationsEnabled = value;
              });
              await _saveSettings();

              if (value) {
                // Start background task
                await BackgroundService.registerPeriodicTask(
                  latitude: AppConstants.defaultLat,
                  longitude: AppConstants.defaultLon,
                  location: AppConstants.defaultCity,
                );
              } else {
                // Cancel background task
                await BackgroundService.cancelAllTasks();
              }
            },
          ),
          SwitchListTile(
            title: const Text('Daily Weather Briefings'),
            subtitle: const Text('Get weather updates at 7 AM and 8 PM'),
            value: _dailyBriefingsEnabled,
            onChanged: (value) async {
              if (value) {
                final granted = await NotificationService.instance.requestPermission();
                if (!granted) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification permission denied'),
                      ),
                    );
                  }
                  return;
                }

                // Trigger immediate scheduling of next briefings
                context.read<WeatherBloc>().add(
                      const LoadWeather(
                        latitude: AppConstants.defaultLat,
                        longitude: AppConstants.defaultLon,
                      ),
                    );
              }

              setState(() {
                _dailyBriefingsEnabled = value;
              });
              await _prefs.setBool('daily_briefings_enabled', value);
            },
          ),
          const Divider(),
          const _SettingsHeader(title: 'AI Features'),
          SwitchListTile(
            title: const Text('AI Weather Insights'),
            subtitle: const Text('Get personalized weather analysis'),
            value: _aiInsightsEnabled,
            onChanged: (value) {
              setState(() {
                _aiInsightsEnabled = value;
                _saveSettings();
              });
            },
          ),
          const _SettingsHeader(title: 'About'),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Weather AI'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weather AI App v1.0.0'),
            SizedBox(height: 8),
            Text('Powered by:'),
            Text('• OpenMeteo API'),
            Text('• Google Gemini AI'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
