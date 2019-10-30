import 'package:bob_mobile/constants.dart';
import 'package:bob_mobile/data_type/avatar.dart';
import 'package:flutter/material.dart';

import '../qanda.dart';

Color ColorLogicbyRole(BuildContext context) {
  Constants myconstants = new Constants();
  Color assignedColor = Constants.color_main;
  if (Quanda.of(context).myUser.role == Constants.myAvatars.elementAt(0).id) {
    assignedColor = Constants.myAvatars.elementAt(0).color;
  }
  if (Quanda.of(context).myUser.role == Constants.myAvatars.elementAt(1).id) {
    assignedColor = Constants.myAvatars.elementAt(1).color;
  }
  if (Quanda.of(context).myUser.role == Constants.myAvatars.elementAt(2).id) {
    assignedColor = Constants.myAvatars.elementAt(2).color;
  }
  return assignedColor;
}
