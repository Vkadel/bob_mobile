import 'package:json_annotation/json_annotation.dart';
part 'books.g.dart';

@JsonSerializable(explicitToJson: true)
class Books {
  Books(
    this.id, //owner id
    this.status,
    this.bookId, //book id see booksMaster a sequencial number in the system
    //0: not read  -  1:read 1/3 -  2:read 2/3    -  3: read all
  );

  String id; //String
  int status; //int
  int bookId; //int

  //Keep dynamic dynamic because this is a tier under user_data
  //It will be rebuild wrong and will need to be fixed
  factory Books.fromJson(Map<dynamic, dynamic> json) => _$BooksFromJson(json);

  //Keep dynamic dynamic because this is a tier under user_data
  //It will be rebuild wrong and will need to be fixed
  Map<dynamic, dynamic> toJson() => _$BooksToJson(this);
}
