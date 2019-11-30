import 'package:bob_mobile/helpers/constants.dart';
import 'package:flutter/material.dart';

import '../modelData/qanda.dart';

Color ColorLogicbyRole(BuildContext context) {
  Constants myconstants = new Constants();
  Color assignedColor = Constants.color_main;
  int role;
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
  return assignedColor;
}
