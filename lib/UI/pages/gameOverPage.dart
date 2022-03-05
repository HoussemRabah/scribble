import 'package:flutter/material.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/constants.dart';
import 'package:scribble/module/player.dart';

import 'home.dart';

class GameOverPage extends StatelessWidget {
  final List<Player> players;
  const GameOverPage({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    players.sort((a, b) => a.totalScore.compareTo(b.totalScore));
    return Scaffold(
      backgroundColor: colorBack,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (Player player in players)
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      player.name,
                      style: textStyleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      player.totalScore.toString(),
                      style: textStyleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            Button(
                text: 'return',
                function: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
                })
          ],
        ),
      ),
    );
  }
}
