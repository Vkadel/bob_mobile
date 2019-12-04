import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'items.g.dart';

@JsonSerializable(explicitToJson: true)
class Items {
  Items(
      this.item, //Item id from items_master
      this.status, //0: used 1-oo:available
      this.id, //userId
      this.endDate, //make null until activated
      this.inuse);
  String id; //This is the owners id
  int item;
  int status;
  bool inuse;
  int endDate;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ItemsToJson(this);

  Items getItemBoughtWithYearExp(
      Timestamp timestamp, int item_type, String uid) {
    Items item;
    item.item = item_type;
    item.status = 1;
    //Items will expire after a year of purchasing them
    item.endDate = timestamp.millisecondsSinceEpoch + (3600000 * 24 * 365);
    item.id = uid;
    return item;
  }

  void purchaseNow(Timestamp timestamp) {
    this.endDate =
        endDate = timestamp.millisecondsSinceEpoch + (3600000 * 24 * 365);
    this.status = 1;
  }
}
