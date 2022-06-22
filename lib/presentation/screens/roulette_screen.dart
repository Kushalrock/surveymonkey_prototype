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
    12 / 12: "1",
    11 / 12: "10",
    10 / 12: "1",
    9 / 12: "2",
    8 / 12: "3",
    7 / 12: "5",
    6 / 12: "7",
    5 / 12: "9",
    4 / 12: "7",
    3 / 12: "5",
    2 / 12: "3",
    1 / 12: "2",
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedRotation(
                      turns: turns,
                      duration: const Duration(seconds: 1),
                      child: Image.asset('assets/roulette_wheel.png'),
                      onEnd: printColor,
                    ),
                    Image.asset('assets/roulette_pointer.png'),
                  ],
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
