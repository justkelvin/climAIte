class WeatherData {
  final Current current;
  final Daily daily;
  final Hourly hourly;
  final double latitude;
  final double longitude;
  final double generationtime_ms;
  final int utc_offset_seconds;
  final String timezone;
  final String timezone_abbreviation;
  final double elevation;

  WeatherData({
    required this.current,
    required this.daily,
    required this.hourly,
    required this.latitude,
    required this.longitude,
    required this.generationtime_ms,
    required this.utc_offset_seconds,
    required this.timezone,
    required this.timezone_abbreviation,
    required this.elevation,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: Current.fromJson(json['current']),
      daily: Daily.fromJson(json['daily']),
      hourly: Hourly.fromJson(json['hourly']),
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      generationtime_ms: json['generationtime_ms']?.toDouble() ?? 0.0,
      utc_offset_seconds: json['utc_offset_seconds'] ?? 0,
      timezone: json['timezone'] ?? '',
      timezone_abbreviation: json['timezone_abbreviation'] ?? '',
      elevation: json['elevation']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'daily': daily.toJson(),
      'hourly': hourly.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'generationtime_ms': generationtime_ms,
      'utc_offset_seconds': utc_offset_seconds,
      'timezone': timezone,
      'timezone_abbreviation': timezone_abbreviation,
      'elevation': elevation,
    };
  }
}

class Current {
  final String time;
  final int interval;
  final double temperature;
  final double windspeed;
  final int winddirection;
  final int weathercode;

  Current({
    required this.time,
    required this.interval,
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.weathercode,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      time: json['time'] ?? '',
      interval: json['interval'] ?? 0,
      temperature: json['temperature_2m']?.toDouble() ?? 0.0,
      windspeed: json['windspeed_10m']?.toDouble() ?? 0.0,
      winddirection: json['winddirection_10m']?.toInt() ?? 0,
      weathercode: json['weathercode']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'interval': interval,
      'temperature_2m': temperature,
      'windspeed_10m': windspeed,
      'winddirection_10m': winddirection,
      'weathercode': weathercode,
    };
  }
}

class Daily {
  final List<String> time;
  final List<int> weathercode;
  final List<double> temperatureMax;
  final List<double> temperatureMin;
  final List<double> precipitationSum;

  Daily({
    required this.time,
    required this.weathercode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationSum,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      time: List<String>.from(json['time'] ?? []),
      weathercode: List<int>.from((json['weathercode'] ?? []).map((x) => x)),
      temperatureMax: List<double>.from((json['temperature_2m_max'] ?? []).map((x) => x.toDouble())),
      temperatureMin: List<double>.from((json['temperature_2m_min'] ?? []).map((x) => x.toDouble())),
      precipitationSum: List<double>.from((json['precipitation_sum'] ?? []).map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'weathercode': weathercode,
      'temperature_2m_max': temperatureMax,
      'temperature_2m_min': temperatureMin,
      'precipitation_sum': precipitationSum,
    };
  }
}

class Hourly {
  final List<String> time;
  final List<double> temperature;
  final List<int> humidity;
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
      humidity: List<int>.from((json['relativehumidity_2m'] ?? []).map((x) => x.toInt())),
      windspeed: List<double>.from((json['windspeed_10m'] ?? []).map((x) => x.toDouble())),
      weathercode: List<int>.from((json['weathercode'] ?? []).map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature_2m': temperature,
      'relativehumidity_2m': humidity,
      'windspeed_10m': windspeed,
      'weathercode': weathercode,
    };
  }
}
