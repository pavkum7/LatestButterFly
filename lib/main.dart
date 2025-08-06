import 'package:flutter/material.dart';
import 'widgets/game_screen.dart';

void main() {
  runApp(const FlutterDodgeApp());
}

class FlutterDodgeApp extends StatelessWidget {
  const FlutterDodgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dodge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 