import 'globals.dart';
import 'dart:math';

class Fruit {
  int position;

  Fruit();

  setRndPosition() {
    var rnd = Random();
    int r = rnd.nextInt(freeSpace.length);
    position = freeSpace[r];
  }
}
