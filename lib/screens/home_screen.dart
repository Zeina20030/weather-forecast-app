import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../theme/weather_theme.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/weather_background.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialLoad());
  }

  Future<void> _initialLoad() async {
    final provider = context.read<WeatherProvider>();
    await provider.loadWeatherForCurrentLocation();
  }

  void _openSearch() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final weather = provider.currentWeather;
        final gradient = weather != null
            ? WeatherTheme.forCondition(
                conditionId: weather.conditionId,
                isDay: weather.isDaytime,
              ).gradient
            : const [Color(0xFF56CCF2), Color(0xFF2F80ED)];

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Weather', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: _openSearch,
                tooltip: 'Search city',
              ),
              IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: provider.loadWeatherForCurrentLocation,
                tooltip: 'Use current location',
              ),
            ],
          ),
          body: WeatherBackground(
            colors: gradient,
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: provider.refresh,
                child: _buildBody(provider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    switch (provider.status) {
      case WeatherStatus.initial:
      case WeatherStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      case WeatherStatus.error:
        return _ErrorView(
          message: provider.errorMessage ?? 'Something went wrong',
          onRetry: provider.loadWeatherForCurrentLocation,
          onSearch: _openSearch,
        );
      case WeatherStatus.loaded:
        final weather = provider.currentWeather!;
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            CurrentWeatherCard(
              weather: weather,
              cityLabel: provider.selectedCityLabel ??
                  '${weather.cityName}${weather.country.isNotEmpty ? ', ${weather.country}' : ''}',
            ),
            const SizedBox(height: 32),
            ForecastList(days: provider.forecast),
          ],
        );
    }
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSearch;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Use my location'),
                ),
                OutlinedButton.icon(
                  onPressed: onSearch,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(Icons.search),
                  label: const Text('Search city'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
