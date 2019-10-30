import 'package:flutter/material.dart';

class TextFormattedLabelOne extends StatelessWidget {
  String text;
  TextFormattedLabelOne(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
