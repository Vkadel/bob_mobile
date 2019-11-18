import 'package:json_annotation/json_annotation.dart';
part 'book_types.g.dart';

/// flutter pub run build_runner build --delete-conflicting-outputs
///
///
@JsonSerializable(explicitToJson: true)
class BookTypes {
  int id;
  String type;

  BookTypes(this.id, this.type);

  factory BookTypes.fromJson(Map<String, dynamic> json) =>
      _$BookTypesFromJson(json);

  Map<String, dynamic> toJson() => _$BookTypesToJson(this);
}
