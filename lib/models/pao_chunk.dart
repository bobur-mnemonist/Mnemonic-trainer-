import 'dart:math';

class PAOChunk {
  final String fullNumber;
  final String person;
  final String action;
  final String object;

  PAOChunk({required this.fullNumber})
      : assert(fullNumber.length == 6, 'Raqam 6 xonali bo\'lishi kerak'),
        person = fullNumber.substring(0, 2),
        action = fullNumber.substring(2, 4),
        object = fullNumber.substring(4, 6);

  /// Tasodifiy 6 xonali PAO raqamini generatsiya qilish
  factory PAOChunk.generateRandom() {
    final random = Random();
    String digits = '';
    for (int i = 0; i < 6; i++) {
      digits += random.nextInt(10).toString();
    }
    return PAOChunk(fullNumber: digits);
  }
}
