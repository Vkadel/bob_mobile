import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:flutter/material.dart';

import '../modelData/qanda.dart';

Future<Color> ColorLogicbyRole(BuildContext context) async {
  Constants myconstants = new Constants();
  Color assignedColor = Constants.color_main;
  int role = 0;
  if (context != null && Quanda.of(context).myUser == null) {
    //Need to refresh the user
    Quanda.of(context).myUser =
        await FireProvider.of(context).fireBase.refreshUser(context);
  }
  if (Quanda.of(context).myUser != null && context != null) {
    if (Quanda.of(context).myUser.role == null) {
      role = 1;
    } else {
      role = Quanda.of(context).myUser.role;
    }
    if (role == Constants.myAvatars.elementAt(0).id) {
      assignedColor = Constants.myAvatars.elementAt(0).color;
    }
    if (role == Constants.myAvatars.elementAt(1).id) {
      assignedColor = Constants.myAvatars.elementAt(1).color;
    }
    if (role == Constants.myAvatars.elementAt(2).id) {
      assignedColor = Constants.myAvatars.elementAt(2).color;
    }
  }

  return assignedColor;
}
