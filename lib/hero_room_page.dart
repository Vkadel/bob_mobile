import 'package:bob_mobile/battle_page.dart';
import 'package:bob_mobile/add_more.dart';
import 'package:bob_mobile/library_tab.dart';
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
    /* _initStream(stream, context);*/
    String heroPoints = "";
    try {
      heroPoints = '${Quanda.of(context).myPlayerPoints.player_points} points';
    } catch (e) {
      print(e);
    }
    return WillPopScope(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                actions: <Widget>[Text(heroPoints)],
                pinned: true,
                floating: true,
                expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(Quanda.of(context).myUser.name),
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
                  child: TextFormattedRoomLabel(
                      Constants.hero_stats_label, context),
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
                      Center(
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.build),
                            TextFormattedLabelTwo(
                                'Chat feature is under construction...',
                                MediaQuery.of(context).size.width / 20,
                                Future.value(Colors.black))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildSpacerBox(context),
              _prepareButtonsForBattle(context),
              _buildSpacerBox(context)
            ],
          ),
        ),
      ),
      onWillPop: () {
        Navigator.pop(context, true);
      },
    );
  }

  void showSnackBarOnHeroRoom(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  void didChangeDependencies() {
    try {
      if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
        FireProvider.of(context)
            .fireBase
            .getTeam(context, Quanda.of(context).myUser.team_id.toLowerCase());
      }
    } catch (e) {
      print(e);
    }
  }
}

Widget _buildLibraryTab() {
  int listSize;

  return Builder(
    builder: (context) {
      print('Device pixel ratio: ${MediaQuery.of(context).devicePixelRatio}');
      print('Will show list of books');
      return FutureBuilder(
        future: FireProvider.of(context).fireBase.getUserData(context),
        builder: (BuildContext context, AsyncSnapshot snapshotStream) {
          if (snapshotStream.hasData) {
            return StreamBuilder(
                stream: snapshotStream.data,
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LoadingIndicatorMessage(
                      message: 'Loading the books online',
                    );
                  } else {
                    return Text('Oh No there is an error');
                  }
                } //Builder Stream
                );
          } else {
            return Container();
          }
        },
      );
    },
  );
}

Widget addMoreBooksButton(BuildContext context) {
  return addMoreButton('Add Read Books', () {
    print('I will launch add book screen');
    Navigator.of(context).pushNamed('/add_read_book');
  }, false);
}

Widget addMoreItemsButton(BuildContext context) {
  return addMoreButton('Add More Items', () {
    print('I will launch add items screen');
    Navigator.of(context).pushNamed('/shop_page');
  }, true);
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
                    print('Adjusting font for book title');
                    double bookTitleFont =
                        MediaQuery.of(context).size.width / 15;
                    (bookName.length > 14 && bookName.length <= 25)
                        ? bookTitleFont = bookTitleFont - 2
                        : null;
                    (bookName.length > 25 && bookName.length <= 30)
                        ? bookTitleFont = bookTitleFont - 4
                        : null;
                    (bookName.length > 30)
                        ? bookTitleFont = bookTitleFont - 10
                        : null;
                    print('Book tittle font:${bookTitleFont}');
                    return Card(
                      color: snapshotColor.data,
                      child: ListTile(
                        title: Text(
                          bookName,
                          style: TextStyle(
                              color: Colors.white, fontSize: bookTitleFont),
                          maxLines: 2,
                        ),
                        subtitle: TextFormattedLabelTwo(
                            status, MediaQuery.of(context).size.width / 25),
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
      print('User does not have a team we will check invitations');
      return StreamBuilder(
        stream: FireProvider.of(context)
            .fireBase
            .getOutstandingTeamInvitations(context),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
          print('Firestore returned to Invitations');
          switch (snapShot.connectionState) {
            case ConnectionState.none:
              return SliverToBoxAdapter(
                child: Container(
                  child: LoadingIndicatorMessage(
                    message: 'Checking for team invites',
                  ),
                ),
              );
              break;
            case ConnectionState.waiting:
              print('Waiting on user invites');
              return returnEmpty();
              break;
            case ConnectionState.active:
              print('User invites were recieved');
              return _buildOrderInvitationList(snapShot, context);
              break;
            case ConnectionState.done:
              return returnEmpty();
              /*return _buildOrderInvitationList(snapShot, context);*/
              break;
          }
        },
      );
    } else {
      print('User has a team');
      return returnEmpty();
    }
  });
}

Widget _buildOrderInvitationList(
    AsyncSnapshot<QuerySnapshot> snapShot, BuildContext context) {
  if (snapShot.hasData && snapShot.data.documents.length > 0) {
    print('Have invitations');
    Quanda.of(context).pendingTeamInvites = snapShot.data.documents
        .map((snapShotItem) => TeamInvites.fromJson(snapShotItem.data))
        .toList();
    Quanda.of(context)
        .pendingTeamInvites
        .sort((a, b) => a.date_sent.compareTo(b.date_sent));
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
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
                                  MediaQuery.of(context).size.width / 15,
                                  ColorLogicbyRole(context)),
                            )
                          : _pendingInvitationChildItem(
                              TeamInvites.fromJson(snapShot.data.documents
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
    return returnEmpty();
  }
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

Widget _prepareButtonsForBattle(BuildContext context) {
  return FutureBuilder(
      future: FireProvider.of(context).fireBase.getUserData(context),
      builder: (BuildContext context, AsyncSnapshot snapshotStream) {
        switch (snapshotStream.connectionState) {
          case ConnectionState.none:
            return SliverToBoxAdapter(
              child: TextFormattedLabelTwo(
                'There is no connection check again later....',
              ),
            );
            break;
          case ConnectionState.waiting:
            return SliverToBoxAdapter(
              child: LoadingIndicatorMessage(
                message: 'Getting the books from your future library online',
              ),
            );
            break;
          case ConnectionState.active:
            return snapshotStream.hasData
                ? _createButtonsForBattle(snapshotStream)
                : returnEmpty();
            break;
          case ConnectionState.done:
            return snapshotStream.hasData
                ? _createButtonsForBattle(snapshotStream)
                : returnEmpty();
            break;
        }
      });
}

Widget _createButtonsForBattle(snapshotStream) {
  return StreamBuilder<DocumentSnapshot>(
      stream: snapshotStream.data,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return SliverToBoxAdapter(
              child: TextFormattedLabelTwo(
                'There is no connection check again later....',
              ),
            );
            break;
          case ConnectionState.waiting:
            print('Connection status waiting');
            return SliverToBoxAdapter(
              child: LoadingIndicatorMessage(
                message: 'Getting the books from your library online',
              ),
            );
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              UserData user_data = UserData.fromJson(snapshot.data.data);
              Quanda.of(context).userData = user_data;
              Quanda.of(context).playeReadNoBooks = false;
              print('I got books back I will build list');
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
                          (Quanda.of(context).userData != null &&
                                  Quanda.of(context)
                                          .userData
                                          .list_of_read_books
                                          .length >
                                      0)
                              ? true
                              : false),
                      CreateLargeButtonWithSVGOverlap(
                          'Fight for the Team',
                          'assets/fight_for_your_team.svg',
                          context,
                          Radius.circular(0),
                          Radius.circular(20),
                          Radius.circular(0),
                          Radius.circular(20),
                          startFightForTheTeam,
                          (NotNullNotEmpty(Quanda.of(context).myUser.team_id)
                                      .isnot() &&
                                  Quanda.of(context).myTeam.teamIsActive &&
                                  Quanda.of(context)
                                          .userData
                                          .list_of_read_books
                                          .length >
                                      0)
                              ? true
                              : false),
                    ],
                  );
                },
              );
            }
            break;
          case ConnectionState.done:
            break;
        }
      });
}

void startFightForYourself(BuildContext context, bool enabled) async {
  print('Refreshing user_data online');
  await FireProvider.of(context).fireBase.getUserData(context);
  if (enabled) {
    print('The fight starts for yourself');
    Quanda.of(context).personal = true;
    pushFightRoom(context);
  } else {
    SnackBarMessage(
        'Make sure you have recorded read books in your library', context);
  }
}

void startFightForTheTeam(BuildContext context, bool enabled) async {
  if (enabled) {
    print('Player has a team will check if ready to earn points');
    print('Refreshing team from online');
    await FireProvider.of(context)
        .fireBase
        .getTeam(context, Quanda.of(context).myUser.team_id);
    if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot() &&
        Quanda.of(context).myTeam.teamIsActive != null &&
        Quanda.of(context).myTeam.teamIsActive) {
      print('The fight starts for the team');
      Quanda.of(context).personal = false;
      pushFightRoom(context);
    }
  } else {
    print('Player cannot compete for team');
    if (!NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
      print('The player doesnt have a team');
      SnackBarMessage(
          'Please create or join a team before you can earn points', context);
    }
    if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot() &&
        Quanda.of(context).myTeam.teamIsActive != null &&
        !Quanda.of(context).myTeam.teamIsActive) {
      print('Team exist but is not ready');
      SnackBarMessage(
          'Make sure your team is full and all the invitations accepted',
          context);
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
  print('Creating battle button, status: ${enabled}');
  print(Quanda.of(context).myUser.team_id);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder<Object>(
        future: ColorLogicbyRole(context),
        builder: (context, snapshotByRole) {
          return FutureBuilder<Color>(
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
                    myAction(context, enabled);
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
          items = snapshot.data.documents
              .toList()
              .map((f) => ItemsMaster.fromJson(f.data))
              .toList();
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
      itemCount: Quanda.of(context).myItems.length + 1,
    ),
  );
}

Widget _creatTileForItem(int index, BuildContext context) {
  //TODO: Remove Expired Items, don't Trust the system
  if (index == Quanda.of(context).myItems.length) {
    //Create button to go to shop
    return addMoreItemsButton(context);
  } else {
    if (!Quanda.of(context).myItems.elementAt(index).inuse) {
      return _cardForItemCanBeUsed(index, context);
    } else if (Quanda.of(context).myItems.elementAt(index).inuse) {
      return _cardForItemInUse(index, context);
    }
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
                '+ ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).addition} ${Constants.buff_gain}',
                15),
            TextFormattedLabelTwo(
              '- ${Quanda.of(context).masterListOfItems.elementAt(Quanda.of(context).myItems.elementAt(index).item).subtraction} ${Constants.buff_loss}',
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

/*void _initStream(Stream<DocumentSnapshot> stream, BuildContext context) async {
  stream = await FireProvider.of(context).fireBase.getClassStats(context);
}*/

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
  String textForBox;
  try {
    textForBox = '+ ${additions.values.toList().elementAt(index)} to '
        '${Quanda.of(context).bookTypes.elementAt(int.parse(additions.keys.toList().elementAt(index))).type}';
  } catch (e) {
    textForBox = '';
    print(e);
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: TextFormattedLabelTwo(textForBox, 20),
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
