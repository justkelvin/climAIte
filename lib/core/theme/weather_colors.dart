// lib/core/theme/weather_colors.dart
import 'package:flutter/material.dart';

class WeatherColors extends ThemeExtension<WeatherColors> {
  final Color? sunny;
  final Color? rainy;
  final Color? cloudy;
  final Color? snowy;

  const WeatherColors({
    required this.sunny,
    required this.rainy,
    required this.cloudy,
    required this.snowy,
  });

  @override
  ThemeExtension<WeatherColors> copyWith({
    Color? sunny,
    Color? rainy,
    Color? cloudy,
    Color? snowy,
  }) {
    return WeatherColors(
      sunny: sunny ?? this.sunny,
      rainy: rainy ?? this.rainy,
      cloudy: cloudy ?? this.cloudy,
      snowy: snowy ?? this.snowy,
    );
  }

  @override
  ThemeExtension<WeatherColors> lerp(
    ThemeExtension<WeatherColors>? other,
    double t,
  ) {
    if (other is! WeatherColors) {
      return this;
    }
    return WeatherColors(
      sunny: Color.lerp(sunny, other.sunny, t),
      rainy: Color.lerp(rainy, other.rainy, t),
      cloudy: Color.lerp(cloudy, other.cloudy, t),
      snowy: Color.lerp(snowy, other.snowy, t),
    );
  }
}
