import 'package:flutter/material.dart';

import 'UI/pages/home.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scribble MC',
      theme: ThemeData(
        primaryColor: colorMain,
      ),
      home: const Home(),
    );
  }
}
