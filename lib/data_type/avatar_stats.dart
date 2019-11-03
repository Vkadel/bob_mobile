import 'package:json_annotation/json_annotation.dart';
part 'avatar_stats.g.dart';

/// flutter pub run build_runner build --delete-conflicting-outputs

@JsonSerializable(explicitToJson: true)
class AvatarStats {
  AvatarStats(
    this.additions,
    this.substractions,
    this.multipliers,
  );
  Map<dynamic, dynamic> additions;
  Map<dynamic, dynamic> substractions;
  Map<dynamic, dynamic> multipliers;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AvatarStats.fromJson(Map<String, dynamic> json) =>
      _$AvatarStatsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AvatarStatsToJson(this);
}
