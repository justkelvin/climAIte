// lib/data/models/weather_model.dart
class WeatherData {
  final Current current;
  final Daily daily;
  final Hourly hourly;
  final double latitude;
  final double longitude;
  final String timezone;

  WeatherData({
    required this.current,
    required this.daily,
    required this.hourly,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: Current.fromJson(json['current']),
      daily: Daily.fromJson(json['daily']),
      hourly: Hourly.fromJson(json['hourly']),
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      timezone: json['timezone'] ?? 'UTC',
    );
  }
}

class Current {
  final double temperature;
  final double windspeed;
  final int winddirection;
  final int weathercode;
  final String time;

  Current({
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.weathercode,
    required this.time,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      temperature: json['temperature_2m']?.toDouble() ?? 0.0,
      windspeed: json['windspeed_10m']?.toDouble() ?? 0.0,
      winddirection: json['winddirection_10m']?.toInt() ?? 0,
      weathercode: json['weathercode']?.toInt() ?? 0,
      time: json['time'] ?? '',
    );
  }
}

class Daily {
  final List<String> time;
  final List<double> temperatureMax;
  final List<double> temperatureMin;
  final List<double> precipitationSum;
  final List<int> weathercode;

  Daily({
    required this.time,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationSum,
    required this.weathercode,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      time: List<String>.from(json['time'] ?? []),
      temperatureMax: List<double>.from((json['temperature_2m_max'] ?? []).map((x) => x.toDouble())),
      temperatureMin: List<double>.from((json['temperature_2m_min'] ?? []).map((x) => x.toDouble())),
      precipitationSum: List<double>.from((json['precipitation_sum'] ?? []).map((x) => x.toDouble())),
      weathercode: List<int>.from((json['weathercode'] ?? []).map((x) => x.toInt())),
    );
  }
}

class Hourly {
  final List<String> time;
  final List<double> temperature;
  final List<double> humidity;
  final List<double> windspeed;
  final List<int> weathercode;

  Hourly({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.windspeed,
    required this.weathercode,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      time: List<String>.from(json['time'] ?? []),
      temperature: List<double>.from((json['temperature_2m'] ?? []).map((x) => x.toDouble())),
      humidity: List<double>.from((json['relativehumidity_2m'] ?? []).map((x) => x.toDouble())),
      windspeed: List<double>.from((json['windspeed_10m'] ?? []).map((x) => x.toDouble())),
      weathercode: List<int>.from((json['weathercode'] ?? []).map((x) => x.toInt())),
    );
  }
}
