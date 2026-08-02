import 'package:flutter/material.dart';
import 'speed_numbers_screen.dart';

void main() {
  runApp(const SpeedNumbersApp());
}

class SpeedNumbersApp extends StatelessWidget {
  const SpeedNumbersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Numbers Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      ),
      home: const SpeedNumbersScreen(),
    );
  }
}
