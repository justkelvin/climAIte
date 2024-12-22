// lib/features/weather/widgets/current_weather_card.dart
import 'package:climaite/data/models/weather_code.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Current weather;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withAlpha(204),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      WeatherCode.fromCode(weather.weathercode).description,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                _buildWeatherIcon(context, weather.weathercode),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  context,
                  WeatherIcons.strong_wind,
                  '${weather.windspeed.round()} km/h',
                  'Wind',
                ),
                _buildWeatherDetail(
                  context,
                  WeatherIcons.direction_up,
                  '${weather.winddirection}°',
                  'Direction',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(BuildContext context, int code) {
    final weatherType = WeatherCode.fromCode(code);
    IconData iconData;

    switch (weatherType) {
      case WeatherCode.clearSky:
        iconData = WeatherIcons.day_sunny;
        break;
      case WeatherCode.partlyCloudy:
        iconData = WeatherIcons.day_cloudy;
        break;
      case WeatherCode.overcast:
        iconData = WeatherIcons.cloudy;
        break;
      case WeatherCode.rainSlight:
        iconData = WeatherIcons.rain;
        break;
      case WeatherCode.rainHeavy:
        iconData = WeatherIcons.rain_wind;
        break;
      case WeatherCode.snowFallSlight:
        iconData = WeatherIcons.snow;
        break;
      case WeatherCode.thunderstorm:
        iconData = WeatherIcons.thunderstorm;
        break;
      default:
        iconData = WeatherIcons.day_sunny;
    }

    return Icon(
      iconData,
      size: 64,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
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
