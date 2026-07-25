/// A single forecast entry from the OpenWeatherMap 5-day/3-hour endpoint.
class ForecastEntry {
  final DateTime dateTime;
  final double temp;
  final int conditionId;
  final String conditionMain;
  final String description;
  final String icon;

  const ForecastEntry({
    required this.dateTime,
    required this.temp,
    required this.conditionId,
    required this.conditionMain,
    required this.description,
    required this.icon,
  });

  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    return ForecastEntry(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as num).toInt() * 1000,
        isUtc: true,
      ),
      temp: (main['temp'] as num).toDouble(),
      conditionId: (weather['id'] as num).toInt(),
      conditionMain: weather['main'] as String? ?? '',
      description: weather['description'] as String? ?? '',
      icon: weather['icon'] as String? ?? '01d',
    );
  }
}

/// A single day, aggregated from multiple 3-hour [ForecastEntry] values.
class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int conditionId;
  final String conditionMain;
  final String description;
  final String icon;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.conditionId,
    required this.conditionMain,
    required this.description,
    required this.icon,
  });

  /// Groups raw 3-hour [entries] (already in local time) into one
  /// [DailyForecast] per calendar day, using the entry closest to noon as
  /// the representative condition/icon for that day.
  static List<DailyForecast> fromEntries(List<ForecastEntry> entries) {
    final byDay = <DateTime, List<ForecastEntry>>{};
    for (final entry in entries) {
      final dayKey = DateTime(
        entry.dateTime.year,
        entry.dateTime.month,
        entry.dateTime.day,
      );
      byDay.putIfAbsent(dayKey, () => []).add(entry);
    }

    final days = byDay.keys.toList()..sort();
    return days.map((day) {
      final dayEntries = byDay[day]!;
      final minTemp = dayEntries.map((e) => e.temp).reduce((a, b) => a < b ? a : b);
      final maxTemp = dayEntries.map((e) => e.temp).reduce((a, b) => a > b ? a : b);
      final representative = dayEntries.reduce((a, b) {
        final aDiff = (a.dateTime.hour - 12).abs();
        final bDiff = (b.dateTime.hour - 12).abs();
        return aDiff <= bDiff ? a : b;
      });

      return DailyForecast(
        date: day,
        minTemp: minTemp,
        maxTemp: maxTemp,
        conditionId: representative.conditionId,
        conditionMain: representative.conditionMain,
        description: representative.description,
        icon: representative.icon,
      );
    }).toList();
  }
}
