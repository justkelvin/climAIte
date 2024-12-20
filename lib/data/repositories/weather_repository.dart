// lib/data/repositories/weather_repository.dart
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  final WeatherService _weatherService;

  WeatherRepository({WeatherService? weatherService}) : _weatherService = weatherService ?? WeatherService();

  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    return await _weatherService.getWeather(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
