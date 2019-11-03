import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/cupertino.dart';

import 'color_logic_backs_role.dart';

class TextFormattedRoomLabel extends TextFormattedLabelTwo {
  BuildContext context;

  TextFormattedRoomLabel(
    String text,
    BuildContext this.context,
  ) : super(text, 30, ColorLogicbyRole(context));
}
