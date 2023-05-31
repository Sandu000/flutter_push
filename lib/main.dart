import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;

  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.9),
            child: Text(
              "Test your\nreaction speed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: Colors.black12,
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    millisecondsText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500  , color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: Colors.black12,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: TextStyle(fontSize: 38, color: _getButtonColor()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }

  Color _getButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return const Color(0xFF40CA88);
      case GameState.waiting:
        return const Color(0xFFE0982D);
      case GameState.canBeStopped:
        return const Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }