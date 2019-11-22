import 'package:json_annotation/json_annotation.dart';
part 'team_invites.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamInvites {
  String team_name;
  String invited_name;
  String team_id;
  String from;

  ///This is the name of the teamLeader
  bool accepted;
  bool pending;
  int date_sent;
  TeamInvites();

  factory TeamInvites.fromJson(Map<dynamic, dynamic> json) =>
      _$TeamInvitesFromJson(json);

  Map<dynamic, dynamic> toJson() => _$TeamInvitesToJson(this);
}
