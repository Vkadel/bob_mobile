import 'package:json_annotation/json_annotation.dart';
part 'books.g.dart';

@JsonSerializable(explicitToJson: true)
class Books {
  Books(
    this.id, //owner id
    this.status,
    this.bookId, //book id see booksMaster
    //0: not read  -  1:read 1/3 -  2:read 2/3    -  3: read all
  );

  String id;
  int status;
  String bookId;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Books.fromJson(Map<String, dynamic> json) => _$BooksFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BooksToJson(this);
}
