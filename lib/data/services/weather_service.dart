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
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.forecast}'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,windspeed_10m,winddirection_10m,weathercode'
      '&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,weathercode'
      '&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum'
      '&timezone=auto',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service: $e');
    }
  }
}
