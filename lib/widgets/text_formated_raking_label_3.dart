import 'package:flutter/material.dart';

class TextFormattedLabelThree extends StatelessWidget {
  String text;
  TextFormattedLabelThree(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: new TextStyle(
          color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
    );
  }
}
