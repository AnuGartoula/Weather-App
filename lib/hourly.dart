import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
   final IconData icon;
  final String label;
  final String value;

  const WeatherInfo({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
      return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}