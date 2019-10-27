import 'package:flutter/cupertino.dart';

class TextFormattedBody extends StatelessWidget {
  String text;

  TextFormattedBody(this.text) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      ),
    );
  }
}
