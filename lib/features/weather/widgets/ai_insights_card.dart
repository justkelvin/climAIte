import 'package:climaite/core/providers/settings_provider.dart';
import 'package:climaite/data/models/weather_model.dart';
import 'package:climaite/data/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
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

class _AIInsightsCardState extends State<AIInsightsCard> with SingleTickerProviderStateMixin {
  final AIService _aiService = AIService();
  late final AnimationController _animationController;
  String _insights = '';
  bool _isLoading = false;
  bool _hasError = false;
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();
    _loadInsights();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInsights() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (!settings.aiInsightsEnabled) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _insights = '';
      _isStreaming = false;
    });

    try {
      setState(() {
        _isLoading = false;
        _isStreaming = true;
      });

      await for (final chunk in _aiService.streamWeatherInsights(
        currentWeather: widget.weather,
        location: widget.location,
      )) {
        if (mounted) {
          setState(() {
            _insights += chunk;
          });
        }
      }

      if (mounted) {
        setState(() {
          _isStreaming = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _isStreaming = false;
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
      color: Theme.of(context).colorScheme.surface.withAlpha(204), // 0.8 * 255 ≈ 204
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
                if (_isStreaming) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              Center(
                child: Lottie.asset('assets/lottie/app-loading.json', height: 100),
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
            else if (_insights.isNotEmpty)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Text(_insights)
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 300),
                      )
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        duration: const Duration(milliseconds: 200),
                      );
                },
              ),
          ],
        ),
      ),
    );
  }
}
