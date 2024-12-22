class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final DateTime sunset;
  final double windSpeed;
  final int humidity;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.sunset,
    required this.windSpeed,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'], // Mapping JSON to cityName
      temperature: json['main']['temp'].toDouble(), // Temperature in Kelvin
      mainCondition: json['weather'][0]['main'], // Weather condition
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000,
          isUtc: true), // Convert UNIX to DateTime
      windSpeed: json['wind']['speed'].toDouble(), // Wind speed in m/s
      humidity: json['main']['humidity'] ?? '0', // Humidity in percentage
    );
  }

  get sunsetTimestamp => null;

  @override
  String toString() {
    return 'Weather(cityName: $cityName, temperature: $temperature, mainCondition: $mainCondition, sunset: $sunset, windSpeed: $windSpeed, humidity: $humidity)';
  }
  
}

