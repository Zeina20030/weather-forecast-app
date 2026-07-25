/// A user-facing error raised by [WeatherApiService].
class WeatherApiException implements Exception {
  final String message;

  const WeatherApiException(this.message);

  @override
  String toString() => message;
}
