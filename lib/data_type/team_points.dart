import 'package:json_annotation/json_annotation.dart';
part 'team_points.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamPoints {
  static const String _orderfield_ranking = 'team_points';
  static const String leader_designation = 'leader';
  static const String member_one_designation = 'member1';
  static const String member_two_designation = 'member2';
  int team_points;
  Map<dynamic, dynamic> id;
  String team_name;

  TeamPoints(this.team_points, this.id, this.team_name);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory TeamPoints.fromJson(Map<String, dynamic> json) =>
      _$TeamPointsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TeamPointsToJson(this);

  void addUserIdToLeader(String teamLeaderId) {
    Map<dynamic, dynamic> ids = new Map();
    ids[leader_designation] = teamLeaderId;
    this.id = ids;
  }
}
