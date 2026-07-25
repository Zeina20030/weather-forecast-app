import 'package:flutter/material.dart';

/// Maps OpenWeatherMap condition codes/icons to a Material icon and a
/// background gradient, so the UI visually reacts to real weather data.
///
/// Condition code ranges (see https://openweathermap.org/weather-conditions):
///   2xx Thunderstorm, 3xx Drizzle, 5xx Rain, 6xx Snow, 7xx Atmosphere
///   800 Clear, 801-804 Clouds
class WeatherTheme {
  final IconData icon;
  final List<Color> gradient;
  final Color accent;

  const WeatherTheme({
    required this.icon,
    required this.gradient,
    required this.accent,
  });

  static WeatherTheme forCondition({required int conditionId, required bool isDay}) {
    if (conditionId >= 200 && conditionId < 300) {
      return WeatherTheme(
        icon: Icons.thunderstorm,
        gradient: const [Color(0xFF29323C), Color(0xFF485563)],
        accent: const Color(0xFFFFD54F),
      );
    }
    if (conditionId >= 300 && conditionId < 400) {
      return WeatherTheme(
        icon: Icons.grain,
        gradient: isDay
            ? const [Color(0xFF757F9A), Color(0xFFD7DDE8)]
            : const [Color(0xFF2C3E50), Color(0xFF4A5A6A)],
        accent: const Color(0xFF90CAF9),
      );
    }
    if (conditionId >= 500 && conditionId < 600) {
      return WeatherTheme(
        icon: Icons.water_drop,
        gradient: isDay
            ? const [Color(0xFF4B6CB7), Color(0xFF182848)]
            : const [Color(0xFF141E30), Color(0xFF243B55)],
        accent: const Color(0xFF64B5F6),
      );
    }
    if (conditionId >= 600 && conditionId < 700) {
      return WeatherTheme(
        icon: Icons.ac_unit,
        gradient: const [Color(0xFF83A4D4), Color(0xFFB6FBFF)],
        accent: const Color(0xFFE1F5FE),
      );
    }
    if (conditionId >= 700 && conditionId < 800) {
      return WeatherTheme(
        icon: Icons.foggy,
        gradient: const [Color(0xFFBDC3C7), Color(0xFF6E7A85)],
        accent: const Color(0xFFECEFF1),
      );
    }
    if (conditionId == 800) {
      return WeatherTheme(
        icon: isDay ? Icons.wb_sunny : Icons.nightlight_round,
        gradient: isDay
            ? const [Color(0xFF56CCF2), Color(0xFF2F80ED)]
            : const [Color(0xFF0F2027), Color(0xFF203A43)],
        accent: isDay ? const Color(0xFFFFF176) : const Color(0xFFB0BEC5),
      );
    }
    if (conditionId > 800 && conditionId < 900) {
      return WeatherTheme(
        icon: isDay ? Icons.wb_cloudy : Icons.cloud,
        gradient: isDay
            ? const [Color(0xFF757F9A), Color(0xFFD7DDE8)]
            : const [Color(0xFF232526), Color(0xFF414345)],
        accent: const Color(0xFFCFD8DC),
      );
    }
    // Fallback for unexpected codes.
    return const WeatherTheme(
      icon: Icons.thermostat,
      gradient: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
      accent: Color(0xFF90A4AE),
    );
  }
}
