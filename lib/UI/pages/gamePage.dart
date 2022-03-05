import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/UI/widgets/decor.dart';
import 'package:scribble/bloc/game/game_bloc.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/constants.dart';
import 'package:scribble/module/Draw.dart';
import 'package:scribble/module/message.dart';
import 'package:scribble/module/player.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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
              if (gameBloc.myTurn && gameBloc.currentWord != "")
                gameBloc.draw.addDraw([e.globalPosition], color);
            },
            onPanUpdate: (e) {
              if (gameBloc.myTurn && gameBloc.currentWord != "")
                gameBloc.draw.updateDraw(e.globalPosition);
            },
            onPanEnd: (e) {
              if (gameBloc.myTurn && gameBloc.currentWord != "")
                gameBloc..add(GameEventPaintChange());
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
      child: Cadre(
        child: Container(
          color: Color(0xFFE5E5E5),
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
                    if (gameBloc.myTurn) {
                      showDialog(
                          context: context,
                          builder: (context) => MaterialColorPicker(
                                allowShades: false,
                                onColorChange: (newColor) {
                                  color = newColor;
                                },
                              ));
                    }
                    ;
                  },
                  child: Icon(Icons.color_lens)),
              Icon(Icons.add),
            ],
          ),
        ),
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
                  child: Cadre(
                    child: Container(
                      color: Color(0xFFE5E5E5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (Player player in roomBloc.players)
                              PlayerContainer(player: player),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              //  duration: Duration(milliseconds: 500),
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: MessageBox(message: message),
                                ),
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
            if (gameBloc.myTurn && gameBloc.currentWord == "")
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
          width: 60.0,
          color: (roomBloc.players[gameBloc.currentPlayer].id == player.id)
              ? Colors.blue.shade100
              : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                numberFormat(player.totalScore),
                style: textStyleError,
              ),
              SizedBox(
                height: 8.0,
              ),
              SvgPicture.asset(
                player.avatar,
                theme: SvgTheme(currentColor: Colors.white),
                fit: BoxFit.fitWidth,
                width: 50,
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                child: Text(
                  player.name,
                  textAlign: TextAlign.center,
                  style: textStyleSmall
                      .copyWith(color: colorMain, fontSize: 10.0, shadows: []),
                ),
              ),
              SizedBox(
                height: 8.0,
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      color: Colors.grey.shade400,
      padding: EdgeInsets.all(4.0),
      width: 200 - 8,
      child: Column(
        children: [
          Text(
            message.username,
            style: textStyleError,
          ),
          Text(
            message.content,
            style: textStyleSmall.copyWith(color: Colors.white, shadows: []),
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
          color: Colors.white,
          child: Cadre(
            child: Container(
              padding: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Cadre(
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        color: Colors.white,
                        child: Text(
                          "round ${gameBloc.currentRound}",
                          style: textStyleSmall
                              .copyWith(color: Colors.black, shadows: []),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Icon(Icons.home)),
                    Cadre(
                        child: Container(
                            padding: EdgeInsets.all(2.0),
                            color: Colors.white,
                            child: (gameBloc.beginTime != null)
                                ? new Counter(time: gameBloc.beginTime!)
                                : Text(
                                    "80",
                                    style: textStyleSmall,
                                  ))),
                  ]),
            ),
          ),
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
        timeTextStyle: textStyleSmall,
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
