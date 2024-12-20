// lib/features/weather/screens/weather_home_screen.dart
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/features/weather/bloc/weather_state.dart';
import 'package:climaite/features/weather/widgets/current_weather_card.dart';
import 'package:climaite/features/weather/widgets/daily_forecast_list.dart';
import 'package:climaite/features/weather/widgets/hourly_forecast_list.dart';
import 'package:climaite/shared/widgets/weather_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is! WeatherLoaded) {
          return const SizedBox.shrink();
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
                    ),
                  );
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 80,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'climAIte',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    centerTitle: true,
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        // TODO: Implement settings navigation
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
