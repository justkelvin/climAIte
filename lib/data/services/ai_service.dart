// lib/data/services/ai_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/weather_model.dart';
import '../models/weather_code.dart';

class AIService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'default_value';
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> getWeatherInsights({
    required WeatherData currentWeather,
    required String location,
  }) async {
    try {
      final weatherCode = WeatherCode.fromCode(currentWeather.current.weathercode);
      final prompt = '''
        Act as a weather expert and provide a brief, personalized analysis of the following weather conditions:
        Location: $location
        Current Temperature: ${currentWeather.current.temperature}°C
        Weather Condition: ${weatherCode.description}
        Wind Speed: ${currentWeather.current.windspeed} km/h
        
        Consider:
        1. How the weather feels
        2. Any precautions needed
        3. Suitable activities for these conditions
        4. Brief forecast trends
        
        Keep the response concise and conversational.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Unable to generate insights at the moment.';
    } catch (e) {
      return 'AI insights unavailable: $e';
    }
  }
}
