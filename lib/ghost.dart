import 'dart:async';
import 'dart:math';
import 'package:snakeman/globals.dart';

import 'constants.dart';

class Ghost {
  int position;
  var orientation;
  bool active;
  bool invincible;
  bool stunned;

  Ghost(this.active) {
    position = kGhostStartPosition;
    orientation = Orientation.up;
    invincible = false;
    stunned = false;
  }

  _moveForward() {
    switch (this.orientation) {
      case (Orientation.up):
        {
          position -= kX_Size;
        }
        break;
      case (Orientation.down):
        {
          position += kX_Size;
        }
        break;
      case (Orientation.left):
        {
          position -= 1;
        }
        break;
      case (Orientation.right):
        {
          position += 1;
        }
        break;
    }
  }

  _chanceToSetRandomOrientation(int positionPlayer) {
    //sonst frust falls der Geist sich in dich dreht
    if (distanceToObjects(this.position, positionPlayer) >= 9) {
      Random rnd = Random();
      if (rnd.nextInt(5) == 1) {
        _turn();
      }
    }
  }

  _turn() {
    Random rnd = Random();
    if (rnd.nextInt(2) == 1) {
      //dreht sich nach links
      switch (this.orientation) {
        case (Orientation.down):
          {
            this.orientation = Orientation.right;
          }
          break;
        case (Orientation.right):
          {
            this.orientation = Orientation.up;
          }
          break;
        case (Orientation.up):
          {
            this.orientation = Orientation.left;
          }
          break;
        case (Orientation.left):
          {
            this.orientation = Orientation.down;
          }
          break;
      }
    } else {
      // dreht sich nach rechts
      switch (this.orientation) {
        case (Orientation.down):
          {
            this.orientation = Orientation.left;
          }
          break;
        case (Orientation.right):
          {
            this.orientation = Orientation.down;
          }
          break;
        case (Orientation.up):
          {
            this.orientation = Orientation.right;
          }
          break;
        case (Orientation.left):
          {
            this.orientation = Orientation.up;
          }
          break;
      }
    }
  }

  bool _collisionWithWallAndObstacles() {
    if (kObstacles.contains(this.position) ||
        kWall.contains(this.position) ||
        kTunnel.contains(this.position))
      return true;
    else
      return false;
  }

  move(int positionPlayer) {
    int startPosition = this.position;
    _chanceToSetRandomOrientation(positionPlayer);
    _moveForward();
    while (_collisionWithWallAndObstacles()) {
      this.position = startPosition;
      _turn();
      _moveForward();
    }
  }

  resetGhost() {
    position = kGhostStartPosition;
    orientation = Orientation.up;
    invincible = false;
    stunned = false;
    active = false;
    Timer(Duration(seconds: kGhostRespawnTimer), () {
      active = true;
    });
  }
}
