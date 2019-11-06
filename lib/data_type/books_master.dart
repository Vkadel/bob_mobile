import 'package:json_annotation/json_annotation.dart';
part 'books_master.g.dart';

@JsonSerializable(explicitToJson: true)
class BooksMaster {
  BooksMaster(
    this.bookId, //book id
    this.status, //0: non-active 1: active
    this.resource_image_ref,
    this.pages,
    this.bookTypesArray,
  );

  String bookId;
  int status;
  String resource_image_ref;
  int pages;
  List<bool> bookTypesArray;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory BooksMaster.fromJson(Map<String, dynamic> json) =>
      _$BooksMasterFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BooksMasterToJson(this);
}
