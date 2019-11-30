import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/data_type/team.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/modelData/team_formation_data.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/constants.dart';
import 'helpers/loading_big.dart';

class TeamHallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TeamHallState();
  }
}

class _TeamHallState extends State<TeamHallPage> {
  @override
  Widget build(BuildContext context) {
    return TeamHallScaffold();
  }
}

class TeamHallScaffold extends StatelessWidget {
  const TeamHallScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
      Provider.of<TeamFormationData>(context, listen: false)
          .initializeTeamData(context);
    }
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
                  image:
                      AssetImage(Constants.myAvatars.elementAt(0).asset_Large),
                  color: ColorLogicbyPersonality(context),
                ),
              ),
              actions: <Widget>[]),
          SliverList(
            delegate: SliverChildListDelegate(
                [_buildHeaderTeamName(context), TeamNameField()]),
          ),
          _buildPageBody(context),
        ],
      ),
    );
  }
}

Widget _buildHeaderTeamName(context) {
  return Builder(
    builder: (BuildContext context) {
      return Consumer<TeamFormationData>(
        builder: (context, teamdata, _) {
          if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
            return TextFormattedLabelTwo(teamdata.theTeam.team_name, 30,
                ColorLogicbyPersonality(context));
          } else {
            return Container(
              //TODO: empty this container
              child: Container(
                padding: EdgeInsets.all(16),
                child: Center(
                    child: TextFormattedLabelTwo(
                        "You don't have a team yet. "
                        "If you want to form one start by giving it a name. "
                        "A team is a permanent choice be wise finding members....",
                        MediaQuery.of(context).size.width / 15)),
              ),
            );
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
            if ((!teamdata.teamGenerated) ||
                !NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot() ==
                    null) {
              controllerTeamName.addListener(() {
                teamNameChangeCallBack(context);
              });
              return (teamdata.nameCanBeUsed &&
                      NotNullNotEmpty(teamdata.theTeam.team_name).isnot())
                  ? _enterNameFieldReadytoUpload(
                      controllerTeamName, teamdata, keyTeamName, context)
                  : _enterNameFieldNotReady(
                      controllerTeamName, teamdata, keyTeamName, context);
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  void teamNameChangeCallBack(context) {
    String message;
    message = 'Your team needs a name';
    print('Will Update TeamFormationData');
    Provider.of<TeamFormationData>(context, listen: false)
        .updateteamName(controllerTeamName.text, context);
    //Name exist
    if (!Provider.of<TeamFormationData>(context).nameCanBeUsed) {
      message = 'This name exists, find another name';
    }
    //Name is empty
    if (Provider.of<TeamFormationData>(context).theTeam.team_name.isEmpty) {
      message = 'Your team needs a name';
    }
    if (Provider.of<TeamFormationData>(context).nameCanBeUsed) {
      message = 'I like this name...';
    }
    SnackBarMessage(message, context);
  }
}

Widget _enterNameFieldReadytoUpload(
    controllerTeamName, teamdata, keyTeamName, BuildContext context) {
  return Stack(
    alignment: Alignment.topRight,
    children: <Widget>[
      _myEditableField(null, context, controllerTeamName, teamdata, keyTeamName,
          new List<PlayerPoints>(), teamdata.updateteamName, null),
      Container(
        margin: EdgeInsets.fromLTRB(0, 8, 16, 0),
        alignment: Alignment.centerRight,
        child: OutlineButton.icon(
            onPressed: () async {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Trying to form the team'),
                  CircularProgressIndicator()
                ],
              )));
              Provider.of<TeamFormationData>(context)
                  .updateTeamInFireStore(context);
            },
            icon: Icon(Icons.check),
            label: Text('Add Team')),
      )
    ],
  );
}

Widget _enterNameFieldNotReady(
    controllerTeamName, teamdata, keyTeamName, BuildContext context) {
  return Stack(
    alignment: Alignment.topRight,
    children: <Widget>[
      _myEditableField(null, context, controllerTeamName, teamdata, keyTeamName,
          new List<PlayerPoints>(), teamdata.updateteamName, null),
    ],
  );
}

//Check if all invitation have been accepted
//To show team management
Widget _buildPageBody(BuildContext context) {
  bool allAccepted =
      Provider.of<TeamFormationData>(context, listen: false).allAccepted;
  if (allAccepted) {
    print('Team is all done we will build Team Management');
    return _buildteamManagement();
  } else {
    try {
      print('will build a page to load members');
      return _memberSearchWidget();
    } catch (e) {
      print('error building list of fields');
      print(e);
      return SliverToBoxAdapter(
        child: Container(
          color: Colors.purple,
        ),
      );
    }
  }
}

class _memberSearchWidget extends StatefulWidget {
  const _memberSearchWidget({
    Key key,
  }) : super(key: key);

  @override
  _memberSearchWidgetState createState() => _memberSearchWidgetState();
}

class _memberSearchWidgetState extends State<_memberSearchWidget> {
  static final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key1 =
      new GlobalKey();
  static final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key2 =
      new GlobalKey();
  static final GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key3 =
      new GlobalKey();
  static final TextEditingController controller1 = new TextEditingController();
  static final TextEditingController controller2 = new TextEditingController();
  static final TextEditingController controller3 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<PlayerPoints> listOfPlayers = Quanda.of(context).playerRankings;
    return Consumer<TeamFormationData>(
      builder: (context, teamFormData, _) {
        controller1.text = teamFormData.theTeam.memberOneName;
        controller2.text = teamFormData.theTeam.memberTwoName;
        controller3.text = teamFormData.theTeam.memberThreeName;

        if (NotNullNotEmpty(teamFormData.theTeam.team_name).isnot() &&
            teamFormData.teamGenerated) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: Center(
                    child: TextFormattedLabelTwo(
                        "Now that you started a team, you can add team members using their Hero's Name. "
                        "Ask your friends their Id's to add them here. "
                        "Teams can compete for points together and can be part of unique challenges. "
                        "They can start earning points once all team members accepted their invitation…",
                        MediaQuery.of(context).size.width / 20,
                        ColorLogicbyRole(context)),
                  ),
                  margin: EdgeInsets.all(16),
                ),
                Container(
                  child: Center(
                    child: TextFormattedLabelTwo(
                        "Add Members",
                        MediaQuery.of(context).size.width / 10,
                        ColorLogicbyRole(context)),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    _myEditableField(
                        1,
                        context,
                        controller1,
                        teamFormData,
                        key1,
                        listOfPlayers,
                        null,
                        teamFormData.updateTeamMateName),
                    _buildInvitationStatus(
                        context, 1, teamFormData, controller1),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    _myEditableField(
                        2,
                        context,
                        controller2,
                        teamFormData,
                        key2,
                        listOfPlayers,
                        null,
                        teamFormData.updateTeamMateName),
                    _buildInvitationStatus(
                        context, 2, teamFormData, controller2),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    _myEditableField(
                        3,
                        context,
                        controller3,
                        teamFormData,
                        key3,
                        listOfPlayers,
                        null,
                        teamFormData.updateTeamMateName),
                    _buildInvitationStatus(
                        context, 3, teamFormData, controller3),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.width,
                  color: ColorLogicbyPersonality(context),
                )
              ],
            ),
          );
        } else {
          //Return empty until there is no name or the name is no good
          return SliverToBoxAdapter(
            child: Container(
              color: Colors.yellow,
            ),
          );
        }
      },
    );
  }
}

Widget _buildInvitationStatus(context, int indexStatus,
    TeamFormationData teamFormData, TextEditingController controller) {
  String message = "";
  IconData iconData;
  Function action;
  if (indexStatus == 1) {
    //Waiting on response
    if (teamFormData.theTeam.invitationMemberOnePending &&
        !teamFormData.theTeam.invitationMemberOneAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Waiting';
      iconData = Icons.hourglass_empty;
    }
    //If pending=false => send_invite
    if (!teamFormData.theTeam.invitationMemberOnePending &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Send invite';
      iconData = Icons.mail_outline;
      action = () {
        //Todo: invitation
        teamFormData.sendInvitationToMember(
            context, indexStatus, controller.text);
        print('need to send invite to member one');
      };
    }
    //Invitations not null/accepted and name is entered=> No action member is setup
    if (teamFormData.theTeam.invitationMemberOneAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'This team member accepted';
      iconData = Icons.check;
      action = () {
        SnackBarMessage('This member is already in the team', context);
      };
    }
    //Invitation denied accepted=false and pending=false
    if (!teamFormData.theTeam.invitationMemberOneAccepted &&
        !teamFormData.theTeam.invitationMemberOnePending &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Invitation denied. Add another';
      iconData = Icons.clear;
      action = () {
        FireProvider.of(context).fireBase.deleteDenyMember(
            Provider.of<TeamFormationData>(context, listen: false).theTeam,
            context,
            1);
        print('Member denied invitation');
      };
    }
  }
  if (indexStatus == 2) {
    //Waiting on response
    if (teamFormData.theTeam.invitationMemberTwoPending &&
        !teamFormData.theTeam.invitationMemberTwoAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Waiting';
      iconData = Icons.hourglass_empty;
    }
    //Invitations are null and name is entered=> send_invite
    if (!teamFormData.theTeam.invitationMemberTwoPending &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Send invite';
      iconData = Icons.mail_outline;
      action = () {
        print('need to send invite to member two');
        teamFormData.sendInvitationToMember(
            context, indexStatus, controller.text);
      };
    }
    //No invitation sent/Invitations not accepted/name is entered=> No action member is setup
    if (teamFormData.theTeam.invitationMemberTwoAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'This team member accepted';
      iconData = Icons.check;
      action = () {
        SnackBarMessage('This member is already in the team', context);
      };
    }

    //Invitation denied accepted=false and pending=false
    if (!teamFormData.theTeam.invitationMemberTwoAccepted &&
        !teamFormData.theTeam.invitationMemberTwoPending &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Invitation denied. Add another';
      iconData = Icons.clear;
      action = () {
        FireProvider.of(context).fireBase.deleteDenyMember(
            Provider.of<TeamFormationData>(context, listen: false).theTeam,
            context,
            2);
        print('Member denied invitation');
      };
    }
  }
  if (indexStatus == 3) {
    //Waiting on response
    if (teamFormData.theTeam.invitationMemberThreePending &&
        !teamFormData.theTeam.invitationMemberThreeAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Waiting';
      iconData = Icons.hourglass_empty;
    }
    //If pending=false then no invitation has been sent
    if (!teamFormData.theTeam.invitationMemberThreeAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Send invite';
      iconData = Icons.mail_outline;
      action = () {
        print('need to send invite to member three');
        teamFormData.sendInvitationToMember(
            context, indexStatus, controller.text);
      };
    }
    //No invitation sent/Invitations not accepted/name is entered=> No action member is setup
    if (teamFormData.theTeam.invitationMemberThreeAccepted &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'This team member accepted';
      iconData = Icons.check;
      action = () {
        SnackBarMessage('This member is already in the team', context);
      };
    }

    //Invitation denied accepted=false and pending=false
    if (!teamFormData.theTeam.invitationMemberThreeAccepted &&
        !teamFormData.theTeam.invitationMemberThreePending &&
        NotNullNotEmpty(controller.text).isnot()) {
      message = 'Invitation denied. Add another';
      iconData = Icons.clear;
      action = () {
        FireProvider.of(context).fireBase.deleteDenyMember(
            Provider.of<TeamFormationData>(context, listen: false).theTeam,
            context,
            3);
        print('Member denied invitation');
      };
    }
  }
  //Check the invitation statuses
  return new Container(
      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
      alignment: Alignment.topRight,
      child: FlatButton.icon(
        onPressed: action,
        icon: Icon(iconData),
        label: Text(message),
      ));
}

Widget _buildteamManagement() {
  return Builder(
    builder: (BuildContext context) {
      return Consumer<TeamFormationData>(builder: (context, teamdata, _) {
        return SliverList(
          delegate: SliverChildListDelegate([
            TextFormattedLabelTwo(
                'Members:',
                MediaQuery.of(context).size.width / 10,
                ColorLogicbyRole(context)),
            _buildTeamMemberListItem(teamdata, 1),
            _buildTeamMemberListItem(teamdata, 2),
            _buildTeamMemberListItem(teamdata, 3),
          ]),
        );
      });
    },
  );
}

Widget _buildTeamMemberListItem(TeamFormationData teamdata, index) {
  String teamName = '';
  if (index == 1) teamName = teamdata.theTeam.memberOneName;
  if (index == 2) teamName = teamdata.theTeam.memberTwoName;
  if (index == 3) teamName = teamdata.theTeam.memberThreeName;

  return Builder(
    builder: (BuildContext context) {
      double radius = 10;
      Color BColor = ColorLogicbyPersonality(context);
      return Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: BColor),
            bottom: BorderSide(color: BColor),
            right: BorderSide(color: BColor),
            left: BorderSide(color: BColor),
          ),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
              bottomRight: Radius.circular(radius * 2),
              bottomLeft: Radius.circular(radius)),
        ),
        child: TextFormattedLabelTwo(
            'Member ${index}: ${teamName}',
            MediaQuery.of(context).size.width / 15,
            ColorLogicbyPersonality(context)),
      );
    },
  );
}

Widget _myEditableField(
    int index,
    BuildContext context,
    TextEditingController controller,
    TeamFormationData teamFormData,
    GlobalKey<AutoCompleteTextFieldState<PlayerPoints>> key,
    List<PlayerPoints> suggestions,
    void Function(String teamMemberName, BuildContext context) updateTeamName,
    void Function(String teamMemberName, BuildContext context, int index)
        updateTeamMemberName) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: AutoCompleteTextField<PlayerPoints>(
        controller: controller,
        textSubmitted: (item) {
          /*controller.text = '${item}';*/
        },
        suggestionsAmount: 10,
        itemSubmitted: (item) {
          if (updateTeamMemberName != null) {
            updateTeamMemberName('${item.player_name}', context, index);
          } else {
            updateTeamName('${item.player_name}', context);
          }
        },
        key: key,
        suggestions: suggestions,
        itemBuilder: (context, item) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item.player_name,
                style:
                    TextStyle(fontSize: MediaQuery.of(context).size.width / 30),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Text(
                'PP:${item.player_points}',
                style:
                    TextStyle(fontSize: MediaQuery.of(context).size.width / 30),
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
