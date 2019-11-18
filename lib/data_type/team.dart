import 'package:json_annotation/json_annotation.dart';
part 'team.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
/// generated watcher in the root by running  command:
///
/// flutter pub run build_runner build
///
///               or for permanent
///
/// flutter pub run build_runner watch
///
///     of for when files already exists
///
/// flutter pub run build_runner build --delete-conflicting-outputs
///
/// Consuming json_serializable models.
///   Map userMap = jsonDecode(jsonString);
///   var team = Team.fromJson(teamMap);
///   Encoding encoding. The calling API is the same as before.
///   String json = jsonEncode(Team);
///
@JsonSerializable(explicitToJson: true)
class Team {
  String leader_id;
  String team_name;
  int points;
  int school_id;

  Team();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Team.fromJson(Map<dynamic, dynamic> json) => _$TeamFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<dynamic, dynamic> toJson() => _$TeamToJson(this);
}
