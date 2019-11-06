import 'package:bob_mobile/data_type/items_master.dart';
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
import 'package:intl/intl.dart';
import 'constants.dart';
import 'data_type/avatar_stats.dart';
import 'data_type/items.dart';

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
    _initStream(stream, context);
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
                labelColor: ColorLogicbyPersonality(context),
                unselectedLabelColor: ColorLogicbyRole(context),
                indicatorColor: Constants.color_secondary,
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
            SliverToBoxAdapter(
              child: Container(
                height: Constants.height_lists_hero_page,
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.blueAccent,
                      child: _buildListofItems(context),
                    ),
                    Icon(Icons.directions_transit),
                    Icon(Icons.directions_bike),
                  ],
                ),
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
  return StreamBuilder(
      stream: Provider.of(context).fireBase.getMyItems(context),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null) {
          List<Items> myItemsBuild = new List();
          snapshot.data.documents
              .toList()
              .forEach((f) => myItemsBuild.add(Items.fromJson(f.data)));
          Quanda.of(context).myItems = myItemsBuild;
          return _buildListofMarterItems(context);
        } else {
          return youDontHaveItems(context);
        }
      });
}

Widget _buildListofMarterItems(BuildContext context) {
  return StreamBuilder(
      stream: Provider.of(context).fireBase.getMasterListOfItems(context),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null) {
          List<ItemsMaster> items = new List();
          snapshot.data.documents
              .forEach((f) => items.add(ItemsMaster.fromJson(f.data)));
          Quanda.of(context).masterListOfItems = items;
          return Container(
            color: ColorLogicbyPersonality(context),
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _creatTileForItem(index, context),
              itemCount: Quanda.of(context).myItems.length,
            ),
          );
        } else {
          return youDontHaveItems(context);
        }
      });
}

Widget _creatTileForItem(int index, BuildContext context) {
  //TODO: Remove Expired Items, don't Trust the system

  if (Quanda.of(context).myItems.elementAt(index).status == 1) {
    return _cardForItemCanBeUsed(index, context);
  } else if (Quanda.of(context).myItems.elementAt(index).status == 2) {
    return _cardForItemInUse(index, context);
  }
}

//TOdo: Move to Widgets
Widget _cardForItemInUse(int index, BuildContext context) {
  var formatter = new DateFormat('dd-MM-yyyy');
  DateTime date = DateTime.fromMillisecondsSinceEpoch(
      Quanda.of(context).myItems.elementAt(index).endDate);
  print('${DateTime.now().millisecondsSinceEpoch}');
  print('Today: ${formatter.format(DateTime.now())}');
  print('Date expiration mili: ${date.toUtc()}');
  print('Date expiration date: ${date}');
  return Card(
    elevation: Constants.card_elevation,
    color: RandomColor().randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorHue: getColorHueByPersonality(context)),
    child: ListTile(
      dense: true,
      title: TextFormattedLabelTwo(
          '${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).name}',
          MediaQuery.of(context).size.width / 15,
          Colors.white),
      subtitle: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            TextFormattedLabelTwo(
                '+ ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).addition} to questions gains',
                15,
                Colors.white),
            TextFormattedLabelTwo(
                '- ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).subtraction} to questions loses',
                15,
                Colors.white)
          ],
        ),
      ),
      trailing: TextFormattedLabelTwo('Expires: ${formatter.format(date)}',
          MediaQuery.of(context).size.width / 30, Colors.white),
    ),
  );
}

//TOdo: Move to Widgets
Widget _cardForItemCanBeUsed(int index, BuildContext context) {
  return Card(
    elevation: Constants.card_elevation,
    color: RandomColor().randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorHue: getColorHueByPersonality(context)),
    child: ListTile(
      dense: true,
      title: TextFormattedLabelTwo(
          '${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).name}',
          MediaQuery.of(context).size.width / 15,
          Colors.white),
      subtitle: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            TextFormattedLabelTwo(
                '+ ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).addition} to questions gains',
                MediaQuery.of(context).size.width / 30,
                Colors.white),
            TextFormattedLabelTwo(
                '- ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).subtraction} to questions loses',
                MediaQuery.of(context).size.width / 30,
                Colors.white)
          ],
        ),
      ),
      trailing: FlatButton(
        onPressed: () {
          print('I will use this item');
          Provider.of(context).fireBase.useItem(
              context,
              Quanda.of(context).myItems.elementAt(index),
              Quanda.of(context)
                  .masterListOfItems
                  .elementAt(index)
                  .duration_days);
        },
        child: TextFormattedLabelTwo('use', 15, Colors.white),
      ),
    ),
  );
}

//Todo: Move to Widgets
Widget youDontHaveItems(context) {
  return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          children: <Widget>[
            TextFormattedLabelTwo(Constants.you_dont_have_items,
                MediaQuery.of(context).size.width / 19, Colors.white),
          ],
        ),
      ));
}

void _initStream(Stream<DocumentSnapshot> stream, BuildContext context) {
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
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 10, mainAxisSpacing: 0),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.centerLeft,
                    color: Colors.green,
                    child: _buildAdditionsTile(context,
                        Quanda.of(context).myAvatarStats.additions, index),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.red,
                    child: _buildSubstractionsTile(context,
                        Quanda.of(context).myAvatarStats.substractions, index),
                  )
                ],
              ),
            );
          }, childCount: Quanda.of(context).myAvatarStats.additions.length),
        );
      } else {
        return SliverFillRemaining(
          child: Center(
            child: Text('Loading.....'),
          ),
        );
      }
    },
  );
}

_buildAdditionsTile(
    BuildContext context, Map<dynamic, dynamic> additions, int index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: TextFormattedLabelTwo(
          '+ ${additions.values.toList().elementAt(index)} to '
          '${Quanda.of(context).bookTypes.elementAt(int.parse(additions.keys.toList().elementAt(index))).type}',
          20,
          Colors.white),
    ),
  );
}

_buildSubstractionsTile(
    BuildContext context, Map<dynamic, dynamic> subtractions, int index) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: TextFormattedLabelTwo(
          '- ${subtractions.values.toList().elementAt(index)} to '
          '${Quanda.of(context).bookTypes.elementAt(int.parse(subtractions.keys.toList().elementAt(index))).type}',
          20,
          Colors.white),
    ),
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
