import 'package:flutter/foundation.dart';

import '../models/city_suggestion.dart';
import '../models/current_weather.dart';
import '../models/daily_forecast.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';

enum WeatherStatus { initial, loading, loaded, error }

enum SearchStatus { idle, loading, loaded, error }

/// Central app state: holds the currently loaded weather/forecast plus the
/// city-search results, and exposes the actions the UI can trigger.
class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _weatherApi;
  final LocationService _locationService;

  WeatherProvider({
    WeatherApiService? weatherApi,
    LocationService? locationService,
  })  : _weatherApi = weatherApi ?? WeatherApiService(),
        _locationService = locationService ?? LocationService();

  WeatherStatus status = WeatherStatus.initial;
  String? errorMessage;
  CurrentWeather? currentWeather;
  List<DailyForecast> forecast = [];
  String? selectedCityLabel;

  SearchStatus searchStatus = SearchStatus.idle;
  List<CitySuggestion> searchResults = [];
  String? searchError;

  double? _lastLat;
  double? _lastLon;

  Future<void> loadWeatherForCity(CitySuggestion city) async {
    selectedCityLabel = city.displayName;
    await _loadWeather(lat: city.lat, lon: city.lon);
  }

  Future<void> loadWeatherForCurrentLocation() async {
    status = WeatherStatus.loading;
    notifyListeners();
    try {
      final position = await _locationService.getCurrentPosition();
      selectedCityLabel = null;
      await _loadWeather(lat: position.latitude, lon: position.longitude);
    } catch (e) {
      status = WeatherStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Re-fetches weather for whatever location (searched city or current
  /// position) was loaded last; used by pull-to-refresh.
  Future<void> refresh() async {
    if (_lastLat == null || _lastLon == null) {
      await loadWeatherForCurrentLocation();
      return;
    }
    await _loadWeather(lat: _lastLat!, lon: _lastLon!);
  }

  Future<void> _loadWeather({required double lat, required double lon}) async {
    status = WeatherStatus.loading;
    errorMessage = null;
    _lastLat = lat;
    _lastLon = lon;
    notifyListeners();

    try {
      final results = await Future.wait([
        _weatherApi.fetchCurrentWeather(lat: lat, lon: lon),
        _weatherApi.fetchDailyForecast(lat: lat, lon: lon),
      ]);
      currentWeather = results[0] as CurrentWeather;
      forecast = results[1] as List<DailyForecast>;
      status = WeatherStatus.loaded;
    } catch (e) {
      status = WeatherStatus.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> searchCities(String query) async {
    if (query.trim().length < 2) {
      searchResults = [];
      searchStatus = SearchStatus.idle;
      notifyListeners();
      return;
    }

    searchStatus = SearchStatus.loading;
    notifyListeners();
    try {
      searchResults = await _weatherApi.searchCities(query);
      searchStatus = SearchStatus.loaded;
    } catch (e) {
      searchError = e.toString();
      searchStatus = SearchStatus.error;
    }
    notifyListeners();
  }

  void clearSearch() {
    searchResults = [];
    searchStatus = SearchStatus.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _weatherApi.dispose();
    super.dispose();
  }
}
