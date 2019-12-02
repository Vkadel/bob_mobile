// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answered_questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnsweredQuestions _$AnsweredQuestionsFromJson(Map<dynamic, dynamic> json) {
  return AnsweredQuestions(
    json['question'] as int,
    json['status'] as int,
    json['reset'] as int,
  );
}

Map<String, dynamic> _$AnsweredQuestionsToJson(AnsweredQuestions instance) =>
    <String, dynamic>{
      'question': instance.question,
      'status': instance.status,
      'reset': instance.reset,
    };
