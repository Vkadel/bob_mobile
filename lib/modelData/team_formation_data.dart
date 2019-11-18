import 'package:flutter/cupertino.dart';

class TeamFormationData with ChangeNotifier {
  String _teamMemberOneName;
  String _teamMemberTwoName;
  String _teamMemberThreeName;
  String _leaderName;
  bool _teamInviteStatusOne;
  bool _teamInviteStatusTwo;
  bool _teamInviteStatusThree;
  bool _sendInvitationToOne;
  bool _sendInvitationToTwo;
  bool _sendInvitationToThree;
  bool _sendInvitationToAll;
  bool _teamFormed;

  ///Getters
  String get teamMemberOneName => _teamMemberOneName;
  String get teamMemberTwoName => _teamMemberTwoName;
  String get teamMemberThreeName => _teamMemberThreeName;
  String get leaderName => _leaderName;
  bool get teamInviteStatusOne => _teamInviteStatusOne;
  bool get teamInviteStatusTwo => _teamInviteStatusTwo;
  bool get teamInviteStatusThree => _teamInviteStatusThree;
  bool get sendInvitationToOne => _sendInvitationToOne;
  bool get sendInvitationToTwo => _sendInvitationToTwo;
  bool get sendInvitationToThree => _sendInvitationToThree;
  bool get sendInvitationToAll => _sendInvitationToAll;
  bool get teamFormed => _teamFormed;
  TeamFormationData get teamFormationData => this;

  TeamFormationData();

  ///Updaters
  void updateteamMemberOneName(String newteamMemberOneName) {
    if (this.teamMemberOneName != newteamMemberOneName) {
      this._teamMemberOneName = newteamMemberOneName;
      notifyListeners();
    }
  }

  void updateteamMemberTwoName(String newteamMemberTwoName) {
    if (this.teamMemberTwoName != newteamMemberTwoName) {
      this._teamMemberTwoName = newteamMemberTwoName;
      notifyListeners();
    }
  }

  void updateteamMemberThreeName(String newteamMemberThreeName) {
    if (this.teamMemberThreeName != newteamMemberThreeName) {
      this._teamMemberThreeName = newteamMemberThreeName;
      notifyListeners();
    }
  }

  void updateleaderName(String newleaderName) {
    if (this.leaderName != newleaderName) {
      this._leaderName = newleaderName;
      notifyListeners();
    }
  }

  void updateteamInviteStatusOne(bool newteamInviteStatusOne) {
    if (this.teamInviteStatusOne != newteamInviteStatusOne) {
      this._teamInviteStatusOne = newteamInviteStatusOne;
      notifyListeners();
    }
  }

  void updateteamInviteStatusTwo(bool newteamInviteStatusTwo) {
    if (this.teamInviteStatusTwo != newteamInviteStatusTwo) {
      this._teamInviteStatusTwo = newteamInviteStatusTwo;
      notifyListeners();
    }
  }

  void updateteamInviteStatusThree(bool newteamInviteStatusThree) {
    if (this.teamInviteStatusThree != newteamInviteStatusThree) {
      this._teamInviteStatusThree = newteamInviteStatusThree;
      notifyListeners();
    }
  }

  void updatecontinue_fighting(bool newsendInvitationToAll) {
    if (this.sendInvitationToAll != newsendInvitationToAll) {
      this._sendInvitationToAll = newsendInvitationToAll;
      notifyListeners();
    }
  }

  void updatesendInvitationToOne(bool newsendInvitationToOne) {
    if (this.sendInvitationToOne != newsendInvitationToOne) {
      this._sendInvitationToOne = newsendInvitationToOne;
      notifyListeners();
    }
  }

  void updatesendInvitationToTwo(bool newsendInvitationToTwo) {
    if (this.sendInvitationToTwo != newsendInvitationToTwo) {
      this._sendInvitationToTwo = newsendInvitationToTwo;
      notifyListeners();
    }
  }

  void updatesendInvitationToThree(bool newsendInvitationToThree) {
    if (this.sendInvitationToThree != newsendInvitationToThree) {
      this._sendInvitationToThree = newsendInvitationToThree;
      notifyListeners();
    }
  }

  void updateteamFormed(bool newteamFormed) {
    if (this.teamFormed != newteamFormed) {
      this._teamFormed = newteamFormed;
      notifyListeners();
    }
  }
}
