// lib/features/weather/widgets/ai_insights_card.dart
import 'package:climaite/core/providers/settings_provider.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:climaite/data/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class AIInsightsCard extends StatefulWidget {
  final WeatherData weather;
  final String location;

  const AIInsightsCard({
    super.key,
    required this.weather,
    required this.location,
  });

  @override
  State<AIInsightsCard> createState() => _AIInsightsCardState();
}

class _AIInsightsCardState extends State<AIInsightsCard> {
  final AIService _aiService = AIService();
  String? _insights;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (!settings.aiInsightsEnabled) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final insights = await _aiService.getWeatherInsights(
        currentWeather: widget.weather,
        location: widget.location,
      );

      if (mounted) {
        setState(() {
          _insights = insights;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    if (!settings.aiInsightsEnabled) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Weather Insights',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_hasError)
              Center(
                child: Column(
                  children: [
                    const Text('Failed to load insights'),
                    TextButton(
                      onPressed: _loadInsights,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (_insights != null)
              Text(_insights!).animate().fadeIn(duration: const Duration(milliseconds: 500)).slideX(
                    begin: 0.2,
                    end: 0,
                    duration: const Duration(milliseconds: 500),
                  ),
          ],
        ),
      ),
    );
  }
}
