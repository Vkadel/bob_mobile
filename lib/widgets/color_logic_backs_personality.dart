import 'package:bob_mobile/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

import '../modelData/qanda.dart';

Future<Color> ColorLogicbyPersonality(BuildContext context) async {
  Constants myconstants = new Constants();
  Color assignedColor = Constants.color_main;

  if (context != null) {
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
}

ColorHue getColorHueByPersonality(BuildContext context) {
  ColorHue colorHue = ColorHue.yellow;
  if (context != null) {
    if (Quanda.of(context).myUser.personality['value_e'] >
        Quanda.of(context).myUser.personality['value_i']) {
      colorHue = ColorHue.red;
    }
    if (Quanda.of(context).myUser.personality['value_e'] <
        Quanda.of(context).myUser.personality['value_i']) {
      colorHue = ColorHue.purple;
    }
  }
  return colorHue;
}
