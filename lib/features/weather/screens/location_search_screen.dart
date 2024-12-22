// lib/features/weather/screens/location_search_screen.dart
import 'package:climaite/data/models/location_model.dart';
import 'package:climaite/data/services/location_service.dart';
import 'package:climaite/features/weather/bloc/weather_bloc.dart';
import 'package:climaite/features/weather/bloc/weather_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  List<LocationResult> _searchResults = [];
  bool _isLoading = false;
  // ignore: unused_field
  bool _isMounted = true;

  @override
  void dispose() {
    // _searchController.dispose();
    _isMounted = false;
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.length < 2) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _locationService.searchLocation(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                _searchLocation(value);
              },
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final location = _searchResults[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(location.name),
                    subtitle: Text(location.country),
                    onTap: () {
                      context.read<WeatherBloc>().add(
                            SearchWeather(
                              latitude: location.latitude,
                              longitude: location.longitude,
                            ),
                          );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
