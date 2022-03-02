import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:scribble/constants.dart';

class Button extends StatelessWidget {
  final Function function;
  final String text;
  const Button({Key? key, required this.text, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: 250,
        height: 53,
        decoration: BoxDecoration(
          color: colorFront,
        ),
        child: Text(
          text,
          style: textStyleBig,
        ),
      ),
    );
  }
}

class ButtonSqaure extends StatelessWidget {
  final Function function;
  final String text;
  const ButtonSqaure({Key? key, required this.text, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: 53,
        height: 53,
        decoration: BoxDecoration(
          color: colorFront,
        ),
        child: Text(
          text,
          style: textStyleBig,
        ),
      ),
    );
  }
}

class ButtonRound extends StatelessWidget {
  final Function function;
  final String text;
  const ButtonRound({Key? key, required this.text, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: colorFront,
        ),
        child: Column(
          children: [
            Text(
              "rounds",
              style: textStyleSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              text,
              style: textStyleBig,
            ),
          ],
        ),
      ),
    );
  }
}
