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

  // TODO to keep: make sure the conversion is also dynamic,dynamic the auto runner
  // tends to change the part file to String
  factory AnsweredQuestions.fromJson(Map<dynamic, dynamic> json) =>
      _$AnsweredQuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$AnsweredQuestionsToJson(this);

  void resetAnsweredQuestion() {
    print('Trying Resetting question ID: ${question}');
    this.status = 1;
    this.reset == null ? this.reset = 0 : this.reset = this.reset;
    this.reset = reset + 1;
    print('Resetting question ID: ${question}');
  }
}
