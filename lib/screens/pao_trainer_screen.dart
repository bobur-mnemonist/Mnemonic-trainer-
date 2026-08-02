import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pao_chunk.dart';

class PAOTrainerScreen extends StatefulWidget {
  const PAOTrainerScreen({super.key});

  @override
  State<PAOTrainerScreen> createState() => _PAOTrainerScreenState();
}

class _PAOTrainerScreenState extends State<PAOTrainerScreen> {
  late PAOChunk _currentChunk;
  bool _showBreakdown = false;
  int _millisecondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateNextChunk();
  }

  void _startTimer() {
    _timer?.cancel();
    _millisecondsElapsed = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _millisecondsElapsed += 10;
      });
    });
  }

  void _generateNextChunk() {
    setState(() {
      _currentChunk = PAOChunk.generateRandom();
      _showBreakdown = false;
    });
    _startTimer();
  }

  void _toggleBreakdown() {
    setState(() {
      _showBreakdown = !_showBreakdown;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = (_millisecondsElapsed / 1000).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('PAO Speed Trainer'),
        backgroundColor: const Color(0xFF2D2D44),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Taymer Ko'rsatkichi
            Text(
              '⏱️ $seconds soniya',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
            const SizedBox(height: 40),

            // Asosiy 6 Xonali Raqam
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Text(
                _currentChunk.fullNumber,
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // PAO Bo'limlari (Inson, Harakat, Obyekt)
            if (_showBreakdown)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPAOCard('Inson', _currentChunk.person, Colors.blueAccent),
                  _buildPAOCard('Harakat', _currentChunk.action, Colors.greenAccent),
                  _buildPAOCard('Obyekt', _currentChunk.object, Colors.orangeAccent),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: _toggleBreakdown,
                icon: const Icon(Icons.visibility),
                label: const Text('PAO Ajratishni Ko\'rish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),

            const SizedBox(height: 50),

            // Keyingi Raqam Tugmasi
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _generateNextChunk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Keyingi Raqam ➔',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPAOCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252538),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
