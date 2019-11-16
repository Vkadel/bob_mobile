import 'package:bob_mobile/battle_page.dart';
import 'package:bob_mobile/dashboard_page.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:bob_mobile/widgets/text_formatted_room_label.dart';
import 'package:bob_mobile/widgets/text_formatted_room_label_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return WillPopScope(
      child: DefaultTabController(
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
                  child: TextFormattedRoomLabel(
                      Constants.hero_stats_label, context),
                ),
              ),
              _buildStats(context, stream),
              _buildSpacerBox(context),
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
                        height: MediaQuery.of(context).size.width * 2,
                        child: _buildListofItems(context),
                      ),
                      Icon(Icons.directions_transit),
                      Icon(Icons.directions_bike),
                    ],
                  ),
                ),
              ),
              _buildSpacerBox(context),
              _buildButtonsForBattle(context),
              _buildSpacerBox(context)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stream = null;
    super.dispose();
  }
}

Widget _buildButtonsForBattle(BuildContext context) {
  return SliverGrid.count(
    crossAxisCount: 2,
    children: <Widget>[
      CreateLargeButtonWithSVGOverlap(
          'Fight for Yourself',
          'assets/fight_for_yourself.svg',
          context,
          Radius.circular(20),
          Radius.circular(0),
          Radius.circular(20),
          Radius.circular(0),
          startFightForYourself),
      CreateLargeButtonWithSVGOverlap(
          'Fight for the Team',
          'assets/fight_for_your_team.svg',
          context,
          Radius.circular(0),
          Radius.circular(20),
          Radius.circular(0),
          Radius.circular(20),
          startFightForTheTeam)
    ],
  );
}

void startFightForYourself(BuildContext context) {
  print('The fight starts for yourself');
  Quanda.of(context).personal = true;
  pushFightRoom(context);
}

void startFightForTheTeam(BuildContext context) {
  print('The fight starts for yourself');
  Quanda.of(context).personal = false;
  pushFightRoom(context);
}

void pushFightRoom(BuildContext context) {
  Navigator.pushNamed(
    context,
    '/fight',
  );
}

Widget CreateLargeButtonWithSVGOverlap(
    String text,
    String svgPath,
    BuildContext context,
    Radius topLeft,
    Radius topRight,
    Radius bottomLeft,
    Radius bottomRight,
    Function myAction) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: RaisedButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: topLeft,
              topRight: topRight,
              bottomLeft: bottomLeft,
              bottomRight: bottomRight),
          side: BorderSide(color: ColorLogicbyRole(context), width: 0)),
      color: ColorLogicbyPersonality(context),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SvgPicture.asset(
              svgPath,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: TextFormattedLabelTwo(text, 18, Colors.white),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
      onPressed: () {
        myAction(context);
      },
    ),
  );
}

Widget _buildListofItems(BuildContext context) {
  return StreamBuilder(
      stream: FireProvider.of(context).fireBase.getMyItems(context),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        //Refresh Items if this list has already been loaded
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data.documentChanges != null) {
          print('I have document changes and will rebuild');
          if (Quanda.of(context).masterListOfItems != null &&
              Quanda.of(context).masterListOfItems.length > 0) {
            return _refreshList(snapshot, context);
          }
        }
        //Load items the first time and initialize masters
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null) {
          print('Rebuilding List for the first time');
          return _buildListForFirstTime(snapshot, context);
        } else {
          return _youDontHaveItems(context, snapshot);
        }
      });
}

Widget _refreshList(
    AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
  List<Items> myItemsBuild = new List();
  snapshot.data.documents
      .toList()
      .forEach((f) => myItemsBuild.add(Items.fromJson(f.data)));
  try {
    myItemsBuild.forEach((f) => {
          Quanda.of(context).myItems.removeAt(
              Quanda.of(context).myItems.indexWhere((test) => test.id == f.id))
        });
  } catch (e) {
    print(e);
  }
  Quanda.of(context).myItems.insertAll(0, myItemsBuild);
  Quanda.of(context).myItems = myItemsBuild;
  if (Quanda.of(context).myItems != null) {
    return _createFinalListOfItems(context);
  }
}

Widget _buildListForFirstTime(
    AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
  List<Items> myItemsBuild = new List();
  snapshot.data.documents
      .toList()
      .forEach((f) => myItemsBuild.add(Items.fromJson(f.data)));
  Quanda.of(context).myItems = myItemsBuild;
  return _buildListofMasterItems(context);
}

Widget _buildListofMasterItems(BuildContext context) {
  return StreamBuilder(
      stream: FireProvider.of(context).fireBase.getMasterListOfItems(context),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasError &&
            snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null) {
          List<ItemsMaster> items = new List();
          snapshot.data.documents
              .forEach((f) => items.add(ItemsMaster.fromJson(f.data)));
          Quanda.of(context).masterListOfItems = items;
          return _createFinalListOfItems(context);
        } else {
          return _youDontHaveItems(context, snapshot);
        }
      });
}

Widget _createFinalListOfItems(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.width,
    child: ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      shrinkWrap: true,
      itemBuilder: (context, index) => _creatTileForItem(index, context),
      itemCount: Quanda.of(context).myItems.length,
    ),
  );
}

Widget _creatTileForItem(int index, BuildContext context) {
  //TODO: Remove Expired Items, don't Trust the system

  if (!Quanda.of(context).myItems.elementAt(index).inuse) {
    return _cardForItemCanBeUsed(index, context);
  } else if (Quanda.of(context).myItems.elementAt(index).inuse) {
    return _cardForItemInUse(index, context);
  }
}

//TOdo: Move to Widgets
Widget _cardForItemInUse(int index, BuildContext context) {
  var formatter = new DateFormat('MM-dd-yyyy');
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
          FireProvider.of(context).fireBase.useItem(
              context,
              Quanda.of(context).myItems.elementAt(index),
              Quanda.of(context)
                  .masterListOfItems
                  .elementAt(index)
                  .duration_days);
          return CircularProgressIndicator();
        },
        child: TextFormattedLabelTwo('use', 15, Colors.white),
      ),
    ),
  );
}

//Todo: Move to Widgets
Widget _youDontHaveItems(context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
  } else {
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
}

void _initStream(Stream<DocumentSnapshot> stream, BuildContext context) {
  stream = FireProvider.of(context).fireBase.getClassStats(context);
}

Widget _buildStats(BuildContext context, Stream<DocumentSnapshot> stream) {
  stream = FireProvider.of(context).fireBase.getClassStats(context);
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
        crossAxisCount: (item_count / 2).round(), childAspectRatio: 2),
    delegate: SliverChildBuilderDelegate((context, index) {
      return Container(
        height: 10,
        color: RandomColor().randomColor(),
      );
    }, childCount: item_count),
  );
}

Widget _buildSpacerBox(BuildContext context) {
  return SliverToBoxAdapter(
    child: Container(
      height: MediaQuery.of(context).size.width / 16,
    ),
  );
}
