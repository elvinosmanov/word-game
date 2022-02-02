import 'dart:math';

import 'package:demo_bloc/core/colors.dart';
import 'package:demo_bloc/core/constants/game_constants.dart';
import 'package:demo_bloc/helpers/padding.dart';
import 'package:demo_bloc/model/box_model.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Offset offset = Offset.zero;
  List<List<BoxModel>> boxModels = [];
  List<int?> previousOn = [];
  double choosenBoxSize = 70;
  late List<String> randomCharacters;
  @override
  void initState() {
    super.initState();
    randomCharacters = getRandom(length: 28).split('');
    boxModels = List.generate(
        kRowNumber, (index) => List.generate(kColNumber, (index) => BoxModel(color: kLightBaliColor.withOpacity(0.2))));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    offset = Offset(MediaQuery.of(context).size.width / 2 - 35, MediaQuery.of(context).size.height / 2 + 187);
  }

  @override
  Widget build(BuildContext context) {
    final children = <List<Widget>>[];
    for (var i = 0; i < kRowNumber; i++) {
      List<Widget> col = [];
      for (var j = 0; j < kColNumber; j++) {
        col.add(
          Container(
            width: 60,
            height: 60,
            margin: PagePadding.all(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: boxModels[i][j].isOn ? Colors.blue : boxModels[i][j].color,
            ),
            child: Center(
                child: Text(
              boxModels[i][j].letter,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            )),
          ),
        );
      }
      children.add(col);
    }
    final rowChildren = <Widget>[];
    for (var i = 0; i < kRowNumber; i++) {
      rowChildren.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: children[i],
      ));
    }

    
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: rowChildren,
                ),
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                child: GestureDetector(
                  onPanStart: ((details) => offset = Offset(offset.dx, offset.dy)),
                  onPanEnd: (details) {
                    // isDragged = false;
                    if (_findBox(offset)[0] != -1) {
                      final model = boxModels[_findBox(offset)[0]][_findBox(offset)[1]];
                      model.color = Colors.blue;
                      model.letter = getRandom();
                    }
                    offset = Offset(
                        MediaQuery.of(context).size.width / 2 - 35, MediaQuery.of(context).size.height / 2 + 187);
                    choosenBoxSize = 70;
                    setState(() {});
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      choosenBoxSize = 60;
                      offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                      if (_findBox(offset)[0] != -1) {
                        if (previousOn.isNotEmpty) {
                          boxModels[previousOn[0]!][previousOn[1]!].isOn = false;
                        }
                        final model = boxModels[_findBox(offset)[0]][_findBox(offset)[1]];
                        previousOn = [_findBox(offset)[0], _findBox(offset)[1]];
                        if (!model.isOn) {
                          model.isOn = true;
                        }
                      } else {
                        if (previousOn.isNotEmpty) {
                          boxModels[previousOn[0]!][previousOn[1]!].isOn = false;
                        }
                      }
                    });
                  },
                  child: Container(
                    width: choosenBoxSize,
                    height: choosenBoxSize,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
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
    final dx = MediaQuery.of(context).size.width / 2 - kBoxSize / 2 - (kBoxSize + kDistanceBetweenBox) * 2;
    final dy = MediaQuery.of(context).size.height / 2 - (kBoxSize - 2) * 3;
    return Size(dx + row * (kBoxSize + kDistanceBetweenBox), dy + col * (kBoxSize - 2));
  }

  bool _isOnBox(int col, int row) {
    const double padding = kBoxSize / 2 - 1;
    return offset.dx >= _positionBox(col, row).width - padding &&
        offset.dx <= _positionBox(col, row).width + padding &&
        offset.dy >= _positionBox(col, row).height - padding &&
        offset.dy <= _positionBox(col, row).height + padding;
  }

  List _findBox(Offset position) {
    const double padding = kBoxSize / 2 - 1;
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
    const ch = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random r = Random();
    return String.fromCharCodes(Iterable.generate(length ?? 1, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }
}
