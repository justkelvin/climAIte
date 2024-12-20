// lib/features/weather/bloc/weather_event.dart
abstract class WeatherEvent {
  const WeatherEvent();
}

class LoadWeather extends WeatherEvent {
  final double latitude;
  final double longitude;

  const LoadWeather({
    required this.latitude,
    required this.longitude,
  });
}
