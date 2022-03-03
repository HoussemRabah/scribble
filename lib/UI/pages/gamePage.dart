import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scribble/UI/widgets/buttons.dart';
import 'package:scribble/bloc/game/game_bloc.dart';
import 'package:scribble/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

GameBloc gameBloc = GameBloc();

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: gameBloc)],
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
            Container(
              width: 60,
              height: MediaQuery.of(context).size.height - 30 - 60,
              color: Color(0xFFE5E5E5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "000",
                      style: textStyleError,
                    ),
                    SvgPicture.asset(
                      "assets/Skins/Boy.svg",
                      theme: SvgTheme(currentColor: Colors.white),
                      fit: BoxFit.fitWidth,
                      width: 50,
                    ),
                    Text(
                      "hello",
                      style: textStyleError,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: Color(0xFFE5E5E5),
              width: gameBloc.expanded ? 200 : 0,
              height: MediaQuery.of(context).size.height - 90,
            ),
            GestureDetector(
              onTap: () {
                gameBloc.expanded = !gameBloc.expanded;
              },
              child: Container(
                height: 80,
                color: Color(0xFFE5E5E5),
                child: Icon(Icons.arrow_right),
              ),
            ),
            if (!gameBloc.expanded)
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
                    Button(text: "word 1", function: () {}),
                    Button(text: "word 2", function: () {}),
                    Button(text: "word 2", function: () {}),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

class HighBar extends StatelessWidget {
  const HighBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "round 1",
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
  }
}
