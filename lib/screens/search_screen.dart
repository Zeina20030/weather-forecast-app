import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city_suggestion.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    context.read<WeatherProvider>().clearSearch();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<WeatherProvider>().searchCities(query);
    });
  }

  void _selectCity(CitySuggestion city) {
    context.read<WeatherProvider>().loadWeatherForCity(city);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search for a city…',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, _) {
          switch (provider.searchStatus) {
            case SearchStatus.idle:
              return const _CenteredMessage('Type at least 2 characters to search');
            case SearchStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SearchStatus.error:
              return _CenteredMessage(provider.searchError ?? 'Something went wrong');
            case SearchStatus.loaded:
              if (provider.searchResults.isEmpty) {
                return const _CenteredMessage('No cities found');
              }
              return ListView.separated(
                itemCount: provider.searchResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final city = provider.searchResults[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(city.displayName),
                    onTap: () => _selectCity(city),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String message;

  const _CenteredMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
