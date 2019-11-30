import 'package:json_annotation/json_annotation.dart';
part 'team_invites.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamInvites {
  String team_name;
  String invited_name;
  String team_id;

  ///This is the name of the teamLeader
  String from;
  bool accepted;
  //Pending has to change to false once the
  //lead acknowledges it
  bool pending;
  int date_sent;

  TeamInvites(
      {this.team_id,
      this.invited_name,
      this.team_name,
      this.from,
      this.accepted,
      this.pending,
      this.date_sent});

  factory TeamInvites.fromJson(Map<dynamic, dynamic> json) =>
      _$TeamInvitesFromJson(json);

  Map<dynamic, dynamic> toJson() => _$TeamInvitesToJson(this);
}
