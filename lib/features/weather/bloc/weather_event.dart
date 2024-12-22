// lib/features/weather/bloc/weather_event.dart
abstract class WeatherEvent {
  const WeatherEvent();
}

class LoadWeather extends WeatherEvent {
  final double latitude;
  final double longitude;
  final bool? forceRefresh;

  const LoadWeather({
    required this.latitude,
    required this.longitude,
    this.forceRefresh,
  });
}

class SearchWeather extends WeatherEvent {
  final double latitude;
  final double longitude;

  const SearchWeather({
    required this.latitude,
    required this.longitude,
  });
}
