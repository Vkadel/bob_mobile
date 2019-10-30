import 'package:bob_mobile/constants.dart';
import 'package:flutter/material.dart';

import '../qanda.dart';

Color colorLogicbyPersonality(BuildContext context) {
  Constants myconstants = new Constants();
  Color assignedColor = Constants.color_main;
  if (Quanda.of(context).myUser.personality['value_e'] >
      Quanda.of(context).myUser.personality['value_i']) {
    assignedColor = Constants.color_extro;
  }
  if (Quanda.of(context).myUser.personality['value_e'] <
      Quanda.of(context).myUser.personality['value_i']) {
    assignedColor = Constants.color_intro;
  }
  return assignedColor;
}
