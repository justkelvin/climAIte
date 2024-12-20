// lib/main.dart
import 'package:climaite/core/constants/app_constants.dart';
import 'package:climaite/core/theme/app_theme.dart';
import 'package:climaite/data/repositories/weather_repository.dart';
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/features/weather/bloc/weather_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherApp());
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
    // Load weather data when the app starts
    _loadWeatherData();
  }

  void _loadWeatherData() {
    context.read<WeatherBloc>().add(
          LoadWeather(
            latitude: AppConstants.defaultLat,
            longitude: AppConstants.defaultLon,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return const Center(
                child: Text('Welcome to climAIte'),
              );
            }

            if (state is WeatherLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WeatherError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadWeatherData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is WeatherLoaded) {
              // Placeholder for the actual weather display
              // We'll implement the WeatherHomeScreen in the next step
              return Center(
                child: Text(
                  'Current Temperature: ${state.weather.current.temperature}°C',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }

            return const Center(
              child: Text('Something went wrong'),
            );
          },
        ),
      ),
    );
  }
}
