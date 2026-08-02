import 'package:flutter/material.dart';
import 'screens/pao_trainer_screen.dart';

void main() {
  runApp(const PAOTrainerApp());
}

class PAOTrainerApp extends StatelessWidget {
  const PAOTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'PAO Mnemonic Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      ),
      home: const PAOTrainerScreen(),
    );
  }
}
