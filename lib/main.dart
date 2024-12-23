// lib/main.dart
import 'package:climaite/core/constants/app_constants.dart';
import 'package:climaite/core/providers/settings_provider.dart';
import 'package:climaite/core/services/location_service.dart';
import 'package:climaite/core/services/navigation_service.dart';
import 'package:climaite/core/theme/app_theme.dart';
import 'package:climaite/data/repositories/weather_repository.dart';
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/features/weather/screens/weather_home_screen.dart';
import 'package:climaite/services/background_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await BackgroundService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..initialize(),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(
            weatherRepository: WeatherRepository(),
          ),
        ),
      ],
      child: WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(
            weatherRepository: WeatherRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        title: 'climAIte',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: const WeatherHomePage(),
      ),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    // Try to get current location
    final currentLocation = await _locationService.getCurrentLocation();

    // log the location details
    if (kDebugMode) {
      print('Location: $currentLocation');
    }

    if (currentLocation != null) {
      if (mounted) {
        _loadWeatherData(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
        );
      }
      return;
    }

    // Try to get last known location
    final lastKnownLocation = await _locationService.getLastKnownLocation();

    if (lastKnownLocation != null) {
      if (mounted) {
        _loadWeatherData(
          latitude: lastKnownLocation.latitude,
          longitude: lastKnownLocation.longitude,
        );
      }
      return;
    }

    // Use default location as fallback
    if (mounted) {
      _loadWeatherData(
        latitude: AppConstants.defaultLat,
        longitude: AppConstants.defaultLon,
      );
    }
  }

  void _loadWeatherData({
    required double latitude,
    required double longitude,
  }) {
    context.read<WeatherBloc>().add(
          LoadWeather(
            latitude: latitude,
            longitude: longitude,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return const WeatherHomeScreen();
  }
}
