// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookQuestion _$BookQuestionFromJson(Map<String, dynamic> json) {
  return BookQuestion(
    json['question'] as String,
    json['option_a'] as String,
    json['option_b'] as String,
    json['option_c'] as String,
    json['correct_answer'] as String,
    json['id'] as int,
    json['book_section'] as int,
    json['questionId'] as int,
  )..selection_a = json['selection_a'] as int;
}

Map<String, dynamic> _$BookQuestionToJson(BookQuestion instance) =>
    <String, dynamic>{
      'question': instance.question,
      'option_a': instance.option_a,
      'option_b': instance.option_b,
      'option_c': instance.option_c,
      'correct_answer': instance.correct_answer,
      'selection_a': instance.selection_a,
      'book_section': instance.book_section,
      'id': instance.id,
      'questionId': instance.questionId,
    };
