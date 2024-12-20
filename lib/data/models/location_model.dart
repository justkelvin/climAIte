// lib/data/models/location_model.dart
class LocationResult {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }
}
