import 'package:json_annotation/json_annotation.dart';
part 'player_points.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerPoints {
  static const String _orderfield_ranking = 'player_points';
  int player_points;
  String id;
  String player_name;
  bool playerTeamId;

  PlayerPoints(this.player_points, this.id, this.player_name);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PlayerPoints.fromJson(Map<String, dynamic> json) =>
      _$PlayerPointsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PlayerPointsToJson(this);
}
