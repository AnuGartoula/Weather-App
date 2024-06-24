// import 'package:flutter/material.dart';
// import 'package:weather/weather_model.dart';
// import 'package:weather/weather_service.dart';

// class MyHomepage extends StatefulWidget {
//   const MyHomepage({super.key});

//   @override
//   State<MyHomepage> createState() => _MyHomepageState();
// }

// class _MyHomepageState extends State<MyHomepage> {
// //api key fetch
//   final _weatherService = WeatherService("027b8442d999d0232935f50bfdd6df33");
//   Weather? _weather;

//   _fetchWeather() async {
//     String cityName = await _weatherService.getCurrentCity();

//     try {
//       final weather = await _weatherService.getWeather(cityName);
//       setState(() {
//         _weather = weather;
//       });
//     } catch (e) {
//       (e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(_weather?.cityName ?? "Loading city..."),
//           Text("${_weather?.temperature.round()} °C")
//         ],
//       ),
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  String? _errorMessage;
  bool _isLoading = true;

  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load weather data";
        _isLoading = false;
      });
      ('Error fetching weather data: $e');
    }
  }

  String getweatheranimation(String? maincondition) {
    if (maincondition == null) return 'asset/sun.json';
    switch (maincondition.toLowerCase()) {
      case 'clouds':
      case 'wind':
      case 'smoke':
      case 'fog':
      case 'mist':
      case 'haze':
        return 'assets/cloud.json';
      case 'rain':
      case 'thunderstrom':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'drizzle':
        return 'assets/drizzle.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 66, 76, 90)),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _errorMessage != null
                  ? Text(_errorMessage!)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                            getweatheranimation(_weather?.mainCondition)),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          _weather?.cityName ?? "Unknown City",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          "${_weather?.temperature.round()}°C",   //Rounds away from zero when there is no closest integer i.e 3.5 = 4
                          style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _weather?.mainCondition ?? "Unknown Condition",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
