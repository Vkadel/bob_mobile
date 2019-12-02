import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarMessage {
  String message;
  BuildContext context;
  SnackBarMessage(this.message, this.context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: FutureBuilder<Object>(
          future: ColorLogicbyRole(context),
          builder: (context, snapshot) {
            return Container(
              child: Text(message),
              color: snapshot.connectionState == ConnectionState.active
                  ? snapshot.data
                  : null,
            );
          }),
    ));
  }
}
