import 'package:json_annotation/json_annotation.dart';
part 'items.g.dart';

@JsonSerializable(explicitToJson: true)
class Items {
  Items(
    this.item, //Item id
    this.status, //0: used 1-oo:available 2:inUse
    this.id,
    this.endDate, //make null until activated
  );
  String id; //This is the owners id
  int item;
  int status;
  int endDate;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}