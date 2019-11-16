import 'package:json_annotation/json_annotation.dart';
part 'answered_questions.g.dart';

@JsonSerializable(explicitToJson: true)
class AnsweredQuestions {
  AnsweredQuestions(
      this.question, //Question id
      this.status, //0: answered correctly 1-oo: how many times attempted
      this.reset);

  int question;
  int status;
  int reset = 0;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AnsweredQuestions.fromJson(Map<dynamic, dynamic> json) =>
      _$AnsweredQuestionsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AnsweredQuestionsToJson(this);

  void resetAnsweredQuestion() {
    print('Trying Resetting question ID: ${question}');
    this.status = 1;
    this.reset == null ? this.reset = 0 : this.reset = this.reset;
    this.reset = reset + 1;
    print('Resetting question ID: ${question}');
  }
}
