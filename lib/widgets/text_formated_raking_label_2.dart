import 'package:flutter/material.dart';

class TextFormattedLabelTwo extends StatelessWidget {
  String text;
  double font_size;
  double new_font_size;
  Color newColor = Colors.white;
  Color _color = Colors.white;
  int question_id;

  TextFormattedLabelTwo(@required this.text,
      [this.new_font_size, this.newColor, this.question_id]);

  @override
  Widget build(BuildContext context) {
    if (new_font_size != 0) {
      font_size = new_font_size;
    } else {
      font_size = 25;
    }
    if (newColor != Colors.white) {
      _color = newColor;
    }
    return Text(
      '$text',
      style: new TextStyle(
          color: _color, fontWeight: FontWeight.w300, fontSize: font_size),
      textAlign: TextAlign.center,
    );
  }
}
