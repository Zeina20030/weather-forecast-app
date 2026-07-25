import 'package:flutter/material.dart';

import '../models/current_weather.dart';
import '../theme/weather_theme.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weather;
  final String cityLabel;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.cityLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WeatherTheme.forCondition(
      conditionId: weather.conditionId,
      isDay: weather.isDaytime,
    );

    return Column(
      children: [
        Text(
          cityLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Icon(theme.icon, size: 100, color: theme.accent),
        const SizedBox(height: 8),
        Text(
          '${weather.temperature.round()}°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _capitalize(weather.description),
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          'Feels like ${weather.feelsLike.round()}°C  •  H: ${weather.tempMax.round()}° L: ${weather.tempMin.round()}°',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatChip(icon: Icons.water_drop_outlined, label: '${weather.humidity}%'),
            _StatChip(icon: Icons.air, label: '${weather.windSpeed.toStringAsFixed(1)} m/s'),
            _StatChip(icon: Icons.speed, label: '${weather.pressure} hPa'),
          ],
        ),
      ],
    );
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }
}
