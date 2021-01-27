import 'package:flutter/material.dart';
import 'package:snakeman/gameScreen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade400, Colors.deepPurpleAccent],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'SNAKE-MAN',
                style: TextStyle(
                  fontSize: 100,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              RoundedMenuButton(
                text: 'START',
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(),
                    ),
                  );
                },
              ),
              RoundedMenuButton(
                text: 'Highscores',
              ),
              RoundedMenuButton(
                text: 'OPTIONS',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedMenuButton extends StatelessWidget {
  final String text;
  final Function onPress;

  const RoundedMenuButton({
    Key key,
    this.text,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
