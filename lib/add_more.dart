import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/material.dart';

class addMoreButton extends StatelessWidget {
  final String buttonTitle;
  final Function function;
  const addMoreButton(
    this.buttonTitle,
    this.function, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: ColorLogicbyRole(context),
        builder: (context, snapshotColor) {
          Color color = snapshotColor.data;
          if (color != null) {
            return FlatButton.icon(
                shape: Border.all(color: color, width: 2),
                onPressed: function,
                icon: Icon(
                  Icons.add,
                  color: color,
                ),
                label: TextFormattedLabelTwo(
                    buttonTitle,
                    MediaQuery.of(context).size.width / 20,
                    Future.value(snapshotColor.data),
                    null,
                    TextAlign.center));
          } else {
            return Container();
          }
        });
  }
}
