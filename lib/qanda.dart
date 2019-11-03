import 'package:bob_mobile/data_type/avatar_stats.dart';
import 'package:bob_mobile/data_type/book_types.dart';
import 'package:flutter/material.dart';
import 'data_type/question.dart';
import 'data_type/user.dart';

class Quanda extends InheritedWidget {
  int progress;
  List<Question> list_of_questions;
  List<Question> permanent;
  bool a_pressed = false;
  bool b_pressed = false;
  bool c_pressed = false;
  bool d_pressed = false;
  String my_text = '';
  User myUser;
  AvatarStats myAvatarStats;
  List<BookTypes> bookTypes;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  Quanda(
      {Key key,
      Widget child,
      this.progress,
      this.list_of_questions,
      this.permanent,
      this.a_pressed,
      this.b_pressed,
      this.my_text,
      this.c_pressed,
      this.d_pressed,
      this.myUser,
      this.myAvatarStats,
      this.bookTypes})
      : /*assert(a_pressed != null),*/
        super(
          key: key,
          child: child,
        );

  static Quanda of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Quanda) as Quanda);
}
