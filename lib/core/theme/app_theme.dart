// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A90E2),
        brightness: Brightness.light,
      ),
      extensions: [
        WeatherColors(
          sunny: const Color(0xFFFFB300),
          rainy: const Color(0xFF4A90E2),
          cloudy: const Color(0xFF78909C),
          snowy: const Color(0xFFE0E0E0),
        ),
      ],
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white.withOpacity(0.8),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A90E2),
        brightness: Brightness.dark,
      ),
      extensions: [
        WeatherColors(
          sunny: const Color(0xFFFFB300),
          rainy: const Color(0xFF4A90E2),
          cloudy: const Color(0xFF78909C),
          snowy: const Color(0xFFE0E0E0),
        ),
      ],
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.black54,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.white54,
        ),
      ),
    );
  }
}
