import 'dart:math';

class TokenGenerator {
  static int generateToken() {
    Random random = Random();
    int min = 100000000;
    int max = 999999999;
    return min + random.nextInt(max - min);
  }
}