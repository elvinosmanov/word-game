import 'package:demo_bloc/core/colors.dart';
import 'package:demo_bloc/screens/game_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: kDarkBackgroundColor),
      home: const GameScreen(),
    );
  }
}
