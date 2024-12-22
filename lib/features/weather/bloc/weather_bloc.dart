// lib/features/weather/bloc/weather_bloc.dart
import 'package:climaite/data/repositories/weather_repository.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:climaite/features/weather/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<LoadWeather>(_onLoadWeather);
    on<SearchWeather>(_onSearchWeather);
  }

  Future<void> _onLoadWeather(
    LoadWeather event,
    Emitter<WeatherState> emit,
  ) async {
    // Don't emit loading state if we have cached data
    if (state is! WeatherLoaded) {
      emit(WeatherLoading());
    }

    try {
      final weather = await weatherRepository.getWeather(
        latitude: event.latitude,
        longitude: event.longitude,
        isDefaultLocation: true,
        forceRefresh: event.forceRefresh ?? false,
      );

      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      // If we have cached data and the refresh fails, keep showing the cached data
      if (state is WeatherLoaded && !event.forceRefresh!) {
        return;
      }

      emit(WeatherError(
        message: _getErrorMessage(e),
      ));
    }
  }

  Future<void> _onSearchWeather(
    SearchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final weather = await weatherRepository.getWeather(
        latitude: event.latitude,
        longitude: event.longitude,
        isDefaultLocation: false,
      );

      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(
        message: _getErrorMessage(e),
      ));
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') || error.toString().contains('Connection failed')) {
      return 'No internet connection. Please check your connection and try again.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    return 'Failed to load weather data. Please try again.';
  }
}
