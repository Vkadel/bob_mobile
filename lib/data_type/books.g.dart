// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Books _$BooksFromJson(Map<String, dynamic> json) {
  return Books(json['id'] as String, json['status'] as int);
}

Map<String, dynamic> _$BooksToJson(Books instance) =>
    <String, dynamic>{'id': instance.id, 'status': instance.status};
