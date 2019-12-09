import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarMessage {
  String message;
  BuildContext context;
  double fontSize = 12;

  SnackBarMessage(this.message, this.context) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: FutureBuilder<Object>(
          future: ColorLogicbyRole(context),
          builder: (context, snapshot) {
            fontSize = MediaQuery.of(context).size.width / 25;
            try {
              message.length > 15 && message.length <= 25 ? fontSize - 5 : null;
              message.length > 25 ? fontSize - 8 : null;
            } catch (e) {
              print(e);
            }
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
