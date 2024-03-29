import 'package:bob_mobile/data_type/answered_questions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'books.dart';
part 'user_data.g.dart';

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
///   var user = User.fromJson(userMap);
///Encoding encoding. The calling API is the same as before.
///   String json = jsonEncode(user);

@JsonSerializable(explicitToJson: true)
class UserData {
  UserData(
    this.list_of_read_books,
    this.id,
  );

  List<Books> list_of_read_books = List<Books>();

  ///TODO sticky: make sure to convert this to dynamic,dynamic
  List<Map<dynamic, dynamic>> answered_questions;
  String id;

  ///TODO sticky: make sure the helper method is also
  ///dynamic, dynamic the builder changes it to String,dynamic
  factory UserData.fromJson(Map<dynamic, dynamic> json) =>
      _$UserDataFromJson(json);

  /// converted the
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
