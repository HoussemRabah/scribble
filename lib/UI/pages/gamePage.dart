import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/bloc/game/game_bloc.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/constants.dart';
import 'package:scribble/module/message.dart';
import 'package:scribble/module/player.dart';

import 'home.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

GameBloc gameBloc = GameBloc();
TextEditingController? _controller = TextEditingController();

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: gameBloc..add(GameEventInit())),
        BlocProvider.value(value: roomBloc)
      ],
      child: Scaffold(
        backgroundColor: colorBack,
        body: Column(children: [HighBar(), CentrePage(), ButtomBar()]),
      ),
    );
  }
}

class ButtomBar extends StatelessWidget {
  const ButtomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE5E5E5),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.remove),
          Icon(Icons.arrow_left),
          Icon(Icons.architecture_sharp),
          Icon(Icons.color_lens),
          Icon(Icons.add),
        ],
      ),
    );
  }
}

class CentrePage extends StatelessWidget {
  const CentrePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<RoomBloc, RoomState>(
              builder: (context, state) {
                return Container(
                  width: 60,
                  height: MediaQuery.of(context).size.height - 30 - 60,
                  color: Color(0xFFE5E5E5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (Player player in roomBloc.players)
                          PlayerContainer(player: player),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: Color(0xFFE5E5E5),
              width:
                  (gameBloc.expanded && gameBloc.currentWord != "") ? 200 : 0,
              height: MediaQuery.of(context).size.height - 90,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 90 - 60,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (Message message in gameBloc.messages)
                            if (gameBloc.expanded) MessageBox(message: message)
                        ],
                      ),
                    ),
                  ),
                  if (!gameBloc.myTurn)
                    Container(
                      color: Colors.white,
                      height: 60,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (word) {
                          gameBloc..add(GameEventSendMessage(word: word));
                          _controller!.text = "";
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "write your reponse here..."),
                      ),
                    )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                gameBloc..add(GameEventExpand());
              },
              child: Container(
                height: 80,
                color: Color(0xFFE5E5E5),
                child: Icon(Icons.arrow_right),
              ),
            ),
            if (!gameBloc.expanded &&
                gameBloc.myTurn &&
                gameBloc.currentWord == "")
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: MediaQuery.of(context).size.width - 60 - 8.0 - 8.0 - 50,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                color: Color(0xFFE5E5E5),
                child: Column(
                  children: [
                    Text(
                      "CHOOSE A WORD",
                      style: textStyleBig,
                    ),
                    for (Object? word in gameBloc.listOfWords)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 8.0),
                        child: Button(
                            text: word.toString(),
                            function: () {
                              gameBloc
                                ..add(GameEventThisWord(word: word.toString()));
                            }),
                      ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

class PlayerContainer extends StatelessWidget {
  const PlayerContainer({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Container(
          color: (roomBloc.players[gameBloc.currentPlayer].id == player.id)
              ? Colors.blueAccent
              : Colors.transparent,
          child: Column(
            children: [
              Text(
                numberFormat(player.totalScore),
                style: textStyleError,
              ),
              SvgPicture.asset(
                player.avatar,
                theme: SvgTheme(currentColor: Colors.white),
                fit: BoxFit.fitWidth,
                width: 50,
              ),
              Text(
                player.name,
                style: textStyleError,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MessageBox extends StatelessWidget {
  const MessageBox({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorFront,
      padding: EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text(
            message.username,
            style: textStyleError,
          ),
          Text(
            message.content,
            style: textStyleSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class HighBar extends StatelessWidget {
  const HighBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Container(
          height: 30,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "round ${gameBloc.currentRound}",
                    style: textStyleSmall.copyWith(color: Colors.black),
                  ),
                ),
                Icon(Icons.home),
                Container(
                  child: Text(
                    "round 1",
                    style: textStyleSmall.copyWith(color: Colors.black),
                  ),
                )
              ]),
        );
      },
    );
  }
}

String numberFormat(int i) {
  if (i < 10) return '00$i';
  if (i < 100) return '0$i';
  return '$i';
}
