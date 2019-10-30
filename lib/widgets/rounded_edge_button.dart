import 'package:bob_mobile/constants.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_logic_backs_personality.dart';

Widget FormattedRoundedButton(
    String label, Function myFunction, BuildContext context) {
  final String _label = label;
  final Function _myFunction = myFunction;
  return Container(
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
    child: RaisedButton(
      elevation: 8,
      splashColor: Colors.orangeAccent,
      color: colorLogicbyPersonality(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      highlightElevation: 2,
      onPressed: _myFunction,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _label,
              style: new TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
