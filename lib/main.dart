import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:dengue_epidemic_simulation/models/dengue_epidemic_simulation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dengue Epidemic Simulation',
      home: Scaffold(
        body: GameWidget(game: DengueEpidemicSimulation()),
      ),
    );
  }
}
