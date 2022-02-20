import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/constants/game_constants.dart';
import '../../helpers/padding.dart';
import '../../model/box_model.dart';

class GameProvider with ChangeNotifier {
  Offset _offset = Offset.zero;

  Offset get offset => _offset;
  double height = 0.0;
  double width = 0.0;
  int counter = 0;

  set offset(Offset offset) {
    _offset = offset;
    notifyListeners();
  }


  List<List<BoxModel>> boxModels = List.generate(
      kRowNumber,
      (index) =>
          List.generate(kColNumber, (index) => BoxModel(color: kLightBaliColor.withOpacity(0.2))));

  List<int?> previousOn = [];

  double _choosenBoxSize = 70;
  double get choosenBoxSize => _choosenBoxSize;
  set choosenBoxSize(double choosenBoxSize) {
    _choosenBoxSize = choosenBoxSize;
    notifyListeners();
  }

  List<String> randomCharacters = [];

  List<Widget> rowChildren = <Widget>[];

  void reCreateBoxes() {
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
              color: boxModels[i][j].isOn ? Colors.grey : boxModels[i][j].color,
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
    final rowChildren2 = <Widget>[];
    for (var i = 0; i < kRowNumber; i++) {
      rowChildren2.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: children[i],
      ));
    }
    rowChildren = rowChildren2;
  }

  onPanEnd() {
    if (_findBox(offset)[0] != -1) {
      final model = boxModels[_findBox(offset)[0]][_findBox(offset)[1]];
      if (model.color != Colors.grey) {
        model.color = Colors.grey;
        model.letter = randomCharacters[counter];
        counter += 1;
      }
    }
    choosenBoxSize = 70;
  }

  onPanUpdate(DragUpdateDetails details) {
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

  bool _isOnBox(int col, int row) {
    const double padding = kBoxSize / 2 + 4;
    return offset.dx >= _positionBox(col, row).width - padding &&
        offset.dx <= _positionBox(col, row).width + padding &&
        offset.dy >= _positionBox(col, row).height - padding &&
        offset.dy <= _positionBox(col, row).height + padding;
  }

  Size _positionBox(int col, int row) {
    final dx = width / 2 - kBoxSize / 2 - (kBoxSize + kDistanceBetweenBox) * 2;
    final dy = height / 2 - (kBoxSize - 2) * 3;
    return Size(dx + row * (kBoxSize + kDistanceBetweenBox), dy + col * (kBoxSize - 2));
  }

  String getRandom({int? length}) {
    const ch = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ???';
    Random r = Random();
    return String.fromCharCodes(
        Iterable.generate(length ?? 1, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }
}
