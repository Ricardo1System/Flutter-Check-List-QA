import 'dart:math';

class IdGenerator {
  static int generate() => Random().nextInt(0xFFFFFFFF);
}
