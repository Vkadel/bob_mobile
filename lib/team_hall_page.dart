import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/modelData/team_formation_data.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                child: TeamNameField(),
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go back to dashboard!'),
                ),
              ),
              _buildHeader(context),
            ]),
          ),
          _buildPageBody(context),
          SliverToBoxAdapter(
            child: _buildBottom(context),
          )
        ],
      ),
    );
  }
}

Widget _buildHeader(context) {
  return Builder(
    builder: (BuildContext context) {
      return Consumer<TeamFormationData>(
        builder: (context, teamdata, _) {
          if (teamdata.teamName != null) {
            return TextFormattedLabelTwo(
                teamdata.teamName, 30, ColorLogicbyPersonality(context));
          } else {
            return TextFormattedLabelTwo(
                'You will need to form a team select from existing players',
                30,
                ColorLogicbyPersonality(context));
          }
        },
      );
    },
  );
}

class TeamNameField extends StatelessWidget {
  static final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> keyTeamName =
      new GlobalKey();
  static final TextEditingController controllerTeamName =
      new TextEditingController();
  TeamNameField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Consumer<TeamFormationData>(
          builder: (context, teamdata, _) {
            if (teamdata.teamName == null || teamdata.teamName == 'Team Name') {
              controllerTeamName.addListener(() {
                listenerCallBack(context);
              });
              return _myEditableField(controllerTeamName, teamdata, keyTeamName,
                  new List<PlayerPoints>(), teamdata.updateteamName);
            } else {
              return TextFormattedLabelTwo(
                  'Team Name', 30, ColorLogicbyPersonality(context));
            }
          },
        );
      },
    );
  }

  void listenerCallBack(context) {
    String message;
    message = 'Your team Needs a Name';
    print('Got into update loop with: ${controllerTeamName.text}');
    int indexLocation = -1;
    if (controllerTeamName.text != null && controllerTeamName.text.isNotEmpty) {
      print('Searching: ${controllerTeamName.text}');
      try {
        indexLocation = Quanda.of(context).teamRankings.indexWhere((item) =>
            item.team_name
                .trim()
                .toLowerCase()
                .startsWith(controllerTeamName.text.trim().toLowerCase()));
      } catch (e) {
        print(e);
      }
      print('location of this name is: ${indexLocation}');
      indexLocation == -1
          ? message = 'It seems this is a unique name'
          : message = 'This name exist at ${indexLocation}';
    }
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

Widget _buildBottom(context) {
  return Builder(
    builder: (BuildContext context) {
      return Consumer<TeamFormationData>(
        builder: (context, teamdata, _) {
          if (teamdata.teamName != null) {
            return Container(
              color: ColorLogicbyRole(context),
            );
          } else {
            return FormattedRoundedButton(
                'Send Invitations', _sendInvitations, context);
          }
        },
      );
    },
  );
}

Widget _buildPageBody(BuildContext context) {
  return Builder(
    builder: (BuildContext context) {
      if (Quanda.of(context).myUser.team_id == null ||
          Quanda.of(context).myUser.team_id.isEmpty) {
        return _buildYourTeamPage(context);
      } else {
        return _buildteamManagement(context);
      }
    },
  );
}

Widget _buildYourTeamPage(context) {
  return new _memberSearchWidget();
}

class _memberSearchWidget extends StatefulWidget {
  const _memberSearchWidget({
    Key key,
  }) : super(key: key);

  @override
  _memberSearchWidgetState createState() => _memberSearchWidgetState();
}

class _memberSearchWidgetState extends State<_memberSearchWidget> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key1 =
      new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key2 =
      new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key3 =
      new GlobalKey();
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<PlayerPoints> listOfPlayers = Quanda.of(context).playerRankings;
    return new Consumer<TeamFormationData>(
      builder: (context, teamFormData, _) {
        controller1.text = teamFormData.teamMemberOneName;
        controller2.text = teamFormData.teamMemberTwoName;
        controller3.text = teamFormData.teamMemberThreeName;
        //TODO: Check that only people in the same school can form teams
        return SliverGrid(
          delegate: SliverChildListDelegate([
            _myEditableField(controller1, teamFormData, key1, listOfPlayers,
                teamFormData.updateteamMemberOneName),
            _buildIconTextForInvitationStatus(context, 1),
            _myEditableField(controller2, teamFormData, key2, listOfPlayers,
                teamFormData.updateteamMemberTwoName),
            _buildIconTextForInvitationStatus(context, 2),
            _myEditableField(controller3, teamFormData, key3, listOfPlayers,
                teamFormData.updateteamMemberThreeName),
            _buildIconTextForInvitationStatus(context, 3),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              childAspectRatio: MediaQuery.of(context).size.width / 100,
              crossAxisSpacing: 1),
        );
      },
    );
  }
}

Widget _buildIconTextForInvitationStatus(context, int index) {
  return Builder(
    builder: (BuildContext context) {
      return Center(
        child: Text('Status${index}'),
      );
    },
  );
}

Widget _buildteamManagement(context) {
  return Text('Team Management');
}

void _sendInvitations(context) {
  print('Will send invitations to those that have not responded');
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Will Send Invitations'),
  ));
}

Widget _myEditableField(
    TextEditingController controller,
    TeamFormationData teamFormData,
    GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key,
    List<PlayerPoints> suggestions,
    void Function(String newteamMemberOneName) updateDataField) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: AutoCompleteTextField<PlayerPoints>(
        controller: controller,
        textSubmitted: (item) {},
        suggestionsAmount: 10,
        itemSubmitted: (item) {
          updateDataField(item.player_name);
        },
        key: key,
        suggestions: suggestions,
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
          return item.player_name.toLowerCase().startsWith(query.toLowerCase());
        }),
  );
}
