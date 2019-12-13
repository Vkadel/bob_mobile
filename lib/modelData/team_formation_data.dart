import 'package:bob_mobile/data_type/team.dart';
import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/helpers/snack_bar_message_w_spin.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamFormationData with ChangeNotifier {
  bool _teamGenerated = false;
  bool _allAccepted = false;
  bool _nameCanBeUsed = false;
  Team _theTeam = new Team();

  ///Getters
  Team get theTeam => _theTeam;

  ///Will be false until the team is formed
  ///in Firestore and the user has it on profile
  bool get teamGenerated => _teamGenerated;
  bool get nameCanBeUsed => _nameCanBeUsed;

  ///this will show team is completed
  ///team is now formed
  bool get allAccepted => _allAccepted;
  TeamFormationData get teamFormationData => this;

  TeamFormationData() {}
  //Initialization
  void initializeTeamData(BuildContext context) {
    ///if there is already a this needs to reflect it
    updateteamGenerated(
        NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot());
    if (NotNullNotEmpty(Quanda.of(context).myUser.team_id).isnot()) {
      updateteamName(Quanda.of(context).myUser.team_id, context);
    }
    FireProvider.of(context)
        .fireBase
        .getTeamStream(context, Quanda.of(context).myUser.team_id)
        .listen(
            (snapshot) => {updateTeam(Team.fromJson(snapshot.data), context)});
  }

  ///Updaters

  void updateTeam(Team newTeam, BuildContext context) {
    if (this.theTeam != newTeam) {
      this._theTeam = newTeam;
      Quanda.of(context).myTeam = newTeam;
      checkAllAccepted(newTeam, context);
      notifyListeners();
    }
  }

  void updateteamGenerated(bool newteamFormed) {
    if (this.teamGenerated != newteamFormed) {
      this._teamGenerated = newteamFormed;
      notifyListeners();
    }
  }

  void updatenameCanBeUsed(bool newnameCanBeUsed) {
    if (this.nameCanBeUsed != newnameCanBeUsed) {
      this._nameCanBeUsed = newnameCanBeUsed;
      notifyListeners();
    }
  }

  void updateallAccepted(bool newallAccepted, context) {
    if (this.allAccepted != newallAccepted) {
      this._allAccepted = newallAccepted;
      if (!theTeam.teamIsActive) {
        FireProvider.of(context)
            .fireBase
            .makeTeamActive(theTeam.team_name, context);
      }
      notifyListeners();
    }
  }

  void updateteamName(String newteamName, BuildContext context) {
    if (this.theTeam.team_name != newteamName) {
      this._theTeam.team_name = newteamName;
      _checkifTeamNameCanBeUsed(context);
    }
  }

  bool _checkifTeamNameCanBeUsed(BuildContext context) {
    int indexLocation;
    try {
      indexLocation = Quanda.of(context).teamRankings.indexWhere((item) => item
          .team_name
          .trim()
          .toLowerCase()
          .startsWith(_theTeam.team_name.trim().toLowerCase()));
    } catch (e) {
      print(e);
    }
    if (indexLocation == -1) {
      print('${_theTeam.team_name} can be used');
      updatenameCanBeUsed(true);
    } else {
      print('${_theTeam.team_name} cannot be used');
      updatenameCanBeUsed(false);
    }
  }

  Future<void> updateTeamInFireStore(BuildContext context) async {
    bool teamWasFormed = await FireProvider.of(context)
        .fireBase
        .createTeam(context, _theTeam.team_name);
    print('the result of team has formed is: ${teamWasFormed}');
    if (teamWasFormed == null) {
      //Sometimes when the transaction does not go through
      // because of errors it will return null
      return false;
    } else {
      return teamWasFormed;
    }
  }

  Future<void> sendInvitationToMember(
    context,
    index,
    String text,
  ) async {
    String memberName;
    if (index == 1) memberName = _theTeam.memberOneName;
    if (index == 2) memberName = _theTeam.memberTwoName;
    if (index == 3) memberName = _theTeam.memberThreeName;
    try {
      if (NotNullNotEmpty(text).isnot())
        SnackBarWithSpin('Sending invitation to: $text please wait', context);
      await FireProvider.of(context)
          .fireBase
          .sendInviteToMember(text, _theTeam.team_name, context, index)
          .whenComplete((() {
        SnackBarMessage('Invitation sent to: ${text}', context);
      }));
    } on Exception catch (e) {
      //Todo: uncover error for user
      SnackBarMessage(e.toString(), context);
      /*SnackBarMessage('There was a problem sending the invite to: ${memberName}', context);*/
    }
  }

  void updateTeamMateName(
      String teamMemberName, BuildContext context, int index) {
    if (teamMemberName != this.theTeam.leaderName ||
        Constants.choose_yourself_as_team_member) {
      if (index == 1 &&
          NotNullNotEmpty(teamMemberName).isnot() &&
          teamMemberCanBeUsed(teamMemberName, index, context)) {
        if (this.theTeam.memberOneName != teamMemberName) {
          this._theTeam.memberOneName = teamMemberName;
          notifyListeners();
        }
      }

      if (index == 2 &&
          teamMemberCanBeUsed(teamMemberName, index, context) &&
          NotNullNotEmpty(teamMemberName).isnot()) {
        if (this.theTeam.memberTwoName != teamMemberName) {
          this._theTeam.memberTwoName = teamMemberName;
          notifyListeners();
        }
      }

      if (index == 3 &&
          teamMemberCanBeUsed(teamMemberName, index, context) &&
          NotNullNotEmpty(teamMemberName).isnot()) {
        if (this.theTeam.memberThreeName != teamMemberName) {
          this._theTeam.memberThreeName = teamMemberName;
          notifyListeners();
        }
      }
    } else {
      SnackBarMessage("You are already a team member", context);
    }
  }

  bool teamMemberCanBeUsed(String name, int index, BuildContext context) {
    String compareOne;
    String compareTwo;
    String compareThree;
    compareOne != null ? compareOne = compareOne : compareOne = "";
    compareTwo != null ? compareTwo = compareTwo : compareTwo = "";
    compareThree != null ? compareThree = compareThree : compareThree = "";
    if (index == 1) {
      if (NotNullNotEmpty(name).isnot() &&
          name != theTeam.memberTwoName &&
          name != theTeam.memberThreeName) {
        return true;
      } else {
        this._theTeam.memberOneName = "";
        SnackBarMessage(Constants.team_member_is_on_your_team, context);
        return false;
      }
    }
    if (index == 2) {
      if (NotNullNotEmpty(name).isnot() &&
          name != theTeam.memberOneName &&
          name != theTeam.memberThreeName) {
        return true;
      } else {
        this._theTeam.memberTwoName = "";
        SnackBarMessage(Constants.team_member_is_on_your_team, context);
        return false;
      }
    }
    if (index == 3) {
      if (NotNullNotEmpty(name).isnot() &&
          name != theTeam.memberOneName &&
          name != theTeam.memberTwoName) {
        return true;
      } else {
        this._theTeam.memberThreeName = "";
        SnackBarMessage(Constants.team_member_is_on_your_team, context);
        return false;
      }
    }
  }

  Future<bool> checkAllAccepted(Team team, BuildContext context) async {
    await FireProvider.of(context).fireBase.getTeam(context, team.team_name);
    (team.invitationMemberOneAccepted &&
            !team.invitationMemberOnePending &&
            theTeam.invitationMemberTwoAccepted &&
            !team.invitationMemberTwoPending &&
            team.invitationMemberThreeAccepted &&
            !team.invitationMemberThreePending &&
            NotNullNotEmpty(team.memberOneName).isnot() &&
            NotNullNotEmpty(team.memberTwoName).isnot() &&
            NotNullNotEmpty(team.memberThreeName).isnot())
        ? updateallAccepted(true, context)
        : null;
  }

  void updateInvitationStatusAfterInvite(int index) {
    if (index == 1) {
      print('updating status for member $index');
      theTeam.invitationMemberOnePending = true;
      theTeam.invitationMemberOneAccepted = false;
    }
    if (index == 2) {
      print('updating status for member $index');
      theTeam.invitationMemberTwoPending = true;
      theTeam.invitationMemberTwoAccepted = false;
    }
    if (index == 3) {
      print('updating status for member $index');
      theTeam.invitationMemberThreePending = true;
      theTeam.invitationMemberThreeAccepted = false;
    }
    notifyListeners();
  }
}
