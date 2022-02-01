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
  BoxModel onModel = BoxModel();
  @override
  void initState() {
    super.initState();
    boxModels = List.generate(5, (index) => List.generate(5, (index) => BoxModel()));
  }

  @override
  Widget build(BuildContext context) {
    final children = <List<Widget>>[];
    for (var i = 0; i < 5; i++) {
      List<Widget> row = [];
      for (var j = 0; j < 5; j++) {
        row.add(
          Container(
            width: 60,
            height: 60,
            margin: PagePadding.all(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: boxModels[i][j].isOn ? Colors.red : kLightBaliColor.withOpacity(0.2),
            ),
          ),
        );
      }
      children.add(row);
    }
    final rowChildren = <Widget>[];
    for (var i = 0; i < 5; i++) {
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
                print(_findBox(offset));
                if (_findBox(offset)[0] != -1) {
                  final model = boxModels[_findBox(offset)[0]][_findBox(offset)[1]];
                  if (!model.isOn) {
                    model.isOn = true;
                  }
                }
                setState(() {});
              },
              onPanUpdate: (details) {
                setState(() {
                  offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                });
              },
              child: Container(width: 60, height: 60, color: Colors.blue),
            ),
          ),
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
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        if (_isOnBox(i, j)) {
          return [i, j];
        }
      }
    }
    return [-1, -1];
  }
}