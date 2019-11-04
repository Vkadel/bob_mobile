// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposed_questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProposedQuestions _$ProposedQuestionsFromJson(Map<String, dynamic> json) {
  return ProposedQuestions(
      json['question'] as String,
      json['answerone'] as String,
      json['answertwo'] as String,
      json['answerthree'] as String,
      json['correctanswer'] as String,
      json['status'] as int,
      json['datesubmitted'] as int,
      json['bookid'] as String)
    ..userId = json['userId'] as String;
}

Map<String, dynamic> _$ProposedQuestionsToJson(ProposedQuestions instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answerone': instance.answerone,
      'answertwo': instance.answertwo,
      'answerthree': instance.answerthree,
      'correctanswer': instance.correctanswer,
      'bookid': instance.bookid,
      'userId': instance.userId,
      'status': instance.status,
      'datesubmitted': instance.datesubmitted
    };
