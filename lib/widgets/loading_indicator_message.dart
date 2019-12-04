import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorMessage extends StatelessWidget {
  final String message;

  const LoadingIndicatorMessage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormattedLabelTwo(message, MediaQuery.of(context).size.width / 25,
            Future.value(Colors.black)),
        Center(
          child: CircularProgressIndicator(),
        )
      ],
    ));
  }
}
