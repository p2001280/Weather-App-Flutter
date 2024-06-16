import 'package:flutter/material.dart';
import 'package:weather_app_v2/models/Weather.dart';
import 'package:weather_app_v2/services/WeeklyWeatherService.dart';
import 'package:weather_app_v2/widgets/WeatherCard.dart';

class WeeklyWeatherScreen extends StatefulWidget {
  const WeeklyWeatherScreen({Key? key}) : super(key: key);

  @override
  _WeeklyWeatherScreenState createState() => _WeeklyWeatherScreenState();
}

class _WeeklyWeatherScreenState extends State<WeeklyWeatherScreen> {
  String cityName = 'Paris'; // Default city
  final WeeklyWeatherService _weeklyWeatherService = WeeklyWeatherService('e977c064fca504a81ad0b82b74ed5dbe');
  late Future<Map<String, List<Weather>>> _fetchWeeklyWeather;
  List<String> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _fetchWeeklyWeather = _weeklyWeatherService.fetchWeeklyWeather(cityName);
  }

  void _toggleFavorite(String city) {
    setState(() {
      if (favoriteCities.contains(city)) {
        favoriteCities.remove(city);
      } else {
        favoriteCities.add(city);
      }
    });
  }

  String _getWeatherImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'ensoleillé':
        return 'assets/images/sunny.png';
      case 'partiellement nuageux':
        return 'assets/images/cloudy.png';
      case 'nuageux':
        return 'assets/images/cloudy.png';
      case 'couvert':
        return 'assets/images/cloudy-v2.png';
      case 'peu nuageux':
        return 'assets/images/cloudy.png';
      case 'pluvieux':
        return 'assets/images/rainy.png';
      case 'légère pluie':
        return 'assets/images/rainy.png';
      case 'ciel dégagé':
        return 'assets/images/cleared-sky.png';
      case 'pluie':
        return 'assets/images/rainy.png';
      default:
        return 'assets/images/sunny.png'; // Default
    }
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Lundi';
      case DateTime.tuesday:
        return 'Mardi';
      case DateTime.wednesday:
        return 'Mercredi';
      case DateTime.thursday:
        return 'Jeudi';
      case DateTime.friday:
        return 'Vendredi';
      case DateTime.saturday:
        return 'Samedi';
      case DateTime.sunday:
        return 'Dimanche';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Greater Weather'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Nom de la ville',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        cityName = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _fetchWeeklyWeather = _weeklyWeatherService.fetchWeeklyWeather(cityName);
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      favoriteCities.contains(cityName) ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () {
                      _toggleFavorite(cityName);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, List<Weather>>>(
                future: _fetchWeeklyWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading indicator while waiting for weather data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Weather> dailyWeather = snapshot.data!['daily']!;
                    List<Weather> hourlyWeather = snapshot.data!['hourly']!;
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Aujourd\'hui',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: hourlyWeather.map((weather) {
                              String weatherImage = _getWeatherImage(weather.condition);
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: WeatherCard(
                                  currentWeather: weather,
                                  weatherImage: weatherImage,
                                  dateText: '${weather.date.hour}h',
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Prévisions hebdomadaires',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: dailyWeather.map((weather) {
                              String weatherImage = _getWeatherImage(weather.condition);
                              String dateText = _getDayOfWeek(weather.date);
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: WeatherCard(
                                  currentWeather: weather,
                                  weatherImage: weatherImage,
                                  dateText: dateText,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            if (favoriteCities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Villes favorites',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ...favoriteCities.map((city) {
                      return ListTile(
                        title: Text(city),
                        onTap: () {
                          setState(() {
                            cityName = city;
                            _fetchWeeklyWeather = _weeklyWeatherService.fetchWeeklyWeather(cityName);
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}