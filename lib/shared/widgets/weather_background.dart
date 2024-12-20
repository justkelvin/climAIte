// lib/shared/widgets/weather_background.dart
import 'package:climaite/data/models/weather_code.dart';
import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final Widget child;
  final int weatherCode;

  const WeatherBackground({
    super.key,
    required this.child,
    required this.weatherCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getGradientColors(weatherCode),
        ),
      ),
      child: child,
    );
  }

  List<Color> _getGradientColors(int code) {
    final weatherType = WeatherCode.fromCode(code);
    switch (weatherType) {
      case WeatherCode.clearSky:
        return [
          const Color(0xFF4CA1FF),
          const Color(0xFF3366FF),
        ];
      case WeatherCode.partlyCloudy:
      case WeatherCode.mainlyClear:
        return [
          const Color(0xFF6CA6FF),
          const Color(0xFF4A80FF),
        ];
      case WeatherCode.overcast:
        return [
          const Color(0xFF8E9AAF),
          const Color(0xFF5C6578),
        ];
      case WeatherCode.rainSlight:
      case WeatherCode.rainModerate:
      case WeatherCode.rainHeavy:
        return [
          const Color(0xFF4B6CB7),
          const Color(0xFF182848),
        ];
      case WeatherCode.snowFallSlight:
      case WeatherCode.snowFallModerate:
      case WeatherCode.snowFallHeavy:
        return [
          const Color(0xFFE0E0E0),
          const Color(0xFFA5A5A5),
        ];
      case WeatherCode.thunderstorm:
      case WeatherCode.thunderstormWithSlightHail:
      case WeatherCode.thunderstormWithHeavyHail:
        return [
          const Color(0xFF373B44),
          const Color(0xFF1B1B1B),
        ];
      default:
        return [
          const Color(0xFF4CA1FF),
          const Color(0xFF3366FF),
        ];
    }
  }
}
