import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/hourly_model.dart';

import 'weather_model.dart';

class WeatherService {
  // Base URL for OpenWeather API
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  // Fetch weather data for a given city
  Future<Weather> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    print('Requesting weather data from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 404) {
        throw Exception("City not found");
      } else if (response.statusCode == 401) {
        throw Exception("Invalid API key");
      } else if (response.statusCode == 200) {
        print('Weather data received: ${response.body}');
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load weather data. Status: ${response.statusCode}');
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception("An error occurred while loading weather data");
    }
  }

  // Get the current city name using location services
  // Future<String> getCurrentCity() async {
  //   try {
  //     // Check and request location permissions
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       return "Unknown"; // Return default value if permissions are denied
  //     }

  //     // Get current location
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     // Get city name using geocoding
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       String? city =
  //           placemarks.first.locality ?? placemarks.first.administrativeArea;
  //       return city ?? "Unknown"; // Return "Unknown" if city is null
  //     } else {
  //       return "Unknown";
  //     }
  //   } catch (e) {
  //     print("Error fetching current city: $e");
  //     return "Unknown"; // Return "Unknown" if an error occurs
  //   }
  // }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final url = '$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    print('Requesting weather data from: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            "Failed to load weather data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception("An error occurred while loading weather data.");
    }
  }

  getCurrentCity() {}

  // Future<List<HourlyWeather>> getHourlyWeather(double lat, double lon) async {
  //   const url =
  //       "https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}";
  //   print("Requesting hourly weather from: $url");

  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     print("API Response: ${response.body}");
  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       final List<dynamic> hourlyData =
  //           json['forecast']['forecastday'][0]['hour'];
  //       return hourlyData.map((data) => HourlyWeather.fromJson(data)).toList();
  //     } else {
  //       throw Exception("Failed to load hourly weather data");
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     throw Exception("An error occurred while fetching hourly weather data");
  //   }
  // }
}
