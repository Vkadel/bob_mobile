import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarWithSpin {
  String message;
  BuildContext context;
  SnackBarWithSpin(this.message, this.context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: FutureBuilder<Object>(
          future: ColorLogicbyRole(context),
          builder: (context, snapshot) {
            return Container(
              color: snapshot.connectionState == ConnectionState.active
                  ? snapshot.data
                  : null,
              child: Row(
                children: <Widget>[Text(message), CircularProgressIndicator()],
              ),
            );
          }),
    ));
  }
}
