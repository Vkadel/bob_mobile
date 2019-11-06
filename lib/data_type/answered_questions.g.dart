// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answered_questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnsweredQuestions _$AnsweredQuestionsFromJson(Map<String, dynamic> json) {
  return AnsweredQuestions(
      json['question'] as String, json['status'] as int, json['id'] as String);
}

Map<String, dynamic> _$AnsweredQuestionsToJson(AnsweredQuestions instance) =>
    <String, dynamic>{
      'question': instance.question,
      'status': instance.status,
      'id': instance.id
    };
