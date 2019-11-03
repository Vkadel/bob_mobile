import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/text_formatted_room_label.dart';
import 'package:bob_mobile/widgets/text_formatted_room_label_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'data_type/avatar_stats.dart';

class HeroRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HeroPageState();
  }
}

class _HeroPageState extends State<HeroRoomPage> {
  Stream<DocumentSnapshot> stream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              backgroundColor: ColorLogicbyRole(context),
              expandedHeight: 180.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(Constants.hero_room_title),
                titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                collapseMode: CollapseMode.parallax,
                background: Image(
                    image: AssetImage(Constants.myAvatars
                        .elementAt(Quanda.of(context).myUser.role - 1)
                        .asset_Large)),
              ),
              actions: <Widget>[]),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: TextFormattedRoomLabel(
                      Constants.hero_stats_label, context),
                ),
              ],
            ),
          ),
          _buildStats(context, stream),
          mytest(),
          mytest(),
          mytest(),
        ],
      ),
    );
  }
}

Widget _buildStats(BuildContext context, Stream<DocumentSnapshot> stream) {
  return StreamBuilder(
    stream: Provider.of(context).fireBase.getClassStats(context),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (!snapshot.hasError &&
          snapshot.connectionState == ConnectionState.active &&
          snapshot.hasData &&
          snapshot.data != null) {
        Quanda.of(context).myAvatarStats =
            AvatarStats.fromJson(snapshot.data.data);
        return SliverGrid.count(
          crossAxisCount: 2,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: Quanda.of(context).myAvatarStats.additions.length,
                itemBuilder: (context, index) => _buildListofAdditions(context,
                    Quanda.of(context).myAvatarStats.additions, index)),
            ListView.builder(
                shrinkWrap: true,
                itemCount: Quanda.of(context).myAvatarStats.additions.length,
                itemBuilder: (context, index) => _buildListofAdditions(context,
                    Quanda.of(context).myAvatarStats.additions, index)),
          ],
        );
      } else {
        return new SliverList(
          delegate: SliverChildListDelegate(
            [],
          ),
        );
      }
    },
  );
}

_buildListofAdditions(
    BuildContext context, Map<dynamic, dynamic> additions, int index) {
  String item = additions[0];
  return ListTile(
    title: TextFormattedRoomLabelBody(
        '+ ${additions.values.toList().elementAt(index)} to '
        '${Quanda.of(context).bookTypes.elementAt(int.parse(additions.keys.toList().elementAt(index))).type}',
        context),
  );
}

_buildListofSubstractions(
    BuildContext context, Map<dynamic, dynamic> subtractions, int index) {
  return ListTile(
    title: TextFormattedRoomLabelBody(
        'Plus ${subtractions.values.toList().elementAt(index)} to '
        '${Quanda.of(context).bookTypes.elementAt(int.parse(subtractions.keys.toList().elementAt(index))).type}',
        context),
  );
}

SliverGrid mytest() {
  return new SliverGrid.count(
    crossAxisCount: 3,
    children: <Widget>[
      Container(
        height: 20,
        color: Colors.orange,
      ),
      Container(
        height: 20,
        color: Colors.blue,
      ),
      Container(
        height: 20,
        color: Colors.green,
      ),
      Container(
        height: 20,
        color: Colors.purple,
      ),
      Container(
        height: 20,
        color: Colors.yellow,
      ),
      Container(
        height: 20,
        color: Colors.red,
      )
    ],
  );
}
