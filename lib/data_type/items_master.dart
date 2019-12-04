import 'package:bob_mobile/shop_page.dart';
import 'package:json_annotation/json_annotation.dart';
part 'items_master.g.dart';

@JsonSerializable(explicitToJson: true)
class ItemsMaster {
  ItemsMaster(
      this.name, //Item id, names should remain less than 23 chars
      this.addition,
      this.subtraction,
      this.multiplier,
      this.cost,
      this.duration_days,
      this.id);
  String name;
  int addition;
  int multiplier;
  int subtraction;
  int cost;
  int duration_days;
  int status; //0: non active - 1: active
  int id; //this identification has to match the address in items_master such as items_master/0 has id=0

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ItemsMaster.fromJson(Map<String, dynamic> json) =>
      _$ItemsMasterFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ItemsMasterToJson(this);
}
