import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bob_mobile/modelData/auth.dart';

Widget EmailSignInButton(
    String label, void Function() submit, BuildContext context) {
  return Builder(
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: OutlineButton(
          splashColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          onPressed: () async {
            try {
              submit();
            } catch (e) {
              print(e);
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Theme.of(context).buttonColor,
                ),
                Text('   $label'),
              ],
            ),
          ),
        ),
      );
    },
  );
}
