// lib/features/weather/screens/detailed_weather_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/weather_code.dart';
import '../../../core/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class DetailedWeatherScreen extends StatelessWidget {
  final WeatherData weather;
  final String location;

  const DetailedWeatherScreen({
    super.key,
    required this.weather,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _CurrentDetailsCard(
                    weather: weather.current,
                    location: location,
                  ),
                  const SizedBox(height: 16),
                  _HourlyDetailsList(hourly: weather.hourly),
                  const SizedBox(height: 16),
                  _WeeklyForecastCard(daily: weather.daily),
                  const SizedBox(height: 16),
                  _WeatherStatsCard(
                    current: weather.current,
                    hourly: weather.hourly,
                  ),
                ],
              ).animate().fadeIn(
                    duration: const Duration(milliseconds: 500),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          location,
          style: const TextStyle(color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ],
    );
  }
}

class _CurrentDetailsCard extends StatelessWidget {
  final Current weather;
  final String location;

  const _CurrentDetailsCard({
    required this.weather,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final weatherCode = WeatherCode.fromCode(weather.weathercode);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${settings.convertTemperature(weather.temperature).round()}${settings.temperatureUnit}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              weatherCode.description,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherDetail(
                  icon: WeatherIcons.strong_wind,
                  value: '${weather.windspeed.round()} km/h',
                  label: 'Wind',
                ),
                _WeatherDetail(
                  icon: WeatherIcons.wind_direction,
                  value: '${weather.winddirection}°',
                  label: 'Direction',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HourlyDetailsList extends StatelessWidget {
  final Hourly hourly;

  const _HourlyDetailsList({required this.hourly});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          final time = DateTime.parse(hourly.time[index]);
          final temp = hourly.temperature[index];
          final humidity = hourly.humidity[index];

          return Card(
            margin: const EdgeInsets.only(right: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    DateFormat('HH:mm').format(time),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Icon(
                    _getWeatherIcon(hourly.weathercode[index]),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    '${settings.convertTemperature(temp).round()}${settings.temperatureUnit}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${humidity.round()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getWeatherIcon(int code) {
    final weatherType = WeatherCode.fromCode(code);
    switch (weatherType) {
      case WeatherCode.clearSky:
        return WeatherIcons.day_sunny;
      case WeatherCode.partlyCloudy:
        return WeatherIcons.day_cloudy;
      case WeatherCode.overcast:
        return WeatherIcons.cloudy;
      default:
        return WeatherIcons.day_sunny;
    }
  }
}

class _WeeklyForecastCard extends StatelessWidget {
  final Daily daily;

  const _WeeklyForecastCard({required this.daily});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7-Day Forecast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...List.generate(
              7,
              (index) {
                final date = DateTime.parse(daily.time[index]);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(DateFormat('EEEE').format(date)),
                      ),
                      Icon(_getWeatherIcon(daily.weathercode[index])),
                      Text(
                        '${settings.convertTemperature(daily.temperatureMax[index]).round()}°',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${settings.convertTemperature(daily.temperatureMin[index]).round()}°',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(int code) {
    final weatherType = WeatherCode.fromCode(code);
    switch (weatherType) {
      case WeatherCode.clearSky:
        return WeatherIcons.day_sunny;
      case WeatherCode.partlyCloudy:
        return WeatherIcons.day_cloudy;
      case WeatherCode.overcast:
        return WeatherIcons.cloudy;
      default:
        return WeatherIcons.day_sunny;
    }
  }
}

class _WeatherStatsCard extends StatelessWidget {
  final Current current;
  final Hourly hourly;

  const _WeatherStatsCard({
    required this.current,
    required this.hourly,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Average Temperature',
              _calculateAverageTemperature(),
              '°C',
            ),
            _buildStatRow(
              context,
              'Average Humidity',
              _calculateAverageHumidity(),
              '%',
            ),
            _buildStatRow(
              context,
              'Average Wind Speed',
              _calculateAverageWindSpeed(),
              'km/h',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    double value,
    String unit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double _calculateAverageTemperature() {
    return hourly.temperature.reduce((a, b) => a + b) / hourly.temperature.length;
  }

  double _calculateAverageHumidity() {
    return hourly.humidity.reduce((a, b) => a + b) / hourly.humidity.length;
  }

  double _calculateAverageWindSpeed() {
    return hourly.windspeed.reduce((a, b) => a + b) / hourly.windspeed.length;
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WeatherDetail({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
