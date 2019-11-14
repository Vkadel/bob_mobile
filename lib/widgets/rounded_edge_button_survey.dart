import 'package:bob_mobile/modelData/personality_test_state_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MyRoundedButtonForSurvey(bool pressed, String label,
    PersonalityTestStateData personalityTestStateData, function) {
  if (pressed) {
    //Container if pressed
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: RaisedButton(
        splashColor: Colors.orangeAccent,
        color: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        highlightElevation: 0,
        onPressed: () {
          print('Hi Really setting state');
          function(personalityTestStateData);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  maxLines: 15,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  } else {
    //Container if NOT pressed
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: RaisedButton(
        splashColor: Colors.orangeAccent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        highlightElevation: 0,
        onPressed: () {
          print('Hi Really setting state');
          function(personalityTestStateData);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  maxLines: 15,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
