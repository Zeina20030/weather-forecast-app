import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads configuration values loaded from the gitignored `.env` file.
class Env {
  Env._();

  static String get openWeatherApiKey =>
      dotenv.maybeGet('OPENWEATHER_API_KEY')?.trim() ?? '';

  static bool get hasApiKey =>
      openWeatherApiKey.isNotEmpty && openWeatherApiKey != 'your_api_key_here';
}
