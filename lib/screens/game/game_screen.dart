import 'dart:math';

import 'package:demo_bloc/core/constants/game_constants.dart';
import 'package:demo_bloc/screens/game/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int?> previousOn = [];
  double choosenBoxSize = 70;
  late GameProvider provider;
  bool firstTime = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    provider = context.watch<GameProvider>();
    provider.height = MediaQuery.of(context).size.height;
    provider.width = MediaQuery.of(context).size.width;
    provider.reCreateBoxes();
    if (firstTime) {
      provider.randomCharacters = getRandom(length: 28).split('');
      Future.delayed(
        const Duration(microseconds: 1),
        () {
          provider.offset = Offset(provider.width / 2 - 35, provider.height / 2 + 187);
        },
      );

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
          Positioned(
            left: provider.offset.dx,
            top: provider.offset.dy,
            child: GestureDetector(
              onPanStart: ((details) =>
                  provider.offset = Offset(provider.offset.dx, provider.offset.dy)),
              onPanEnd: (details) {
                // isDragged = false;
                provider.onPanEnd();
                provider.offset = Offset(provider.width / 2 - 35, provider.height / 2 + 187);
              },
              onPanUpdate: (details) {
                choosenBoxSize = 60;
                provider.offset = Offset(
                    provider.offset.dx + details.delta.dx, provider.offset.dy + details.delta.dy);
                if (_findBox(provider.offset)[0] != -1) {
                  if (previousOn.isNotEmpty) {
                    provider.boxModels[previousOn[0]!][previousOn[1]!].isOn = false;
                  }
                  final model = provider.boxModels[_findBox(provider.offset)[0]]
                      [_findBox(provider.offset)[1]];
                  previousOn = [_findBox(provider.offset)[0], _findBox(provider.offset)[1]];
                  if (!model.isOn) {
                    model.isOn = true;
                  }
                } else {
                  if (previousOn.isNotEmpty) {
                    provider.boxModels[previousOn[0]!][previousOn[1]!].isOn = false;
                  }
                }
              },
              child: Container(
                width: choosenBoxSize,
                height: choosenBoxSize,
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
          // Positioned(
          //   top: MediaQuery.of(context).size.height / 2 + 187,
          //   left: MediaQuery.of(context).size.width / 2 - 35,
          //   child: Container(
          //     width: 70,
          //     height: 70,
          //     decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
          //   ),
          // ),
        ],
      ),
    );
  }

  Size _positionBox(int col, int row) {
    final dx =
        MediaQuery.of(context).size.width / 2 - kBoxSize / 2 - (kBoxSize + kDistanceBetweenBox) * 2;
    final dy = MediaQuery.of(context).size.height / 2 - (kBoxSize - 2) * 3;
    return Size(dx + row * (kBoxSize + kDistanceBetweenBox), dy + col * (kBoxSize - 2));
  }

  bool _isOnBox(int col, int row) {
    const double padding = kBoxSize / 2 + 4;
    return provider.offset.dx >= _positionBox(col, row).width - padding &&
        provider.offset.dx <= _positionBox(col, row).width + padding &&
        provider.offset.dy >= _positionBox(col, row).height - padding &&
        provider.offset.dy <= _positionBox(col, row).height + padding;
  }

  List _findBox(Offset position) {
    for (var i = 0; i < kRowNumber; i++) {
      for (var j = 0; j < kColNumber; j++) {
        if (_isOnBox(i, j)) {
          return [i, j];
        }
      }
    }
    return [-1, -1];
  }

  String getRandom({int? length}) {
    const ch = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ???';
    Random r = Random();
    return String.fromCharCodes(
        Iterable.generate(length ?? 1, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }
}
