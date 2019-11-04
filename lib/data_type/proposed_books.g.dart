// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposed_books.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProposedBooks _$ProposedBooksFromJson(Map<String, dynamic> json) {
  return ProposedBooks(json['bookname'] as String, json['author'] as String,
      json['status'] as bool);
}

Map<String, dynamic> _$ProposedBooksToJson(ProposedBooks instance) =>
    <String, dynamic>{
      'bookname': instance.bookname,
      'author': instance.author,
      'status': instance.status
    };
