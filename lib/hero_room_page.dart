import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:bob_mobile/widgets/text_formatted_room_label.dart';
import 'package:bob_mobile/widgets/text_formatted_room_label_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            ),
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
            SliverToBoxAdapter(
              child: TabBar(
                labelColor: colorLogicbyPersonality(context),
                unselectedLabelColor: ColorLogicbyRole(context),
                indicatorColor: colorLogicbyPersonality(context),
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.settings_input_composite),
                    child: Text('Items'),
                  ),
                  Tab(icon: Icon(Icons.view_week), child: Text('library')),
                  Tab(
                      icon: Icon(Icons.question_answer),
                      child: TextFormattedLabelTwo('Add Questions')),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  Container(
                    color: Colors.blueAccent,
                  ),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                ],
              ),
            ),
            SliverFillRemaining(
              child: Container(
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildListofItems(BuildContext context) {
  return StreamBuilder();
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
  Color random = RandomColor().randomColor();
  int item_count = 20;
  return new SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (item_count / 2).round(), childAspectRatio: 1),
    delegate: SliverChildBuilderDelegate((context, index) {
      return Container(
        height: 10,
        color: RandomColor().randomColor(),
      );
    }, childCount: item_count),
  );
}

class Delegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          color: Colors.yellow,
        ),
      );

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
