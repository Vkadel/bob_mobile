// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Books _$BooksFromJson(Map<dynamic, dynamic> json) {
  return Books(
    json['id'] as String,
    json['status'] as int,
    json['bookId'] as int,
  );
}

Map<dynamic, dynamic> _$BooksToJson(Books instance) => <dynamic, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'bookId': instance.bookId,
    };
