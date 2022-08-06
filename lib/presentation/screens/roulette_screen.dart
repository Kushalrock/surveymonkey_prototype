import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';
import 'package:surveymonkey_prototype/logic/cubit/get_coins_cubit.dart';
import 'package:surveymonkey_prototype/logic/cubit/question_cubit.dart';

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

  void printColor() async {
    String color = "";
    ringValues.forEach((key, value) {
      if (key >= turns - turns.truncate()) {
        color = value;
        return;
      }
    });
    int coinsWon = int.parse(color);
    await context.read<QuestionCubit>().rouletteTimeSubmit();
    await context
        .read<AuthCubit>()
        .addCoins(coinsWon, "Won $color coins in roulette");
    await context.read<GetCoinsCubit>().getCoins();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 18, 18, 18),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 18, 18, 18),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Earn Coins Daily",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Try your luck",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _changeRotation,
                  child: const Text(
                    'Spin the wheel',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(31, 99, 99, 99)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
