import 'dart:math';

import 'package:bob_mobile/constants.dart';
import 'package:flutter/cupertino.dart';

class GenerateMonsterImageForFight {
  BuildContext context;
  GenerateMonsterImageForFight(this.context);

  String getRamdomMonsterImage() {
    int size = 1;
    return size == 1
        ? Constants.monster_pic_list.elementAt(0)
        : Constants.monster_pic_list.elementAt(new Random().nextInt(size - 1));
  }
}
