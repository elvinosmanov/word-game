import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/game_constants.dart';
import '../../helpers/padding.dart';
import '../../model/box_model.dart';

class GameProvider with ChangeNotifier {
  Offset offset = Offset.zero;
  List<List<BoxModel>> boxModels = [];
  List<int?> previousOn = [];
  double choosenBoxSize = 70;
  late List<String> randomCharacters;
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
    rowChildren = <Widget>[];
    for (var i = 0; i < kRowNumber; i++) {
      rowChildren.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: children[i],
      ));
    }
  }
}
