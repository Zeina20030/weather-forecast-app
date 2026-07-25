class CurrentWeather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int conditionId;
  final String conditionMain;
  final String description;
  final String icon;
  final DateTime dateTime;
  final DateTime sunrise;
  final DateTime sunset;
  final int timezoneOffsetSeconds;

  const CurrentWeather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.conditionId,
    required this.conditionMain,
    required this.description,
    required this.icon,
    required this.dateTime,
    required this.sunrise,
    required this.sunset,
    required this.timezoneOffsetSeconds,
  });

  bool get isDaytime => icon.endsWith('d');

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>? ?? const {};
    final sys = json['sys'] as Map<String, dynamic>? ?? const {};
    final timezoneOffset = json['timezone'] as int? ?? 0;

    return CurrentWeather(
      cityName: json['name'] as String? ?? '',
      country: sys['country'] as String? ?? '',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      pressure: (main['pressure'] as num).toInt(),
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
      conditionId: (weather['id'] as num).toInt(),
      conditionMain: weather['main'] as String? ?? '',
      description: weather['description'] as String? ?? '',
      icon: weather['icon'] as String? ?? '01d',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as num).toInt() * 1000,
        isUtc: true,
      ),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        ((sys['sunrise'] as num?)?.toInt() ?? 0) * 1000,
        isUtc: true,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        ((sys['sunset'] as num?)?.toInt() ?? 0) * 1000,
        isUtc: true,
      ),
      timezoneOffsetSeconds: timezoneOffset,
    );
  }
}
