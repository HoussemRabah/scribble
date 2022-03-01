import 'package:flutter/material.dart';
import 'package:scribble/constants.dart';

class LoadingBar extends StatelessWidget {
  final double process;
  const LoadingBar({Key? key, required this.process}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colorFront,
      ),
      height: 10.0,
      width: 100,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(color: colorMain),
        height: 10.0,
        width: 100 * process,
      ),
    );
  }
}
