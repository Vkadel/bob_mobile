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
      content: Row(
        children: <Widget>[Text(message), CircularProgressIndicator()],
      ),
      backgroundColor: ColorLogicbyRole(context),
    ));
  }
}
