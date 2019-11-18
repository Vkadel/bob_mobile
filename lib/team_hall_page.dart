import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class TeamHallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
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
          _buildPageBody(context),
        ],
      ),
    );
  }
}

Widget _buildPageBody(BuildContext context) {
  if (Quanda.of(context).myUser.team_id == null ||
      Quanda.of(context).myUser.team_id.isEmpty) {
    return _buildYourTeamPage(context);
  } else {
    return _buildteamManagement(context);
  }
}

Widget _buildYourTeamPage(context) {
  final _formKey = GlobalKey<FormState>();
  List<PlayerPoints> listOfPlayers = Quanda.of(context).playerRankings;
  final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key1 =
      new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key2 =
      new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key3 =
      new GlobalKey();
  return SliverList(
    delegate: SliverChildListDelegate([
      Text('You will need to form a team'),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: AutoCompleteTextField<PlayerPoints>(
            itemSubmitted: (item) {
              print('Items submitted ${item.id}');
            },
            key: key1,
            suggestions: listOfPlayers,
            itemBuilder: (context, item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    item.player_name,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Text(
                    'with ${item.player_points} points',
                  )
                ],
              );
            },
            itemSorter: (a, b) {
              return a.player_name.compareTo(b.player_name);
            },
            itemFilter: (item, query) {
              return item.player_name.contains(query.toLowerCase());
            }),
      ),
      FormattedRoundedButton('Add member', openPlayerSearchPage, context),
    ]),
  );
}

Widget _buildteamManagement(context) {
  return Text('Team Management');
}

void openPlayerSearchPage(context) {
  Navigator.of(context).pushNamed('/add_player_to_team');
}
