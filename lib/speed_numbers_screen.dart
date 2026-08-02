import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum TrainingPhase { memorization, recall, result }

class SpeedNumbersScreen extends StatefulWidget {
  const SpeedNumbersScreen({super.key});

  @override
  State<SpeedNumbersScreen> createState() => _SpeedNumbersScreenState();
}

class _SpeedNumbersScreenState extends State<SpeedNumbersScreen> {
  final int _rowsCount = 10;
  final int _digitsPerRow = 40;

  List<String> _generatedDigits = [];
  List<String> _userInputs = [];

  TrainingPhase _currentPhase = TrainingPhase.memorization;
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    _timer?.cancel();
    final random = Random();
    List<String> digits = [];
    for (int i = 0; i < _rowsCount * _digitsPerRow; i++) {
      digits.add(random.nextInt(10).toString());
    }

    setState(() {
      _generatedDigits = digits;
      _userInputs = List.filled(_rowsCount * _digitsPerRow, '');
      _currentPhase = TrainingPhase.memorization;
      _secondsElapsed = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _goToRecallPhase() {
    _timer?.cancel();
    setState(() {
      _currentPhase = TrainingPhase.recall;
    });
  }

  void _calculateResult() {
    setState(() {
      _currentPhase = TrainingPhase.result;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Numbers (400 Raqam)'),
        backgroundColor: const Color(0xFF2D2D44),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewSession,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildPhaseView(),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');

    String phaseText = '';
    if (_currentPhase == TrainingPhase.memorization) {
      phaseText = '🧠 Eslab Qolish Fazasi';
    } else if (_currentPhase == TrainingPhase.recall) {
      phaseText = '✍️ Kiritish Fazasi';
    } else {
      phaseText = '📊 Natija';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF252538),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            phaseText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '⏱️ $minutes:$seconds',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amberAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseView() {
    if (_currentPhase == TrainingPhase.memorization) {
      return _buildMemorizationGrid();
    } else if (_currentPhase == TrainingPhase.recall) {
      return _buildRecallGrid();
    } else {
      return _buildResultGrid();
    }
  }

  Widget _buildMemorizationGrid() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _rowsCount,
      itemBuilder: (context, rowIndex) {
        final rowDigits = _generatedDigits.sublist(
          rowIndex * _digitsPerRow,
          (rowIndex + 1) * _digitsPerRow,
        );
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D44),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '${rowIndex + 1}.',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: List.generate(rowDigits.length, (i) {
                    return Text(
                      rowDigits[i],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (i % 6 < 2)
                            ? Colors.lightBlueAccent // Inson
                            : (i % 6 < 4)
                                ? Colors.lightGreenAccent // Harakat
                                : Colors.orangeAccent, // Obyekt
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecallGrid() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _rowsCount,
      itemBuilder: (context, rowIndex) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D44),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '${rowIndex + 1}.',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 16),
                  maxLength: _digitsPerRow,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '40 ta raqamni kiriting...',
                    hintStyle: TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    for (int i = 0; i < _digitsPerRow; i++) {
                      int globalIndex = rowIndex * _digitsPerRow + i;
                      if (i < val.length) {
                        _userInputs[globalIndex] = val[i];
                      } else {
                        _userInputs[globalIndex] = '';
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultGrid() {
    int correctCount = 0;
    for (int i = 0; i < _generatedDigits.length; i++) {
      if (_userInputs[i] == _generatedDigits[i]) {
        correctCount++;
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'To\'g\'ri topildi: $correctCount / ${_generatedDigits.length}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _rowsCount,
            itemBuilder: (context, rowIndex) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qator ${rowIndex + 1}:', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: List.generate(_digitsPerRow, (i) {
                        int idx = rowIndex * _digitsPerRow + i;
                        bool isCorrect = _userInputs[idx] == _generatedDigits[idx];
                        return Text(
                          _generatedDigits[idx],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    String btnText = '';
    VoidCallback? onPressed;

    if (_currentPhase == TrainingPhase.memorization) {
      btnText = 'Kiritishga O\'tish (Recall) ➔';
      onPressed = _goToRecallPhase;
    } else if (_currentPhase == TrainingPhase.recall) {
      btnText = 'Tekshirish ✅';
      onPressed = _calculateResult;
    } else {
      btnText = 'Yangi O\'yin (400 Raqam) 🔄';
      onPressed = _startNewSession;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigoAccent,
          padding: const EdgeInsets.vertical: 16,
        ),
        child: Text(btnText, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
s
