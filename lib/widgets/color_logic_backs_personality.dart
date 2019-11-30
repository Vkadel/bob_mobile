import 'package:bob_mobile/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

import '../modelData/qanda.dart';

Color ColorLogicbyPersonality(BuildContext context) {
  Constants myconstants = new Constants();
  Color assignedColor = Constants.color_main;
  if (Quanda.of(context).myUser != null) {
    if (Quanda.of(context).myUser.personality['value_e'] >
        Quanda.of(context).myUser.personality['value_i']) {
      assignedColor = Constants.color_extro;
    }
    if (Quanda.of(context).myUser.personality['value_e'] <
        Quanda.of(context).myUser.personality['value_i']) {
      assignedColor = Constants.color_intro;
    }
  }
  return assignedColor;
}

ColorHue getColorHueByPersonality(BuildContext context) {
  ColorHue colorHue;
  if (Quanda.of(context).myUser.personality['value_e'] >
      Quanda.of(context).myUser.personality['value_i']) {
    colorHue = ColorHue.red;
  }
  if (Quanda.of(context).myUser.personality['value_e'] <
      Quanda.of(context).myUser.personality['value_i']) {
    colorHue = ColorHue.purple;
  }
  return colorHue;
}
