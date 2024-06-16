import 'package:flutter/material.dart';
import 'package:weather_app_v2/models/Weather.dart';

class WeatherCard extends StatefulWidget {
  final Weather currentWeather;
  final String weatherImage;
  final String dateText;

  const WeatherCard({
    Key? key,
    required this.currentWeather,
    required this.weatherImage,
    required this.dateText,
  }) : super(key: key);

  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  bool isCelsius = true; // Track if the temperature is in Celsius or Fahrenheit

  double temperatureInFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  void toggleTemperatureType() {
    setState(() {
      isCelsius = !isCelsius; // Toggle the temperature type
    });
  }

  @override
  Widget build(BuildContext context) {
    final double currentTemperature = isCelsius
        ? widget.currentWeather.temperature
        : temperatureInFahrenheit(widget.currentWeather.temperature);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.dateText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '${currentTemperature.toStringAsFixed(0)} ${isCelsius ? '°C' : '°F'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: toggleTemperatureType,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Image.asset(
              widget.weatherImage,
              fit: BoxFit.cover,
              height: 40,
              width: 40,
            ),
            const SizedBox(height: 10),
            Text(
              'Condition: ${widget.currentWeather.condition}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              'Wind Speed: ${widget.currentWeather.windSpeed.toStringAsFixed(1)} km/h',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
