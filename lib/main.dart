// lib/main.dart
import 'package:climaite/core/constants/app_constants.dart';
import 'package:climaite/core/providers/settings_provider.dart';
import 'package:climaite/core/theme/app_theme.dart';
import 'package:climaite/data/repositories/weather_repository.dart';
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/features/weather/screens/weather_home_screen.dart';
import 'package:climaite/services/background_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // Load .env file before app starts

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
  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  void _loadWeatherData() {
    context.read<WeatherBloc>().add(
          const LoadWeather(
            latitude: AppConstants.defaultLat,
            longitude: AppConstants.defaultLon,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return const WeatherHomeScreen(); // Use the WeatherHomeScreen here
  }
}
