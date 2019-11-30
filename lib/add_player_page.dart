import 'package:flutter/material.dart';

class AddPlayerPage extends StatefulWidget {
  AddPlayerPage({Key key}) : super(key: key);

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Will need to add a player'),
        ),
      ),
    );
  }
}
