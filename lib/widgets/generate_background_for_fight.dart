import 'dart:math';

import 'package:bob_mobile/helpers/constants.dart';
import 'package:flutter/cupertino.dart';

class GenerateBackGroundForFight {
  BuildContext context;
  GenerateBackGroundForFight(this.context);

  String getRamdomBackground() {
    int size = 1;

    return size == 1
        ? Constants.fight_background_list.elementAt(0)
        : Constants.fight_background_list
            .elementAt(new Random().nextInt(size - 1));
  }
}
