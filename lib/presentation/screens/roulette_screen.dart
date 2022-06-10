import 'dart:math';

import 'package:flutter/material.dart';

class RouletteScreen extends StatefulWidget {
  const RouletteScreen({Key? key}) : super(key: key);

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  double turns = 0.0;

  void _changeRotation() {
    double rotationDegrees = Random().nextDouble();
    int rotationTurns = Random().nextInt(5);
    double numberOfTurns = rotationDegrees * rotationTurns;

    print(
        "Degrees ${rotationDegrees * 360} numberOfTurns $rotationTurns fractionDegrees $rotationDegrees");
    setState(() => turns = numberOfTurns);
  }

  Map<double, String> ringValues = {
    6 / 6: "Violet",
    5 / 6: "Purple",
    4 / 6: "Red",
    3 / 6: "Orange",
    2 / 6: "Deep Yellow",
    1 / 6: "Yellow"
  };

  void printColor() {
    String color = "";
    ringValues.forEach((key, value) {
      if (key >= turns - turns.truncate()) {
        color = value;
        return;
      }
    });
    print("Color " + color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              colors: <Color>[
                Color.fromARGB(255, 9, 32, 63),
                Color.fromARGB(255, 83, 120, 149)
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 9, 32, 63),
              Color.fromARGB(255, 83, 120, 149),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedRotation(
                  turns: turns,
                  duration: const Duration(seconds: 1),
                  child: Image.asset('assets/roulette_wheel.png'),
                  onEnd: printColor,
                ),
                ElevatedButton(
                  onPressed: _changeRotation,
                  child: const Text('Rotate Logo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
