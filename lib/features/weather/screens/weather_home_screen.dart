// lib/features/weather/screens/weather_home_screen.dart
import 'package:climaite/core/constants/app_constants.dart';
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/features/weather/bloc/weather_state.dart';
import 'package:climaite/features/weather/screens/location_search_screen.dart';
import 'package:climaite/features/weather/screens/settings_screen.dart';
import 'package:climaite/features/weather/widgets/ai_insights_card.dart';
import 'package:climaite/features/weather/widgets/current_weather_card.dart';
import 'package:climaite/features/weather/widgets/daily_forecast_list.dart';
import 'package:climaite/features/weather/widgets/hourly_forecast_list.dart';
import 'package:climaite/services/notification_service.dart';
import 'package:climaite/shared/widgets/weather_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        // Show loading indicator when fetching data
        if (state is WeatherLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset('assets/lottie/app-loading.json', height: 400, width: 400),
            ),
          );
        }

        // Show error state
        if (state is WeatherError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WeatherBloc>().add(
                            LoadWeather(
                              latitude: AppConstants.defaultLat,
                              longitude: AppConstants.defaultLon,
                              forceRefresh: true,
                            ),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show weather data when loaded
        if (state is! WeatherLoaded) {
          return Scaffold(
            body: Center(
              child: Lottie.asset('assets/lottie/app-loading.json', height: 400, width: 400),
            ),
          );
        }

        final weather = state.weather;

        return WeatherBackground(
          weatherCode: weather.current.weathercode,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<WeatherBloc>().add(
                    LoadWeather(
                      latitude: weather.latitude,
                      longitude: weather.longitude,
                      forceRefresh: true,
                    ),
                  );
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 70,
                  floating: true,
                  pinned: true,
                  // Animated App Name
                  title: TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Text(
                          'climAIte',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black, fontSize: 24),
                        ),
                      );
                    },
                  ),
                  // flexibleSpace: FlexibleSpaceBar(
                  //   title: Text(
                  //     'climAIte',
                  //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black, fontSize: 20),
                  //   ),
                  //   centerTitle: false,
                  // ),
                  actions: [
                    if (kDebugMode)
                      IconButton(
                        icon: const Icon(Icons.notification_add),
                        onPressed: () async {
                          await NotificationService.instance.triggerTestNotification();
                        },
                        tooltip: 'Test Weather Alert',
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationSearchScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrentWeatherCard(
                          weather: weather.current,
                        ),
                        const SizedBox(height: 24),
                        AIInsightsCard(
                          weather: weather,
                          location: "Your Location",
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Hourly Forecast',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        HourlyForecastList(
                          hourly: weather.hourly,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '7-Day Forecast',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        DailyForecastList(
                          daily: weather.daily,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
