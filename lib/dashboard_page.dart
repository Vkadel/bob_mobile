import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/data_type/team_points.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_3.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/team_hall_page.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bob_mobile/widgets/scrollable_widget_window.dart';

import 'helpers/constants.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants().user_dashboard_title),
          flexibleSpace: FutureBuilder<Color>(
              future: ColorLogicbyRole(context),
              builder: (context, snapshotColor) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: Constants.height_extended_bars,
                  color: snapshotColor.data,
                );
              }),
        ),
        body: Container(
          child: build_body(context),
        ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormattedLabelTwo(
                '${Constants.individual_rankings_label}',
                20,
                ColorLogicbyPersonality(context)),
          ),
          FutureBuilder<Object>(
              future: ColorLogicbyPersonality(context),
              builder: (context, snapshot) {
                return Container(
                  color: snapshot.data,
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 15),
                  height: Constants.height_extended_bars,
                  child: PlayerRankings(context),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormattedLabelTwo('${Constants.team_rankings_label}', 20,
                ColorLogicbyPersonality(context)),
          ),
          FutureBuilder<Color>(
              future: ColorLogicbyPersonality(context),
              builder: (context, snapshot) {
                return Container(
                  color: snapshot.data,
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  height: Constants.height_extended_bars,
                  child: TeamRankings(context),
                );
              }),
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
    stream: FireProvider.of(context).fireBase.getPlayerRankings(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (!snapshot.hasError && snapshot.hasData) {
          List<PlayerPoints> playerRankings = snapshot.data.documents
              .map((item) => PlayerPoints.fromJson(item.data))
              .toList();
          Quanda.of(context).playerRankings = playerRankings;
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
    stream: FireProvider.of(context).fireBase.getTeamRankings(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        if (!snapshot.hasError && snapshot.hasData) {
          Quanda.of(context).teamRankings = snapshot.data.documents
              .toList()
              .map((item) => TeamPoints.fromJson(item.data))
              .toList();
          FireProvider.of(context).fireBase.getBookTypes(context);
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
  Navigator.pushNamed(
    context,
    '/hero_room',
  );
}

gotoTeamHall(BuildContext context) {
  print('Debug: I will go to the team halls');
  Navigator.pushNamed(
    context,
    '/team_hall',
  );
}

_listofIndividualRankings(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  return ListView.builder(
      itemExtent: Constants.height_raking_items,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      itemCount: snapshot.data.documents.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) =>
          _buildListItem(context, snapshot.data.documents[index], index));
}

_buildListItem(BuildContext context, DocumentSnapshot item, int index) {
  PlayerPoints playerPoint = PlayerPoints.fromJson(item.data);
  String player_name = playerPoint.player_name;
  Future<Color> white;

  return FutureBuilder<Color>(
      future: ColorLogicbyPersonality(context),
      builder: (context, snapshotColor) {
        return Container(
          alignment: Alignment.center,
          color: snapshotColor.data,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextFormattedLabelOne('${index + 1}. '),
                  TextFormattedLabelTwo(
                      '$player_name', MediaQuery.of(context).size.height / 35),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextFormattedLabelTwo('${playerPoint.player_points} ',
                      MediaQuery.of(context).size.height / 35),
                  TextFormattedLabelThree('${Constants.unit_points}'),
                ],
              ),
              Divider(
                color: Colors.white,
              )
            ],
          ),
        );
      });
}

_listofTeamRankings(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  return ListView.builder(
      itemExtent: Constants.height_raking_items,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      itemCount: snapshot.data.documents.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) =>
          _buildListTeamItem(context, snapshot.data.documents[index], index));
}

_buildListTeamItem(BuildContext context, DocumentSnapshot item, int index) {
  TeamPoints teamPoint = TeamPoints.fromJson(item.data);
  String team_name = teamPoint.team_name;
  return FutureBuilder<Object>(
      future: ColorLogicbyPersonality(context),
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.center,
          color: snapshot.data,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextFormattedLabelOne('${index + 1}. '),
                  TextFormattedLabelTwo(
                      '$team_name', MediaQuery.of(context).size.height / 35),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextFormattedLabelTwo('${teamPoint.team_points} ',
                      MediaQuery.of(context).size.height / 35),
                  TextFormattedLabelThree('${Constants.unit_points}'),
                ],
              ),
              Divider(
                color: Colors.white,
              )
            ],
          ),
        );
      });
}
