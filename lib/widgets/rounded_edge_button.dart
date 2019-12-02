import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_logic_backs_personality.dart';

class FormattedRoundedButton extends StatelessWidget {
  String _label;
  Function _myFunction;
  BuildContext myContext;
  double textSize = 20;
  int question_id;

  FormattedRoundedButton(
      @required this._label, this._myFunction, this.myContext,
      [this.question_id, this.textSize]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: FutureBuilder<Color>(
          future: ColorLogicbyPersonality(context),
          builder: (context, snapshotColor) {
            return RaisedButton(
              elevation: 8,
              splashColor: Colors.orangeAccent,
              color: snapshotColor.data,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              highlightElevation: 2,
              onPressed: () {
                question_id == null
                    ? _myFunction(context)
                    : _myFunction(context, question_id);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text(
                  _label,
                  style: new TextStyle(color: Colors.white, fontSize: textSize),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
    );
  }
}
