import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/hourly.dart';
import 'package:weather/weather_model.dart';
import 'package:weather/weather_service.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final _weatherService = WeatherService("027b8442d999d0232935f50bfdd6df33");
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load weather data. Please try again.";
        _isLoading = false;
      });
      print("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 12, 55, 66),
              Color.fromARGB(255, 74, 134, 148),
            ],
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : _errorMessage != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 50),
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : _weather != null
                      ? WeatherDisplay(weather: _weather!)
                      : const Text(
                          "No weather data available",
                          style: TextStyle(color: Colors.white),
                        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  String getWeatherAnimation(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }

  String formatSunsetTime(DateTime sunsetTime) {
    return DateFormat('hh:mm a').format(sunsetTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(getWeatherAnimation(weather.mainCondition), height: 150),
        const SizedBox(height: 20),
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "${weather.temperature.round()}°C",
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          weather.mainCondition,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 80),
        // Weather info row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherInfo(
                icon: Icons.sunny,
                label: "SUNSET",
                value: formatSunsetTime(weather.sunset),
              ),
              WeatherInfo(
                icon: Icons.air,
                label: "WIND",
                value: "${weather.windSpeed}km/h",
              ),
              WeatherInfo(
                icon: Icons.water_drop,
                label: "HUMIDITY",
                value: "${weather.humidity}%",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
