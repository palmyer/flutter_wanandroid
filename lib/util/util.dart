import 'dart:math';
import 'dart:ui';

Color getRandomColor({int a = 255, int r = 255, int g = 255, int b = 255}) {
  return Color.fromARGB(
      a,
      r != 255 ? r : Random.secure().nextInt(r),
      g != 255 ? r : Random.secure().nextInt(g),
      b != 255 ? r : Random.secure().nextInt(b));
}
