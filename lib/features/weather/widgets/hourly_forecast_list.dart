// lib/features/weather/widgets/hourly_forecast_list.dart
import 'package:climaite/data/models/weather_code.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class HourlyForecastList extends StatelessWidget {
  final Hourly hourly;

  const HourlyForecastList({
    super.key,
    required this.hourly,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24, // Show next 24 hours
        itemBuilder: (context, index) {
          final time = DateTime.parse(hourly.time[index]);
          final temperature = hourly.temperature[index];
          final weatherCode = hourly.weathercode[index];

          return Animate(
            effects: [
              FadeEffect(
                delay: Duration(milliseconds: 50 * index),
                duration: const Duration(milliseconds: 300),
              ),
              SlideEffect(
                delay: Duration(milliseconds: 50 * index),
                duration: const Duration(milliseconds: 300),
                begin: const Offset(0.2, 0),
                end: const Offset(0, 0),
              ),
            ],
            child: _HourlyForecastCard(
              time: time,
              temperature: temperature,
              weatherCode: weatherCode,
            ),
          );
        },
      ),
    );
  }
}

class _HourlyForecastCard extends StatelessWidget {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const _HourlyForecastCard({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      margin: const EdgeInsets.only(right: 8),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              DateFormat('HH:mm').format(time),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Icon(
              _getWeatherIcon(weatherCode),
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              '${temperature.round()}°',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
      case WeatherCode.rainSlight:
        return WeatherIcons.rain;
      case WeatherCode.rainHeavy:
        return WeatherIcons.rain_wind;
      case WeatherCode.snowFallSlight:
        return WeatherIcons.snow;
      case WeatherCode.thunderstorm:
        return WeatherIcons.thunderstorm;
      default:
        return WeatherIcons.day_sunny;
    }
  }
}
