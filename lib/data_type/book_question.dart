import 'package:json_annotation/json_annotation.dart';
part 'book_question.g.dart';

/// generated watcher in the root by running  command:
///
/// flutter pub run build_runner build
///
///               or for permanent
///
/// flutter pub run build_runner watch

@JsonSerializable(explicitToJson: true)
class BookQuestion {
  BookQuestion(this.question, this.option_a, this.option_b, this.option_c,
      this.correct_answer, this.id, this.book_section, this.questionId);

  String question;
  String option_a;
  String option_b;
  String option_c;
  String correct_answer;
  int selection_a;
  int book_section;
  int id; //The id of the Book it belongs to
  int questionId;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory BookQuestion.fromJson(Map<String, dynamic> json) =>
      _$BookQuestionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BookQuestionToJson(this);
}
