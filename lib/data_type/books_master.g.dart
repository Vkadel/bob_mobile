// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooksMaster _$BooksMasterFromJson(Map<String, dynamic> json) {
  return BooksMaster(
    json['name'] as String,
    json['id'] as String,
    json['status'] as int,
    json['online_picture_link'] as String,
    json['pages'] as int,
    (json['bookTypesArray'] as List)?.map((e) => e as int)?.toList(),
    json['isbn13'] as String,
    json['by'] as String,
  );
}

Map<String, dynamic> _$BooksMasterToJson(BooksMaster instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'online_picture_link': instance.online_picture_link,
      'pages': instance.pages,
      'bookTypesArray': instance.bookTypesArray,
      'isbn13': instance.isbn13,
      'name': instance.name,
      'by': instance.by,
    };
