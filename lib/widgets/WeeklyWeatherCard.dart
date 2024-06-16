import 'package:flutter/material.dart';
import 'package:weather_app_v2/models/Weather.dart';

class WeeklyWeatherCard extends StatefulWidget {
  final Weather weather;

  const WeeklyWeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  _WeeklyWeatherCardState createState() => _WeeklyWeatherCardState();
}

class _WeeklyWeatherCardState extends State<WeeklyWeatherCard> {
  bool isCelsius = true; // État pour suivre si la température est en Celsius ou en Fahrenheit
  bool isFavorite = false; // État pour suivre si la ville est en favori

  void toggleTemperatureType() {
    setState(() {
      isCelsius = !isCelsius; // Inverser l'état
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Inverser l'état
    });
  }

  double convertTemperature(double celsius) {
    if (isCelsius) {
      return celsius;
    } else {
      return (celsius * 9 / 5) + 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    double temperature = convertTemperature(widget.weather.temperature);
    String temperatureUnit = isCelsius ? '°C' : '°F';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.weather.cityName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.white),
                      onPressed: toggleFavorite,
                    ),
                    Text(
                      '${temperature.toStringAsFixed(1)} $temperatureUnit', // Arrondir à un chiffre après la virgule
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.swap_horiz),
                      onPressed: toggleTemperatureType,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Condition: ${widget.weather.condition}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              'Wind Speed: ${widget.weather.windSpeed} km/h',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}