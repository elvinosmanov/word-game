import 'package:demo_bloc/screens/game/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameProvider provider;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    provider = context.watch<GameProvider>();
    provider.height = MediaQuery.of(context).size.height;
    provider.width = MediaQuery.of(context).size.width;
    provider.reCreateBoxes();
    if (firstTime) {
      provider.randomCharacters = provider.getRandom(length: 28).split('');
      Future.delayed(const Duration(microseconds: 1), () {
        provider.offset = Offset(provider.width / 2 - 35, provider.height / 2 + 187);
      });
      firstTime = false;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: provider.rowChildren,
            ),
          ),
          for (var i = 0; i < 3; i++)
            Positioned(
              left: i * 10,
              top: i * 10,
              child: Text('salam'),
            ),
          Positioned(
            left: provider.offset.dx,
            top: provider.offset.dy,
            child: GestureDetector(
              onPanStart: ((details) =>
                  provider.offset = Offset(provider.offset.dx, provider.offset.dy - 30)),
              onPanEnd: (details) {
                // isDragged = false;
                provider.onPanEnd();
                provider.offset = Offset(provider.width / 2 - 35, provider.height / 2 + 187);
              },
              onPanUpdate: (details) {
                provider.onPanUpdate(details);
              },
              child: Container(
                width: provider.choosenBoxSize,
                height: provider.choosenBoxSize,
                decoration:
                    BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                  provider.randomCharacters[provider.counter],
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
