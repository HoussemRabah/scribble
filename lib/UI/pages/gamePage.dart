import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:painter2/painter2.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/bloc/game/game_bloc.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/constants.dart';
import 'package:scribble/module/Draw.dart';
import 'package:scribble/module/message.dart';
import 'package:scribble/module/player.dart';

import 'home.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

Color color = Colors.black;

GameBloc gameBloc = GameBloc();
TextEditingController? _controller = TextEditingController();

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: gameBloc..add(GameEventInit(context))),
        BlocProvider.value(value: roomBloc)
      ],
      child: Scaffold(
        backgroundColor: colorBack,
        body: Stack(children: [
          GestureDetector(
            onPanStart: (e) {
              if (gameBloc.myTurn)
                gameBloc.draw.addDraw([e.globalPosition], color);
            },
            onPanUpdate: (e) {
              if (gameBloc.myTurn) gameBloc.draw.updateDraw(e.globalPosition);
            },
            onPanEnd: (e) {
              if (gameBloc.myTurn) gameBloc..add(GameEventPaintChange());
            },
            child: BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height - 30),
                  painter: Painter(gameBloc.draw),
                  willChange: true,
                );
              },
            ),
          ),
          Column(children: [HighBar(), CentrePage(), ButtomBar()])
        ]),
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
          GestureDetector(
              onTap: () {
                if (gameBloc.myTurn) gameBloc.draw.removeDraw();
              },
              child: Icon(Icons.remove)),
          GestureDetector(
              onTap: () {
                if (gameBloc.myTurn) gameBloc.draw.undoDraw();
              },
              child: Icon(Icons.arrow_left)),
          Icon(Icons.architecture_sharp),
          GestureDetector(
              onTap: () {
                if (gameBloc.myTurn) {}
                ;
              },
              child: Icon(Icons.color_lens)),
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
                            if (gameBloc.expanded)
                              if (!(state is GameStateLoading))
                                MessageBox(message: message),
                          if ((state is GameStateLoading))
                            Text("We have Wiiiineeeer !\n next round in 7s"),
                          if ((state is GameStateLoading) &&
                              (gameBloc.winner != ""))
                            Text("${gameBloc.winner} won ! "),
                          if (state is GameStateLoading)
                            Text("the word was ${gameBloc.lastCurrentWord}"),
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
                if (gameBloc.beginTime != null)
                  Container(child: new Counter(time: gameBloc.beginTime!)),
                if (gameBloc.beginTime == null) Text('wait...'),
              ]),
        );
      },
    );
  }
}

class Counter extends StatelessWidget {
  final Timestamp time;
  const Counter({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
        onEnd: () {
          gameBloc.add(GameEventNextPlayer());
        },
        format: CountDownTimerFormat.secondsOnly,
        enableDescriptions: false,
        endTime: time.toDate().add(Duration(seconds: 80)));
  }
}

String numberFormat(int i) {
  if (i < 10) return '00$i';
  if (i < 100) return '0$i';
  return '$i';
}

class Painter extends CustomPainter {
  Draw draw;
  Painter(this.draw);
  @override
  void paint(Canvas canvas, Size size) {
    int index = 0;
    for (List<Offset> pack in draw.points) {
      for (int i = 0; i < pack.length - 1; i++) {
        canvas.drawLine(
            pack[i], pack[i + 1], Paint()..color = draw.colors[index]);
      }
      index++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return (draw != gameBloc.draw);
  }
}
