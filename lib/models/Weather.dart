class Weather {
  final String cityName;
  final DateTime date;
  final double temperature;
  final String condition;
  final double windSpeed;
  final double? rainVolume;
  final double? visibility;
  final double? pop;

  Weather({
    required this.cityName,
    required this.date,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    this.rainVolume,
    this.visibility,
    this.pop,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    return Weather(
      cityName: cityName,
      date: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'],
      condition: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'],
      rainVolume: json['rain'] != null ? json['rain']['3h'] : null,
      visibility: json['visibility']?.toDouble(),
      pop: json['pop']?.toDouble(),
    );
  }
}
