import 'dart:math';
import 'dart:async';
import 'package:snakeman/constants.dart';
import 'package:snakeman/globals.dart';

class Item {
  int position;
  bool itemAvailable;

  ItemPower itemPower;

  Item() {
    this.position = -1;
    itemAvailable = true;
  }

  reset() {
    this.position = -1;
    itemAvailable = true;
  }

  setTimer() {
    itemAvailable = false;

    Timer(Duration(seconds: kItemSpawnTimer), () {
      if (playTimer >= 10) //Wegen dem Reset
        _setRndPosition();
    });
  }

  _setRndPosition() {
    var rnd = Random();
    int r = rnd.nextInt(4);
    position = kItemSpawnPoints[r];
  }

  ItemPower setRndItem() {
    var rnd = Random();
    int r = rnd.nextInt(5);
    switch (r) {
      case 0:
        {
          this.itemPower = ItemPower.collisionFree;
        }
        break;

      case 1:
        {
          this.itemPower = ItemPower.ghostEater;
        }
        break;
      case 2:
        {
          this.itemPower = ItemPower.magnet;
        }
        break;

      case 3:
        {
          this.itemPower = ItemPower.stunnedGhosts;
        }
        break;
      case 4:
        {
          this.itemPower = ItemPower.invincibleGhosts;
        }
        break;
    }
    return this.itemPower;
  }
}
