import 'package:flutter/material.dart';

class TextFormattedLabelTwo extends StatelessWidget {
  String text;
  double font_size;
  double new_font_size;
  Future<Color> newColor;
  Color _color = Colors.white;
  int question_id;
  TextAlign mTextAlign = TextAlign.center;
  TextFormattedLabelTwo(@required this.text,
      [this.new_font_size, this.newColor, this.question_id, this.mTextAlign]);

  @override
  Widget build(BuildContext context) {
    if (new_font_size != 0) {
      font_size = new_font_size;
    } else {
      font_size = 25;
    }

    return FutureBuilder<Object>(
        future: newColor,
        builder: (context, newColorSnap) {
          if (newColor != null) {
            _color = newColorSnap.data;
          }
          return Text(
            '$text',
            softWrap: true,
            style: new TextStyle(
                color: _color,
                fontWeight: FontWeight.w300,
                fontSize: font_size),
            textAlign: mTextAlign,
          );
        });
  }
}
