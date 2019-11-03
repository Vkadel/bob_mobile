import 'package:json_annotation/json_annotation.dart';
part 'list_of_items.g.dart';

@JsonSerializable(explicitToJson: true)
class ListofItems {
  ListofItems(
    this.item, //Item id
    this.status, //0: open 1-oo: used
  );

  String item;
  int status;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ListofItems.fromJson(Map<String, dynamic> json) =>
      _$ListofItemsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ListofItemsToJson(this);
}
