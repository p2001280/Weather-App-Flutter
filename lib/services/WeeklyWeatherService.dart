import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2/models/Weather.dart';

class WeeklyWeatherService {
  final String apiKey;

  WeeklyWeatherService(this.apiKey);

  Future<Map<String, List<Weather>>> fetchWeeklyWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&lang=fr&appid=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> weatherList = data['list'];
      final String city = data['city']['name'];

      Map<String, List<Weather>> dailyWeatherMap = {};

      for (var json in weatherList) {
        Weather weather = Weather.fromJson(json, city);
        String dateKey = weather.date.toIso8601String().substring(0, 10); // YYYY-MM-DD
        if (!dailyWeatherMap.containsKey(dateKey)) {
          dailyWeatherMap[dateKey] = [];
        }
        dailyWeatherMap[dateKey]!.add(weather);
      }

      // Calculate average weather for each day
      List<Weather> dailyWeather = dailyWeatherMap.entries.map((entry) {
        List<Weather> dailyData = entry.value;
        double avgTemp = dailyData.map((e) => e.temperature).reduce((a, b) => a + b) / dailyData.length;
        double avgWindSpeed = dailyData.map((e) => e.windSpeed).reduce((a, b) => a + b) / dailyData.length;
        String condition = dailyData.first.condition; // Simplification, take the first condition

        return Weather(
          cityName: city,
          date: dailyData.first.date,
          temperature: avgTemp,
          condition: condition,
          windSpeed: avgWindSpeed,
          rainVolume: dailyData.map((e) => e.rainVolume ?? 0).reduce((a, b) => a + b),
          visibility: dailyData.map((e) => e.visibility ?? 10000).reduce((a, b) => a < b ? a : b), // min visibility
          pop: dailyData.map((e) => e.pop ?? 0).reduce((a, b) => a + b) / dailyData.length, // avg pop
        );
      }).toList();

      // Return a map with daily weather and hourly weather for the current day
      return {
        'daily': dailyWeather,
        'hourly': dailyWeatherMap[dailyWeather.first.date.toIso8601String().substring(0, 10)]!
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
