import 'package:intl/intl.dart';

void main() {
  // Simulated JSON response
  Map<String, dynamic> json = {
    'sys': {'sunset': 1726680975} // Example Unix timestamp
  };

  // Extract sunset timestamp
  int sunsetTimestamp = json['sys']['sunset'];

  // Convert to DateTime object
  DateTime sunsetTime =
      DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000, isUtc: true);

  // Convert to local time
  DateTime localSunsetTime = sunsetTime.toLocal();

  // Format the time
  String formattedSunset = DateFormat('hh:mm a').format(localSunsetTime);

  // Print result
  print('Sunset time: $formattedSunset'); // e.g., "06:45 PM"
}
