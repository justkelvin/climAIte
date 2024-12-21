// lib/data/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../../core/constants/api_constants.dart';

class WeatherService {
  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    // First get location name using reverse geocoding
    final locationUri = Uri.parse('https://geocoding-api.open-meteo.com/v1/reverse?latitude=$latitude&longitude=$longitude');

    final locationResponse = await http.get(locationUri);
    final locationData = json.decode(locationResponse.body);

    // Then get weather data
    final weatherUri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.forecast}'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,windspeed_10m,winddirection_10m,weathercode'
      '&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,weathercode'
      '&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum'
      '&timezone=auto',
    );

    final weatherResponse = await http.get(weatherUri);

    if (weatherResponse.statusCode == 200) {
      final weatherData = json.decode(weatherResponse.body);
      // Merge location data into weather response
      weatherData['location'] = locationData['results']?[0];
      return WeatherData.fromJson(weatherData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
