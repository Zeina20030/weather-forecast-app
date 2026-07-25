import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/daily_forecast.dart';
import '../theme/weather_theme.dart';

class ForecastTile extends StatelessWidget {
  final DailyForecast day;
  final bool isToday;

  const ForecastTile({super.key, required this.day, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    final theme = WeatherTheme.forCondition(conditionId: day.conditionId, isDay: true);

    return Container(
      width: 84,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isToday ? 'Today' : DateFormat('EEE').format(day.date),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Icon(theme.icon, color: theme.accent, size: 30),
          const SizedBox(height: 8),
          Text(
            '${day.maxTemp.round()}°',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            '${day.minTemp.round()}°',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
