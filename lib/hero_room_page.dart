import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
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
    initistream(stream, context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: ColorLogicbyRole(context),
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(Constants.hero_room_title),
                titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                collapseMode: CollapseMode.parallax,
                background: Image(
                    image: AssetImage(Constants.myAvatars
                        .elementAt(Quanda.of(context).myUser.role - 1)
                        .asset_Large)),
              ),
              actions: <Widget>[]),
          SliverToBoxAdapter(
            child: Center(
              child:
                  TextFormattedRoomLabel(Constants.hero_stats_label, context),
            ),
          ),
          _buildStats(context, stream),
          SliverToBoxAdapter(
            child: Center(
              child:
                  TextFormattedRoomLabel(Constants.items_list_label, context),
            ),
          ),
          mytest(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

void initistream(Stream<DocumentSnapshot> stream, BuildContext context) {
  stream = Provider.of(context).fireBase.getClassStats(context);
}

Widget _buildStats(BuildContext context, Stream<DocumentSnapshot> stream) {
  stream = Provider.of(context).fireBase.getClassStats(context);
  return StreamBuilder(
    stream: stream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (!snapshot.hasError &&
          snapshot.connectionState == ConnectionState.active &&
          snapshot.hasData &&
          snapshot.data != null) {
        Quanda.of(context).myAvatarStats =
            AvatarStats.fromJson(snapshot.data.data);
        return SliverGrid.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 40,
          children: <Widget>[
            Container(
              color: Colors.green,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Quanda.of(context).myAvatarStats.additions.length,
                  itemBuilder: (context, index) => _buildAdditionsTile(context,
                      Quanda.of(context).myAvatarStats.additions, index)),
            ),
            Container(
              color: Colors.red,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Quanda.of(context).myAvatarStats.additions.length,
                  itemBuilder: (context, index) => _buildSubstractionsTile(
                      context,
                      Quanda.of(context).myAvatarStats.substractions,
                      index)),
            ),
          ],
        );
      } else {
        return SliverFillRemaining(
          child: Text('Loading'),
        );
      }
    },
  );
}

_buildAdditionsTile(
    BuildContext context, Map<dynamic, dynamic> additions, int index) {
  return Center(
    child: TextFormattedLabelTwo(
        '+ ${additions.values.toList().elementAt(index)} to '
        '${Quanda.of(context).bookTypes.elementAt(int.parse(additions.keys.toList().elementAt(index))).type}',
        20,
        Colors.white),
  );
}

_buildSubstractionsTile(
    BuildContext context, Map<dynamic, dynamic> subtractions, int index) {
  return Center(
    child: TextFormattedLabelTwo(
        '- ${subtractions.values.toList().elementAt(index)} to '
        '${Quanda.of(context).bookTypes.elementAt(int.parse(subtractions.keys.toList().elementAt(index))).type}',
        20,
        Colors.white),
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
        color: Colors.red,
      ),
      Container(
        height: 20,
        color: Colors.yellow,
      )
    ],
  );
}
