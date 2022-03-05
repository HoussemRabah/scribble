import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'UI/pages/home.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scribble MC',
      theme: ThemeData(
        fontFamily: 'upheavtt',
        primaryColor: colorMain,
      ),
      home: const Home(),
    );
  }
}
