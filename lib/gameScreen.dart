import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snakeman/ghost.dart';
import 'dart:async';
import 'constants.dart';
import 'globals.dart';
import 'player.dart';
import 'fruit.dart';
import 'item.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //Board...später ersetzt durch images anstatt Farben( einzelne Sprites er Figuren)
  Player spieler = Player();
  Fruit fruit = Fruit();
  Item item = Item();

  //ermittlet welcher Button als LETZTES gedrückt wurde
  Input buttonInput;
  //Statistiken

  //vorläufige Variable, ermittelt ob das Spiel bereits gestarter wurde
  bool gameRunning = false;

  gameStart() {
    spieler.reset();
    fruit.setRndPosition();
    item.reset();
    ghosts.clear();
    ghosts.add(Ghost(true));
    score = 0;
    playTimer = 0;
    powerUp = '';
    update(spieler, fruit, item);
  }

  update(Player player, Fruit fruit, Item item) {
    Timer.periodic(Duration(milliseconds: kFrameDuration), (Timer timer) {
      setState(() {
        playTimer += kFrameDuration / 1000;
        if (item.itemAvailable) {
          item.setTimer();
        }
        //Vor der move()-Abfrage, da es dadurch den Effekt ergibt, dass die Figur sich im Tunnel befände
        player.checkCollisionWithTunnel();
        player.move(buttonInput);
        buttonInput = Input.none;
        ghosts.forEach((ghost) {
          if (ghost.active && !ghost.stunned) {
            ghost.move(player.body[0]);
          }
        });
        //checkCollision mit Fruit nach der move()-Abfrage, da dadurch die Frucht direkt wo anders erscheint und es es keinen Frame gibt, bei der man keine Frucht erkennen kann
        player.checkCollisionWithFruit(fruit);
        player.checkCollisionWithItem(item);
        if (player.checkCollisionWithObstacles() ||
            player.checkCollisionWithItself() ||
            player.checkCollisionWithGhosts()) {
          timer.cancel();
          gameRunning = false;
        }
        //Board(Liste) wird gelöscht, da es bei jedem neuen State wieder gesetzt wird

        board.clear();
        //Freier Platz wird gelöscht, da dieser sonst freien Speicher der Runde davor in die Liste mitaufnimmt
        freeSpace.clear();
      });
    });
  }

  initBoard() {
    //Von oben nach unten
    for (int index = 0; index < kY_Size * kX_Size; index++) {
      //Tunnelposition
      if (kTunnel.contains(index))
        board.add(kTunnelColor);
      //Spieler
      else if (ghostsHavePositionAt(index))
        board.add(kGhostColor);
      else if (spieler.position == index)
        board.add(kPlayerColor);
      //Spielerkörper
      else if (spieler.body.contains(index))
        board.add(kPlayerBodyColor);
      //Fruchtposition
      else if (fruit.position == index)
        board.add(kFruitColor);
      //OutsideWall
      else if (kWall.contains(index))
        board.add(kWallColor);
      //Hindernisse in er Map
      else if (kObstacles.contains(index))
        board.add(kWallColor);
      else if (item.position == index) {
        board.add(kItemColor);
      } else if (kItemSpawnPoints.contains(index))
        board.add(kItemSpawnPointColor);
      else if (kGhostStartPosition == index) {
        board.add(kBackGroundColor);
      } else {
        board.add(kBackGroundColor);
        freeSpace.add(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initBoard();

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            spielfeld(), //Visualisierung des Spielfeldes
            steuerung(), //Steuerung der Figur durch zwei Buttons
          ],
        ),
      ),
    );
  }

  steuerung() => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Linker Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (gameRunning == false) {
                  gameRunning = true;
                  gameStart();
                } else
                  buttonInput = Input.left;
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          //Rechter Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (gameRunning == false) {
                  gameRunning = true;
                  gameStart();
                } else
                  buttonInput = Input.right;
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      );
  spielfeld() => Column(
        children: <Widget>[
          //Items & Score
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            color: Colors.blueGrey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GameStatistik(
                  label: 'Time',
                  value: '${playTimer.round()}',
                ),
                GameStatistik(
                  label: 'Score',
                  value: '$score',
                ),
                GameStatistik(
                  label: 'PowerUp',
                  value: powerUp != ''
                      ? '$powerUp \n ($powerUpTimer)'
                      : 'Keine \n  ',
                ),
              ],
            ),
          ),
          //Spielfeld
          Expanded(
            child: GridView.builder(
              itemCount: kTotalItems,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kX_Size,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (context, i) => Container(
                decoration: BoxDecoration(
                  color: board[i],
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class GameStatistik extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;

  const GameStatistik({
    Key key,
    this.label,
    this.value,
    this.subValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}
