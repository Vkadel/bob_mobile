import 'package:json_annotation/json_annotation.dart';
part 'private.g.dart';

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
class Private {
  Map<dynamic, dynamic> members;

  ///This identification for each type of member cannot be changed
  ///Since they are used in Firestore for the rules on team access.
  static const String userOwnerid = "userOwnerid";
  static const String memberid1 = "memberid1";
  static const String memberid2 = "memberid2";
  static const String memberid3 = "memberid3";
  Private();

  //Todo sticky: ensure the fromjson has a dynamic,dynamic
  factory Private.fromJson(Map<dynamic, dynamic> json) =>
      _$PrivateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<dynamic, dynamic> toJson() => _$PrivateToJson(this);
}
