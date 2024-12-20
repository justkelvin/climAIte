// lib/features/weather/widgets/daily_forecast_list.dart
import 'package:climaite/data/models/weather_code.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class DailyForecastList extends StatelessWidget {
  final Daily daily;

  const DailyForecastList({
    super.key,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        7, // Show 7 days forecast
        (index) {
          final date = DateTime.parse(daily.time[index]);
          final maxTemp = daily.temperatureMax[index];
          final minTemp = daily.temperatureMin[index];
          final weatherCode = daily.weathercode[index];

          return Animate(
            effects: [
              FadeEffect(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 300),
              ),
              SlideEffect(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 300),
                begin: const Offset(0.2, 0),
                end: const Offset(0, 0),
              ),
            ],
            child: _DailyForecastCard(
              date: date,
              maxTemp: maxTemp,
              minTemp: minTemp,
              weatherCode: weatherCode,
            ),
          );
        },
      ),
    );
  }
}

class _DailyForecastCard extends StatelessWidget {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  const _DailyForecastCard({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                DateFormat('EEEE').format(date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              _getWeatherIcon(weatherCode),
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
            Row(
              children: [
                Text(
                  '${maxTemp.round()}°',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${minTemp.round()}°',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                ),
              ],
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
