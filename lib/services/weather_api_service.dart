import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../models/city_suggestion.dart';
import '../models/current_weather.dart';
import '../models/daily_forecast.dart';
import 'weather_api_exception.dart';

/// Thin client around the free OpenWeatherMap REST endpoints:
///  - Geocoding API (city name -> coordinates)
///  - Current Weather Data API
///  - 5 Day / 3 Hour Forecast API
///
/// These three endpoints are all available on OpenWeatherMap's free tier
/// without a credit card, unlike the newer One Call 3.0 API.
class WeatherApiService {
  static const _baseUrl = 'api.openweathermap.org';
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<CitySuggestion>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.https(_baseUrl, '/geo/1.0/direct', {
      'q': query.trim(),
      'limit': '5',
      'appid': _apiKeyOrThrow(),
    });

    final json = await _getJson(uri);
    final list = json as List;
    return list
        .map((e) => CitySuggestion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CurrentWeather> fetchCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    final uri = Uri.https(_baseUrl, '/data/2.5/weather', {
      'lat': '$lat',
      'lon': '$lon',
      'units': 'metric',
      'appid': _apiKeyOrThrow(),
    });

    final json = await _getJson(uri);
    return CurrentWeather.fromJson(json as Map<String, dynamic>);
  }

  Future<List<DailyForecast>> fetchDailyForecast({
    required double lat,
    required double lon,
  }) async {
    final uri = Uri.https(_baseUrl, '/data/2.5/forecast', {
      'lat': '$lat',
      'lon': '$lon',
      'units': 'metric',
      'appid': _apiKeyOrThrow(),
    });

    final json = await _getJson(uri) as Map<String, dynamic>;
    final city = json['city'] as Map<String, dynamic>? ?? const {};
    final timezoneOffset = (city['timezone'] as num?)?.toInt() ?? 0;

    final rawList = json['list'] as List;
    final entries = rawList.map((e) {
      final entry = ForecastEntry.fromJson(e as Map<String, dynamic>);
      // Shift from UTC into the target city's local wall-clock time so
      // days are grouped the way a resident of that city would see them.
      return ForecastEntry(
        dateTime: entry.dateTime.add(Duration(seconds: timezoneOffset)),
        temp: entry.temp,
        conditionId: entry.conditionId,
        conditionMain: entry.conditionMain,
        description: entry.description,
        icon: entry.icon,
      );
    }).toList();

    final days = DailyForecast.fromEntries(entries);
    // The first grouped day is often "today" with only a few remaining
    // 3-hour slots; keep it but cap at 5 distinct days as advertised.
    return days.take(6).toList();
  }

  String _apiKeyOrThrow() {
    if (!Env.hasApiKey) {
      throw const WeatherApiException(
        'No OpenWeatherMap API key configured. Add OPENWEATHER_API_KEY to your .env file.',
      );
    }
    return Env.openWeatherApiKey;
  }

  Future<dynamic> _getJson(Uri uri) async {
    http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const WeatherApiException('The request timed out. Check your connection and try again.');
    } catch (_) {
      throw const WeatherApiException('Could not reach OpenWeatherMap. Check your internet connection.');
    }

    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 401:
        throw const WeatherApiException(
          'Invalid or inactive API key. New keys can take up to 2 hours to activate after signup.',
        );
      case 404:
        throw const WeatherApiException('Location not found.');
      case 429:
        throw const WeatherApiException('Too many requests. Please wait a moment and try again.');
      default:
        throw WeatherApiException('OpenWeatherMap error (${response.statusCode}). Please try again.');
    }
  }

  void dispose() => _client.close();
}
