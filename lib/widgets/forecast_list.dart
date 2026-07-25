import 'package:flutter/material.dart';

import '../models/daily_forecast.dart';
import 'forecast_tile.dart';

class ForecastList extends StatelessWidget {
  final List<DailyForecast> days;

  const ForecastList({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isToday = day.date.year == now.year &&
                  day.date.month == now.month &&
                  day.date.day == now.day;
              return ForecastTile(day: day, isToday: isToday);
            },
          ),
        ),
      ],
    );
  }
}
