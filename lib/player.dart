import 'dart:async';

import 'constants.dart';
import 'globals.dart';
import 'fruit.dart';
import 'item.dart';
import 'ghost.dart';

class Player {
  int position;
  int bodyIndex;
  var body = List<int>(kMaxBodySize);
  var orientation;

  //PowerUps
  bool collisionFree;
  bool gotMagnet;
  bool ghostEater;

  //Konstruktor mit Startposition
  Player() {
    this.position = kStartPosition;
    this.orientation = Orientation.up;
    this.body[0] = kStartPositionBody;
    this.collisionFree = false;
    this.ghostEater = false;
    this.gotMagnet = false;
    bodyIndex = 1;
  }
  reset() {
    this.position = kStartPosition;
    this.orientation = Orientation.up;
    this.body[0] = kStartPositionBody;
    this.collisionFree = false;
    this.ghostEater = false;
    this.gotMagnet = false;
    bodyIndex = 1;
    for (int i = 1; i < body.length; i++) {
      body[i] = -1;
    }
  }

  //BewegungsFunktionen( privat)
  //Ermittlung der Eingabe der Buttons und dementsprechend Veränderung der Blickrichtung
  _setOrientation(Input input) {
    if (input == Input.left) {
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
    } else if (input == Input.right) {
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

  //Die Figur wird entsprechend seiner Orientierung verschoben
  _moveHeadForward() {
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

  _moveBodyForward() {
    for (int i = bodyIndex - 1; i > 0; i--) {
      body[i] = body[i - 1];
    }
    body[0] = position;
  }

  //Kombiniere obige Funktionen
  move(Input input) {
    _setOrientation(input);
    _moveBodyForward();
    _moveHeadForward();
  }

  increaseBody() {
    bodyIndex++;
    if (bodyIndex > kMaxBodySize) {
      bodyIndex = 1;
      for (int i = 1; i < kMaxBodySize; i++) {
        body[i] = -1;
      }
      ghosts.add(Ghost(true));
    }
  }

  //Kollisionsabfragen mit anderen Objekten
  checkCollision() {}

  checkCollisionWithFruit(Fruit fruit) {
    if (this.position == fruit.position ||
        (this.gotMagnet &&
            distanceToObjects(this.position, fruit.position) <=
                kMagnetRadius)) {
      increaseBody();
      fruit.setRndPosition();
      score += body.length * ghosts.length;
    }
  }

  checkCollisionWithTunnel() {
    if (this.position == kTunnel[0])
      this.position = kTunnel[1];
    else if (this.position == kTunnel[1]) this.position = kTunnel[0];
  }

  checkCollisionWithItem(Item item) {
    if (this.position == item.position) {
      //Item wird zurückgesetzt
      item.position = -1;
      item.setTimer();
      //itemPower wird ausgewählt
      switch (item.setRndItem()) {
        case ItemPower.collisionFree:
          {
            this.collisionFree = true;
            powerUp = 'Ghost';
            _setPowerUpTimer(10, () {
              this.collisionFree = false;
            });
          }
          break;
        case ItemPower.ghostEater:
          {
            powerUp = 'GhostEater';
            this.ghostEater = true;
            _setPowerUpTimer(10, () {
              this.ghostEater = false;
            });
          }
          break;
        case ItemPower.magnet:
          {
            powerUp = 'Magnet';
            this.gotMagnet = true;
            _setPowerUpTimer(10, () {
              this.gotMagnet = false;
            });
          }
          break;

        case ItemPower.stunnedGhosts:
          {
            powerUp = 'Stun';
            ghosts.forEach((ghost) {
              if (ghost.active) {
                ghost.stunned = true;
              }
            });
            _setPowerUpTimer(10, () {
              ghosts.forEach((ghost) {
                if (ghost.active) {
                  ghost.stunned = false;
                }
              });
            });
          }
          break;
        case ItemPower.invincibleGhosts:
          {
            powerUp = 'Invincible';
            ghosts.forEach((ghost) {
              if (ghost.active) {
                ghost.invincible = true;
              }
            });
            _setPowerUpTimer(5, () {
              ghosts.forEach((ghost) {
                if (ghost.active) {
                  ghost.invincible = false;
                }
              });
            });
          }
          break;
      }
    }
  }

  bool checkCollisionWithObstacles() {
    if (kWall.contains(this.position) ||
        (kObstacles.contains(this.position) && !this.collisionFree))
      return true;
    else
      return false;
  }

  bool checkCollisionWithItself() {
    return this.body.contains(this.position) && !this.collisionFree;
  }

  bool checkCollisionWithGhosts() {
    for (int i = 0; i < ghosts.length; i++) {
      //Wenn der Geist aktiv ist und es eine Kollision gibt
      if (ghosts[i].active &&
          (this.position == ghosts[i].position ||
              this.body.contains(ghosts[i].position))) {
        if (this.ghostEater) {
          score += kGhostEatenPoints;
          ghosts[i].resetGhost();
        } else {
          return true;
        }
      }
    }
    return false;
  }

  _setPowerUpTimer(int duration, Function f) {
    powerUpTimer = duration;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      powerUpTimer--;
      if (powerUpTimer <= 0) {
        timer.cancel();
        powerUp = '';
        f();
      }
    });
  }
}
