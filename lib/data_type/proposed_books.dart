import 'package:json_annotation/json_annotation.dart';
part 'proposed_books.g.dart';

@JsonSerializable(explicitToJson: true)
class ProposedBooks {
  ProposedBooks(
    this.bookname,
    this.author,
    this.status, //0: waiting to be approved and added 1: approved Points assigned
  );

  String bookname;
  String author;
  bool status;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ProposedBooks.fromJson(Map<String, dynamic> json) =>
      _$ProposedBooksFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProposedBooksToJson(this);
}
