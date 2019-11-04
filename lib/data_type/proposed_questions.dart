import 'package:json_annotation/json_annotation.dart';
part 'proposed_questions.g.dart';

@JsonSerializable(explicitToJson: true)
class ProposedQuestions {
  ProposedQuestions(
      this.question,
      this.answerone,
      this.answertwo,
      this.answerthree,
      this.correctanswer,
      this.status,
      this.datesubmitted,
      this.bookid);

  String question;
  String answerone;
  String answertwo;
  String answerthree;
  String correctanswer;
  String bookid;
  String userId;
  int status; //0:submitted 1:reviewedButnotAccepted 2:
  int datesubmitted;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ProposedQuestions.fromJson(Map<String, dynamic> json) =>
      _$ProposedQuestionsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProposedQuestionsToJson(this);
}
