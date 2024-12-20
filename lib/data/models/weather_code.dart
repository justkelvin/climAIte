// lib/data/models/weather_code.dart
enum WeatherCode {
  clearSky(0),
  mainlyClear(1),
  partlyCloudy(2),
  overcast(3),
  fog(45),
  depositingRimeFog(48),
  drizzleLight(51),
  drizzleModerate(53),
  drizzleDense(55),
  freezingDrizzleLight(56),
  freezingDrizzleDense(57),
  rainSlight(61),
  rainModerate(63),
  rainHeavy(65),
  freezingRainLight(66),
  freezingRainHeavy(67),
  snowFallSlight(71),
  snowFallModerate(73),
  snowFallHeavy(75),
  snowGrains(77),
  rainShowersSlight(80),
  rainShowersModerate(81),
  rainShowersViolent(82),
  snowShowersSlight(85),
  snowShowersHeavy(86),
  thunderstorm(95),
  thunderstormWithSlightHail(96),
  thunderstormWithHeavyHail(99);

  final int code;
  const WeatherCode(this.code);

  static WeatherCode fromCode(int code) {
    return WeatherCode.values.firstWhere(
      (element) => element.code == code,
      orElse: () => WeatherCode.clearSky,
    );
  }

  String get description {
    switch (this) {
      case WeatherCode.clearSky:
        return 'Clear sky';
      case WeatherCode.mainlyClear:
        return 'Mainly clear';
      case WeatherCode.partlyCloudy:
        return 'Partly cloudy';
      case WeatherCode.overcast:
        return 'Overcast';
      case WeatherCode.fog:
        return 'Fog';
      case WeatherCode.depositingRimeFog:
        return 'Depositing rime fog';
      case WeatherCode.drizzleLight:
        return 'Light drizzle';
      case WeatherCode.drizzleModerate:
        return 'Moderate drizzle';
      case WeatherCode.drizzleDense:
        return 'Dense drizzle';
      case WeatherCode.freezingDrizzleLight:
        return 'Light freezing drizzle';
      case WeatherCode.freezingDrizzleDense:
        return 'Dense freezing drizzle';
      case WeatherCode.rainSlight:
        return 'Slight rain';
      case WeatherCode.rainModerate:
        return 'Moderate rain';
      case WeatherCode.rainHeavy:
        return 'Heavy rain';
      case WeatherCode.freezingRainLight:
        return 'Light freezing rain';
      case WeatherCode.freezingRainHeavy:
        return 'Heavy freezing rain';
      case WeatherCode.snowFallSlight:
        return 'Slight snow fall';
      case WeatherCode.snowFallModerate:
        return 'Moderate snow fall';
      case WeatherCode.snowFallHeavy:
        return 'Heavy snow fall';
      case WeatherCode.snowGrains:
        return 'Snow grains';
      case WeatherCode.rainShowersSlight:
        return 'Slight rain showers';
      case WeatherCode.rainShowersModerate:
        return 'Moderate rain showers';
      case WeatherCode.rainShowersViolent:
        return 'Violent rain showers';
      case WeatherCode.snowShowersSlight:
        return 'Slight snow showers';
      case WeatherCode.snowShowersHeavy:
        return 'Heavy snow showers';
      case WeatherCode.thunderstorm:
        return 'Thunderstorm';
      case WeatherCode.thunderstormWithSlightHail:
        return 'Thunderstorm with slight hail';
      case WeatherCode.thunderstormWithHeavyHail:
        return 'Thunderstorm with heavy hail';
    }
  }
}
