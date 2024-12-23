// lib/core/config/app_config.dart
class AppConfig {
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  // Add other environment variables here
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
}
