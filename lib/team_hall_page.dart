import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class TeamHallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TeamHallState();
  }
}

class _TeamHallState extends State<TeamHallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(Constants.team_hall_title),
                collapseMode: CollapseMode.parallax,
                background: Image(
                    height: 150,
                    width: 150,
                    image: AssetImage(
                        Constants.myAvatars.elementAt(0).asset_Large)),
              ),
              actions: <Widget>[]),
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go back to dashboard!'),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
