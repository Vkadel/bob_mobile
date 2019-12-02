import 'package:bob_mobile/battle_page.dart';
import 'package:bob_mobile/add_more_books_read.dart';
import 'package:bob_mobile/dashboard_page.dart';
import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/team_invites.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/loading_indicator_message.dart';
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
import 'helpers/constants.dart';
import 'data_type/avatar_stats.dart';
import 'data_type/items.dart';
import 'helpers/date_millis_to_string.dart';
import 'helpers/status_to_string.dart';

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
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(Constants.hero_room_title),
                titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                collapseMode: CollapseMode.parallax,
                background: FutureBuilder<Object>(
                    future: ColorLogicbyRole(context),
                    builder: (context, snapshot) {
                      return Container(
                        color: snapshot.data,
                        child: Image(
                            image: AssetImage(Constants.myAvatars
                                .elementAt(Quanda.of(context).myUser.role - 1)
                                .asset_Large)),
                      );
                    }),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child:
                    TextFormattedRoomLabel(Constants.hero_stats_label, context),
              ),
            ),
            _buildStats(context, stream),
            _buildSpacerBox(context),
            _buildOutstandingTeamInvitations(context),
            SliverToBoxAdapter(
              child: FutureBuilder<Object>(
                  future: ColorLogicbyRole(context),
                  builder: (context, snapshotRole) {
                    return FutureBuilder<Object>(
                        future: ColorLogicbyPersonality(context),
                        builder: (context, snapshotColorPersonality) {
                          return TabBar(
                            labelColor: snapshotColorPersonality.data,
                            unselectedLabelColor: snapshotRole.data,
                            indicatorColor: Constants.color_secondary,
                            tabs: <Widget>[
                              Tab(
                                icon: Icon(Icons.settings_input_composite),
                                child: Text('Items'),
                              ),
                              Tab(
                                  icon: Icon(Icons.view_week),
                                  child: Text('library')),
                              Tab(
                                  icon: Icon(Icons.question_answer),
                                  child:
                                      TextFormattedLabelTwo('Add Questions')),
                            ],
                          );
                        });
                  }),
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
                    _buildLibraryTab(),
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
    );
  }

  @override
  void dispose() {
    stream = null;
    super.dispose();
  }

  void showSnackBarOnHeroRoom(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}

Widget _buildLibraryTab() {
  int listSize;

  return Builder(
    builder: (context) {
      print('Will show list of books');
      return StreamBuilder(
          stream: FireProvider.of(context).fireBase.getUserData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData &&
                !snapshot.hasError) {
              DocumentSnapshot theData = snapshot.data;
              //Check if user profile
              UserData mUserData = UserData.fromJson(theData.data);
              Quanda.of(context).userData = mUserData;
              listSize = mUserData.list_of_read_books.length;
              if (listSize > 0) {
                //user has books I should display them
                return Container(
                  height: MediaQuery.of(context).size.width * 2,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return TextFormattedLabelTwo(
                            'You have read the following books: ');
                      } else {
                        if (index <= listSize) {
                          //These are books
                          return _buildBookTile(index - 1);
                        }
                        if (index > listSize) {
                          //This is the last element to add more books
                          return addMoreBooksButton(context);
                        }
                      }
                    },
                    itemCount: listSize + 2,
                  ),
                );
              } else {
                //Ask to add books
                return AddMoreBooksReadTab();
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingIndicatorMessage(
                message: 'Loading the books online',
              );
            } else {
              return Text('Oh No there is an error');
            }
          } //Builder Stream
          );
    },
  );
}

Widget addMoreBooksButton(BuildContext context) {
  return FutureBuilder<Object>(
      future: ColorLogicbyRole(context),
      builder: (context, snapshotColor) {
        Color color = snapshotColor.data;
        if (color != null) {
          return FlatButton.icon(
              shape: Border.all(color: color, width: 2),
              onPressed: () {
                print('I will launch add book screen');
                Navigator.of(context).pushNamed('/add_read_book');
              },
              icon: Icon(
                Icons.add,
                color: color,
              ),
              label: TextFormattedLabelTwo(
                  'Add Read Books',
                  MediaQuery.of(context).size.width / 20,
                  Future.value(snapshotColor.data),
                  null,
                  TextAlign.center));
        } else {
          return Container();
        }
      });
}

Widget _buildBookTile(int index) {
  return (Builder(
    builder: (context) {
      return StreamBuilder(
          stream: FireProvider.of(context).fireBase.getMasterListofBooks(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              var databack = snapshot.data;
              List<BooksMaster> myMasterBooks = databack.documents
                  .toList()
                  .map((item) => BooksMaster.fromJson(item.data))
                  .toList();
              Quanda.of(context).listOfMasterBooks = myMasterBooks;
              int indexForThisBookInMaster = Quanda.of(context)
                  .listOfMasterBooks
                  .indexWhere((item) =>
                      item.id ==
                      Quanda.of(context)
                          .userData
                          .list_of_read_books
                          .elementAt(index)
                          .bookId);
              String bookName = Quanda.of(context)
                  .listOfMasterBooks
                  .elementAt(indexForThisBookInMaster)
                  .name;
              String status = StatusToString(Quanda.of(context)
                      .userData
                      .list_of_read_books
                      .elementAt(index))
                  .getStatus();
              return FutureBuilder<Object>(
                  future: ColorLogicbyRole(context),
                  builder: (context, snapshotColor) {
                    return Card(
                      color: snapshotColor.data,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextFormattedLabelTwo(bookName),
                            TextFormattedLabelTwo(status),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return LoadingIndicatorMessage(
                message: 'loading item: ${index}',
              );
            }
          });
    },
  ));
}

Widget _buildOutstandingTeamInvitations(context) {
  return Builder(builder: (BuildContext context) {
    //Todo: make this the opposite
    bool dontHaveTeam =
        !NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot();
    if (dontHaveTeam) {
      //Show Invitation list
      return StreamBuilder(
        stream: FireProvider.of(context)
            .fireBase
            .getOutstandingTeamInvitations(context),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.connectionState == ConnectionState.active &&
              snapShot.hasData) {
            Quanda.of(context).pendingTeamInvites = snapShot.data.documents
                .map((snapShotItem) => TeamInvites.fromJson(snapShotItem.data))
                .toList();
            return SliverToBoxAdapter(
              child: Container(
                height: 200,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(0),
                          height: index == 0
                              ? MediaQuery.of(context).size.width / 10
                              : MediaQuery.of(context).size.width / 4,
                          child: Column(
                            children: <Widget>[
                              index == 0
                                  ? Container(
                                      padding: EdgeInsets.all(0),
                                      alignment: Alignment.center,
                                      child: TextFormattedLabelTwo(
                                          'Pending Invitations',
                                          MediaQuery.of(context).size.width /
                                              15,
                                          ColorLogicbyRole(context)),
                                    )
                                  : _pendingInvitationChildItem(
                                      TeamInvites.fromJson(snapShot
                                          .data.documents
                                          .elementAt(index - 1)
                                          .data),
                                      context,
                                      index),
                            ],
                          ),
                        );
                      }, childCount: snapShot.data.documents.length + 1),
                    )
                  ],
                ),
              ),
            );
          } else {
            //Have a loading if the
            return SliverToBoxAdapter(
              child: Container(
                child: LoadingIndicatorMessage(
                  message: 'Checking for team invites',
                ),
              ),
            );
          }
        },
      );
    } else {
      //Show empty
      return returnEmpty();
    }
  });
}

Widget _pendingInvitationChildItem(
    TeamInvites teamInvites, BuildContext context, int index) {
  return ListTile(
    dense: true,
    leading: Icon(Icons.hourglass_empty),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          child: TextFormattedLabelTwo(
              '${teamInvites.from} has invited you to ${teamInvites.team_name}',
              MediaQuery.of(context).size.width / 30,
              ColorLogicbyPersonality(context),
              null,
              TextAlign.justify),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              //Todo anim for accept
              print('I accept this invitation ${index}');
              FireProvider.of(context)
                  .fireBase
                  .acceptTeamInvite(index - 1, context);
            },
            child: TextFormattedLabelTwo(
                'Accept',
                MediaQuery.of(context).size.width / 20,
                ColorLogicbyPersonality(context)),
          ),
        )
      ],
    ),
    subtitle: TextFormattedLabelTwo(
        new DateMillisToString(teamInvites.date_sent).getDateString()),
  );
}

Widget _buildButtonsForBattle(BuildContext context) {
  return Builder(
    builder: (BuildContext context) {
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
              startFightForYourself,
              true),
          CreateLargeButtonWithSVGOverlap(
              'Fight for the Team',
              'assets/fight_for_your_team.svg',
              context,
              Radius.circular(0),
              Radius.circular(20),
              Radius.circular(0),
              Radius.circular(20),
              startFightForTheTeam,
              NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()
                  ? false
                  : true),
        ],
      );
    },
  );
}

void startFightForYourself(BuildContext context) {
  print('The fight starts for yourself');
  Quanda.of(context).personal = true;
  pushFightRoom(context);
}

void startFightForTheTeam(BuildContext context) {
  if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
    print('Player has a team will check if ready to earn points');
    print('Refreshing team from online');
    FireProvider.of(context)
        .fireBase
        .getTeam(context, Quanda.of(context).myUser.team_id);
    if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot() &&
        Quanda.of(context).myTeam.teamIsActive != null &&
        Quanda.of(context).myTeam.teamIsActive) {
      print('The fight starts for yourself');
      Quanda.of(context).personal = false;
      pushFightRoom(context);
    }
    if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot() &&
        Quanda.of(context).myTeam.teamIsActive != null &&
        !Quanda.of(context).myTeam.teamIsActive) {
      print('Team exist but is not ready');
      SnackBarMessage(
          'Make sure your team is full and all the invitations accepted',
          context);
    }
  } else {
    print('Player cannot compete for team');
    if (!NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
      print('The player doesnt have a team');
      SnackBarMessage(
          'Please create or join a team before you can earn points', context);
    }
  }
}

void pushFightRoom(BuildContext context) {
  if (!Quanda.of(context).playeReadNoBooks) {
    Navigator.pushNamed(
      context,
      '/fight',
    );
  } else {
    SnackBarMessage(
        'You currently have any books logged in your library, add some before you can fight',
        context);
  }
}

Widget CreateLargeButtonWithSVGOverlap(
    String text,
    String svgPath,
    BuildContext context,
    Radius topLeft,
    Radius topRight,
    Radius bottomLeft,
    Radius bottomRight,
    Function myAction,
    bool enabled) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder<Object>(
        future: ColorLogicbyRole(context),
        builder: (context, snapshotByRole) {
          return FutureBuilder<Object>(
              future: ColorLogicbyPersonality(context),
              builder: (context, snapshotPersonality) {
                return RaisedButton(
                  elevation: enabled ? 16 : 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: topLeft,
                          topRight: topRight,
                          bottomLeft: bottomLeft,
                          bottomRight: bottomRight),
                      side: BorderSide(
                          color: snapshotPersonality.data != null
                              ? snapshotPersonality.data
                              : Theme.of(context).buttonColor,
                          width: 0)),
                  color: enabled ? snapshotByRole.data : Colors.grey,
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
                        child: TextFormattedLabelTwo(text, 18),
                        alignment: Alignment.bottomCenter,
                      ),
                    ],
                  ),
                  onPressed: () {
                    myAction(context);
                  },
                );
              });
        }),
  );
}

Widget _buildListofItems(BuildContext context) {
  return FutureBuilder(
    future: FireProvider.of(context).fireBase.getMyItems(context),
    builder: (BuildContext context, AsyncSnapshot snapshotStream) {
      return StreamBuilder(
          stream: snapshotStream.data,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingIndicatorMessage(
                message: 'Loading Items',
              ));
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
    },
  );
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

//Todo: Move to Widgets
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
      ),
      subtitle: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            TextFormattedLabelTwo(
                '+ ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).addition} to questions gains',
                15),
            TextFormattedLabelTwo(
              '- ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).subtraction} to questions loses',
              15,
            )
          ],
        ),
      ),
      trailing: TextFormattedLabelTwo('Expires: ${formatter.format(date)}',
          MediaQuery.of(context).size.width / 30),
    ),
  );
}

//Todo: Move to Widgets
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
      ),
      subtitle: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            TextFormattedLabelTwo(
              '+ ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).addition} to questions gains',
              MediaQuery.of(context).size.width / 30,
            ),
            TextFormattedLabelTwo(
              '- ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).subtraction} to questions loses',
              MediaQuery.of(context).size.width / 30,
            )
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
        child: TextFormattedLabelTwo('use', 15),
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
                  MediaQuery.of(context).size.width / 19),
            ],
          ),
        ));
  }
}

void _initStream(Stream<DocumentSnapshot> stream, BuildContext context) async {
  stream = await FireProvider.of(context).fireBase.getClassStats(context);
}

Widget _buildStats(BuildContext context, Stream<DocumentSnapshot> stream) {
  return FutureBuilder(
    future: FireProvider.of(context).fireBase.getClassStats(context),
    builder: (BuildContext context, AsyncSnapshot snapshotStream) {
      if (snapshotStream.hasData) {
        return StreamBuilder(
          stream: snapshotStream.data,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasError &&
                snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData &&
                snapshot.data != null) {
              Quanda.of(context).myAvatarStats =
                  AvatarStats.fromJson(snapshot.data.data);
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 10,
                    mainAxisSpacing: 0),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.centerLeft,
                          color: Colors.green,
                          child: _buildAdditionsTile(
                              context,
                              Quanda.of(context).myAvatarStats.additions,
                              index),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          color: Colors.red,
                          child: _buildSubstractionsTile(
                              context,
                              Quanda.of(context).myAvatarStats.substractions,
                              index),
                        )
                      ],
                    ),
                  );
                },
                    childCount:
                        Quanda.of(context).myAvatarStats.additions.length),
              );
            } else {
              return SliverFillRemaining(
                child: LoadingIndicatorMessage(
                  message: 'Loading Stream stats...',
                ),
              );
            }
          },
        );
      } else {
        return SliverFillRemaining(
            child:
                LoadingIndicatorMessage(message: 'Loading future stats ...'));
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
          20),
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
          20),
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
