class CitySuggestion {
  final String name;
  final String? state;
  final String country;
  final double lat;
  final double lon;

  const CitySuggestion({
    required this.name,
    this.state,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] as String? ?? '',
      state: json['state'] as String?,
      country: json['country'] as String? ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  String get displayName {
    final parts = [name, if (state != null && state!.isNotEmpty) state, country];
    return parts.join(', ');
  }
}
