import 'package:flutter/material.dart';

//PlayfieldSizing
const int kX_Size = 19;
const int kY_Size = 13;
const int kTotalItems = kX_Size * kY_Size;

//Player
const int kStartPosition = 172;
const kStartPositionBody = 191;
const kMaxBodySize = 7; //ganzer Körper = 8, wenn er kleiner wird
//Ghost
const int kGhostStartPosition = 123;

//Farben der Spielelemente
const Color kTunnelColor = Colors.green;
const Color kBackGroundColor = Colors.grey;
const Color kWallColor = Colors.blueGrey;
const Color kObstaclesColor = Color(0xFF455A64);
const Color kPlayerColor = Colors.yellow;
const Color kPlayerBodyColor = Colors.yellowAccent;
const Color kFruitColor = Colors.red;
const Color kItemSpawnPointColor = kBackGroundColor;
const Color kItemColor = Colors.pinkAccent;
const Color kGhostColor = Colors.deepPurpleAccent;

//Framerate/ Refreshrate in ms
const kFrameDuration = 400;
//in seconds
const kDurationPowerUp = 10;
const kItemSpawnTimer = 10;
const kGhostRespawnTimer = 10;

//MagnetRadius
const kMagnetRadius = 2;
//GhostEaten
const kGhostEatenPoints = 10;

//Blickrichtungen für Spieler und Gegner
enum Orientation {
  up,
  down,
  left,
  right,
}
enum Input {
  left,
  right,
  none,
}

enum ItemPower {
  //good
  collisionFree,
  ghostEater,
  magnet,
  stunnedGhosts,
  //bad
  invincibleGhosts,
}

//SpielfeldUmrandungen
const List<int> kObstacles = <int>[
  40,
  24,
  43,
  45,
  46,
  48,
  49,
  32,
  51,
  54,
  192,
  206,
  108,
  127,
  146,
  109,
  128,
  147,
  122,
  124,
  141,
  142,
  143,
  138,
  137,
  119,
  118,
  100,
  99,
  199,
  196,
  215,
  202,
  221,
];

const List<int> kTunnel = <int>[
  114,
  132,
];

const List<int> kItemSpawnPoints = <int>[20, 36, 210, 226];

const List<int> kWall = <int>[
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  37,
  38,
  56,
  57,
  75,
  76,
  94,
  95,
  113,
  133,
  151,
  152,
  170,
  171,
  189,
  190,
  208,
  209,
  227,
  228,
  229,
  230,
  231,
  232,
  233,
  234,
  235,
  236,
  237,
  238,
  239,
  240,
  241,
  242,
  243,
  244,
  245,
  246,
];
