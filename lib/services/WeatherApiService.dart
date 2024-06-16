import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2/models/Weather.dart';

class WeatherApiService {
  final String apiKey;

  WeatherApiService(this.apiKey);

  Future<Weather> fetchCurrentWeather(String cityName) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Weather(
        cityName: data['name'], // Utilisation de la clé 'name' pour obtenir le nom de la ville
        temperature: data['main']['temp'].toDouble(),
        condition: data['weather'][0]['description'], // Utilisation de la première condition météorologique dans la liste
        windSpeed: data['wind']['speed'].toDouble(), // Vitesse du vent en m/s
        date: DateTime.now(), // Date actuelle pour la météo actuelle
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<Weather>> fetchWeeklyWeather(String cityName) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast/daily?q=$cityName&cnt=7&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dailyForecasts = data['list'];

      return dailyForecasts.map((dayData) {
        return Weather(
          cityName: data['city']['name'], // Utilisation de la clé 'name' pour obtenir le nom de la ville
          temperature: dayData['temp']['day'].toDouble(),
          condition: dayData['weather'][0]['description'], // Utilisation de la première condition météorologique dans la liste
          windSpeed: dayData['speed'].toDouble(), // Vitesse du vent en m/s
          date: DateTime.fromMillisecondsSinceEpoch(dayData['dt'] * 1000), // Convertir l'horodatage en objet DateTime
        );
      }).toList();
    } else {
      throw Exception('Failed to load weekly weather data');
    }
  }
}
