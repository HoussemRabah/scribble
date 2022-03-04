import 'package:flutter/material.dart';

Color colorBack = Color(0xFFA4BBD6);
Color colorFront = Color(0xFFFAF1AC);
Color colorMain = Color(0xFFFFBE00);
Color colorBlack = Color(0xEE000000);

List<Shadow> shadows = [
  Shadow(offset: Offset(-2, -2), color: Colors.black),
  Shadow(offset: Offset(2, -2), color: Colors.black),
  Shadow(offset: Offset(2, 2), color: Colors.black),
  Shadow(offset: Offset(-2, 2), color: Colors.black),
];

TextStyle textStyleTitle = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 3.0,
    color: colorMain,
    shadows: shadows);

TextStyle textStyleBig = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 3.0,
    color: colorMain,
    shadows: shadows);

TextStyle textStyleSmall = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 3.0,
    color: colorMain,
    shadows: shadows);

TextStyle textStyleError = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: Colors.redAccent,
  letterSpacing: 3.0,
);
