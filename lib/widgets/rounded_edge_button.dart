import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_logic_backs_personality.dart';

Widget FormattedRoundedButton(
    String label, Function myFunction, BuildContext context) {
  final String _label = label;
  final Function _myFunction = myFunction;
  final BuildContext myContext = context;
  double textSize = 20;
  /* if (label.length > 38) {
    textSize = 15;
  }
  if (label.length > 45) {
    textSize = 10;
  }*/
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
    child: RaisedButton(
      elevation: 8,
      splashColor: Colors.orangeAccent,
      color: ColorLogicbyPersonality(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      highlightElevation: 2,
      onPressed: () {
        _myFunction(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _label,
              style: new TextStyle(color: Colors.white, fontSize: textSize),
            ),
          ],
        ),
      ),
    ),
  );
}
