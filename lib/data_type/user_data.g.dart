// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    (json['list_of_read_books'] as List)
        ?.map((e) =>
            e == null ? null : Books.fromJson(e as Map<dynamic, dynamic>))
        ?.toList(),
    json['id'] as String,
  )..answered_questions = (json['answered_questions'] as List)
      ?.map((e) => e as Map<dynamic, dynamic>)
      ?.toList();
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'list_of_read_books':
          instance.list_of_read_books?.map((e) => e?.toJson())?.toList(),
      'answered_questions': instance.answered_questions,
      'id': instance.id,
    };
