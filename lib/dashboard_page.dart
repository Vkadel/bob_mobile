import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/data_type/team_points.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_3.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/team_hall_page.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bob_mobile/widgets/scrollable_widget_window.dart';

import 'constants.dart';
import 'widgets/text_formated_raking_label_1.dart';
import 'hero_room_page.dart';

class DashBoardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DashBoardPageState();
  }
}

class _DashBoardPageState extends State<DashBoardPage> {
  int _location_at_player_rankings;
  int _location_at_team_rankings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants().user_dashboard_title),
        backgroundColor: ColorLogicbyRole(context),
      ),
      body: Container(
        child: build_body(context),
      ),
    );
  }
}

build_body(BuildContext context) {
  return myScrollableWindow(
      context,
      Column(
        children: <Widget>[
          HeaderDashboard(context),
          Container(
            color: colorLogicbyPersonality(context),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(16, 10, 16, 15),
            height: 200,
            child: PlayerRankings(context),
          ),
          Container(
            color: colorLogicbyPersonality(context),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            height: 200,
            child: TeamRankings(context),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                HeroRoomButton(context),
                TeamRoomButton(context),
                /*PlayerRankings(context)*/
              ],
            ),
          ),
        ],
      ));
}

Widget HeaderDashboard(BuildContext context) {
  return Container(
    child: Row(
      children: <Widget>[
        Image(
          image: AssetImage(Constants.myAvatars
              .elementAt(Quanda.of(context).myUser.role - 1)
              .header_dashboard),
        ),
      ],
    ),
  );
}

Widget HeroRoomButton(BuildContext context) {
  return FormattedRoundedButton(
      Constants.go_to_hero_room_but_text, gotoHeroRoom, context);
}

Widget TeamRoomButton(BuildContext context) {
  return FormattedRoundedButton(
      Constants.go_to_team_hall_but_text, gotoTeamHall, context);
}

Widget PlayerRankings(BuildContext context) {
  return StreamBuilder(
    stream: Provider.of(context).fireBase.getPlayerRankings(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (!snapshot.hasError && snapshot.hasData) {
          return _listofIndividualRankings(context, snapshot);
        }
      } else {
        return Container();
      }
    },
  );
}

Widget TeamRankings(BuildContext context) {
  return StreamBuilder(
    stream: Provider.of(context).fireBase.getTeamRankings(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (!snapshot.hasError && snapshot.hasData) {
          Provider.of(context).fireBase.getBookTypes(context);
          return _listofTeamRankings(context, snapshot);
        }
      } else {
        return Container();
      }
    },
  );
}

gotoHeroRoom(BuildContext context) {
  print('Debug: I will go to the hero room');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HeroRoomPage()),
  );
}

gotoTeamHall(BuildContext context) {
  print('Debug: I will go to the team halls');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TeamHallPage()),
  );
}

_listofIndividualRankings(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  return ListView.builder(
      itemExtent: 90,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      itemCount: snapshot.data.documents.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) =>
          _buildListItem(context, snapshot.data.documents[index], index));
}

_buildListItem(BuildContext context, DocumentSnapshot item, int index) {
  PlayerPoints playerPoint = PlayerPoints.fromJson(item.data);
  String player_name = playerPoint.player_name;
  return Container(
    alignment: Alignment.center,
    color: colorLogicbyPersonality(context),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            TextFormattedLabelOne('${index + 1}. '),
            TextFormattedLabelTwo('$player_name', 0),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextFormattedLabelTwo('${playerPoint.player_points} ', 0),
            TextFormattedLabelThree('${Constants.unit_points}'),
          ],
        ),
        Divider(
          color: Colors.white,
        )
      ],
    ),
  );
}

_listofTeamRankings(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  return ListView.builder(
      itemExtent: 90,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      itemCount: snapshot.data.documents.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) =>
          _buildListTeamItem(context, snapshot.data.documents[index], index));
}

_buildListTeamItem(BuildContext context, DocumentSnapshot item, int index) {
  TeamPoints teamPoint = TeamPoints.fromJson(item.data);
  String team_name = teamPoint.team_name;
  return Container(
    alignment: Alignment.center,
    color: colorLogicbyPersonality(context),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            TextFormattedLabelOne('${index + 1}. '),
            TextFormattedLabelTwo('$team_name', 0),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextFormattedLabelTwo('${teamPoint.team_points} ', 0),
            TextFormattedLabelThree('${Constants.unit_points}'),
          ],
        ),
        Divider(
          color: Colors.white,
        )
      ],
    ),
  );
}
