// lib/data/services/location_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class LocationService {
  final String baseUrl = 'https://geocoding-api.open-meteo.com/v1';

  Future<List<LocationResult>> searchLocation(String query) async {
    final uri = Uri.parse(
      '$baseUrl/search?name=$query&count=10&language=en&format=json',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = (data['results'] as List?)
                ?.map(
                  (result) => LocationResult.fromJson(result),
                )
                .toList() ??
            [];
        return results;
      } else {
        throw Exception('Failed to search location');
      }
    } catch (e) {
      throw Exception('Failed to connect to location service: $e');
    }
  }
}
