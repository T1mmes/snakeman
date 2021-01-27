import 'package:flutter/material.dart';

import 'constants.dart';
import 'ghost.dart';

//Statistiks
int score = 0;
double playTimer = 0;
String powerUp = '';
int powerUpTimer;

//Listen
List<int> freeSpace = <int>[];
List<Color> board = <Color>[];
List<Ghost> ghosts = <Ghost>[
  Ghost(true),
];

//Funktionen
bool ghostsHavePositionAt(int position) {
  for (int i = 0; i < ghosts.length; i++) {
    if (ghosts[i].position == position && !ghosts[i].invincible) return true;
  }
  return false;
}

int distanceToObjects(int position1, int position2) {
  int playerX = position1 % kX_Size; //gibt horizontale position an
  int playerY = (position1 / kX_Size).round(); //vertical
  int objectX = position2 % kX_Size;
  int objectY = (position2 / kX_Size).round();

  return (playerX - objectX).abs() + (playerY - objectY).abs();
}
