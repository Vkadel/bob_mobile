import 'package:bob_mobile/data_type/answered_questions.dart';
import 'package:bob_mobile/data_type/avatar_stats.dart';
import 'package:bob_mobile/data_type/book_types.dart';
import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/data_type/items.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:flutter/material.dart';
import '../data_type/question.dart';
import '../data_type/user.dart';

class Quanda extends InheritedModel {
  bool personal;
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
  List<Items> myItems;
  List<ItemsMaster> masterListOfItems;
  UserData userData;
  List<AnsweredQuestions> allAnsweredQuestions;
  List<BooksMaster> listOfMasterBooks;

  int currentAddForQuestion;
  int currentDeductionForQuestions;
  int currentItemBuffs;
  int total_points_if_correct;

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

  @override
  bool updateShouldNotify(Quanda oldWidget) {
    return currentItemBuffs != oldWidget.currentItemBuffs ||
        currentDeductionForQuestions !=
            oldWidget.currentDeductionForQuestions ||
        currentAddForQuestion != oldWidget.currentAddForQuestion ||
        total_points_if_correct != oldWidget.total_points_if_correct ||
        personal != oldWidget.personal ||
        myAvatarStats != oldWidget.myAvatarStats ||
        listOfMasterBooks != oldWidget.listOfMasterBooks ||
        myUser != oldWidget.myUser ||
        myItems != oldWidget.myItems ||
        userData != oldWidget.userData ||
        allAnsweredQuestions != oldWidget.userData ||
        masterListOfItems != oldWidget.masterListOfItems ||
        bookTypes != oldWidget.bookTypes ||
        d_pressed != oldWidget.d_pressed ||
        c_pressed != oldWidget.c_pressed ||
        a_pressed != oldWidget.a_pressed ||
        progress != oldWidget.progress ||
        b_pressed != oldWidget.b_pressed ||
        list_of_questions != oldWidget.list_of_questions ||
        my_text != oldWidget.my_text ||
        permanent != oldWidget.permanent;
  }

  @override
  bool updateShouldNotifyDependent(Quanda oldWidget, Set dependencies) {
    return (currentDeductionForQuestions != oldWidget.currentAddForQuestion &&
            dependencies.contains('currentDeductionForQuestions')) ||
        (currentItemBuffs != oldWidget.currentItemBuffs &&
            dependencies.contains('currentItemBuffs')) ||
        (currentAddForQuestion != oldWidget.currentAddForQuestion &&
            dependencies.contains('currentAddForQuestion')) ||
        (total_points_if_correct != oldWidget.total_points_if_correct &&
            dependencies.contains('total_points_if_correct')) ||
        (personal != oldWidget.personal && dependencies.contains('personal')) ||
        (myAvatarStats != oldWidget.myAvatarStats &&
            dependencies.contains('myAvatarStats')) ||
        (listOfMasterBooks != oldWidget.listOfMasterBooks &&
            dependencies.contains('listOfMasterBooks')) ||
        (myUser != oldWidget.myUser && dependencies.contains('myUser')) ||
        (myItems != oldWidget.myItems && dependencies.contains('myItems')) ||
        (userData != oldWidget.userData && dependencies.contains('userData')) ||
        (allAnsweredQuestions != oldWidget.allAnsweredQuestions &&
            dependencies.contains('allAnsweredQuestions')) ||
        (masterListOfItems != oldWidget.masterListOfItems &&
            dependencies.contains('masterListOfItems')) ||
        (bookTypes != oldWidget.bookTypes &&
            dependencies.contains('bookTypes')) ||
        (d_pressed != oldWidget.d_pressed &&
            dependencies.contains('d_pressed')) ||
        (c_pressed != oldWidget.c_pressed &&
            dependencies.contains('c_pressed')) ||
        (a_pressed != oldWidget.a_pressed &&
            dependencies.contains('a_pressed')) ||
        (progress != oldWidget.progress && dependencies.contains('progress')) ||
        (b_pressed != oldWidget.b_pressed &&
            dependencies.contains('b_pressed')) ||
        (list_of_questions != oldWidget.list_of_questions &&
            dependencies.contains('list_of_questions')) ||
        (my_text != oldWidget.list_of_questions &&
            dependencies.contains('my_text')) ||
        (permanent != oldWidget.list_of_questions &&
            dependencies.contains('permanent'));
  }
}
