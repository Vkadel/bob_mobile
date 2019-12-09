import 'package:flutter/material.dart';

import 'modelData/auth.dart';
import 'modelData/provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double margin = MediaQuery.of(context).size.width / 35;
    return Container(
      margin: EdgeInsets.fromLTRB(margin, margin, margin, margin),
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              side: BorderSide(color: Colors.white)),
          onPressed: () async {
            try {
              Auth auth = FireProvider.of(context).auth;
              await auth.signOut();
            } catch (e) {
              print(e);
            }
          },
          child: Text(
            'Sign out',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
