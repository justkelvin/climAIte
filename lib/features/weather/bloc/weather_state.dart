// lib/features/weather/bloc/weather_state.dart
import 'package:climaite/data/models/weather_model.dart';

abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weather;

  const WeatherLoaded({required this.weather});
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});
}
