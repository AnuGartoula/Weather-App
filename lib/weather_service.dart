// import 'dart:convert';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:weather/weather_model.dart';
// // import 'package:permission_handler/permission_handler.dart';

// class WeatherService {
//   static const BASE_URL =
//       "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}";
//   final String apiKey;

//   WeatherService(this.apiKey);

//   Future<Weather> getWeather(String cityName) async {
//     final response = await http
//         .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

//     if (response.statusCode == 200) {
//       return Weather.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception("failed to load weather data");
//     }
//   }

// // get the current location and ask for the permission from the user
//   Future<String> getCurrentCity() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     // fetch the current location

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // covert the location into a list of placemark objects

//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     String? city = placemarks[0].locality;

//     return city ?? "";
//   }
// }

// // Future<void> checkPermission(Permission permission) async {
// //   final status = await permission.request();
// //   if (status.isGranted){
// //     ScaffoldMessenger.of().showSnackBar(SnackBar(content: Text("Permission is granted")));
// //   }
// //   else{

// //   }
// // }
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather_model.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    ('Requesting weather data from: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      ('Weather data received: ${response.body}');
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      (
          'Failed to load weather data. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied, we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permissions are denied.");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    ('Current position: ${position.latitude}, ${position.longitude}');

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks[0].locality;
    ('Detected city: $city');

    return city ?? "";
  }
}
