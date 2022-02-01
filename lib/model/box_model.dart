import 'package:demo_bloc/core/colors.dart';
import 'package:flutter/material.dart';

class BoxModel {
  Color color;
  String letter;
  bool isOn;

  BoxModel({required this.color, this.letter = '', this.isOn = false}) {
  }
}
