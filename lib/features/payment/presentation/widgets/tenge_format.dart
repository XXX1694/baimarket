String _groupThousands(String digits) {
  final buf = StringBuffer();
  int count = 0;
  for (int i = digits.length - 1; i >= 0; i--) {
    buf.write(digits[i]);
    count++;
    if (count == 3 && i != 0) {
      buf.write(' ');
      count = 0;
    }
  }
  return buf.toString().split('').reversed.join();
}

/// 46793 -> "46 793,00₸"
String formatTengeWithKopecks(int value) {
  final s = _groupThousands(value.toString());
  return '$s,00₸';
}

/// 46793 -> "46 793₸"
String formatTenge(int value) => '${_groupThousands(value.toString())}₸';
