import 'package:flutter/material.dart';

class TextFormattedLabelTwo extends StatelessWidget {
  String text;
  TextFormattedLabelTwo(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: new TextStyle(
          color: Colors.white, fontWeight: FontWeight.w300, fontSize: 25),
    );
  }
}
