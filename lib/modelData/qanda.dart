import 'package:bob_mobile/data_type/answered_questions.dart';
import 'package:bob_mobile/data_type/avatar_stats.dart';
import 'package:bob_mobile/data_type/book_types.dart';
import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/data_type/items.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:flutter/material.dart';
import '../data_type/question.dart';
import '../data_type/user.dart';

class Quanda extends InheritedModel with ChangeNotifier {
  bool personal;
  List<Question> list_of_questions;
  String my_text = '';
  User myUser;
  AvatarStats myAvatarStats;
  List<BookTypes> bookTypes;
  List<Items> myItems;
  List<ItemsMaster> masterListOfItems;
  UserData userData;
  List<AnsweredQuestions> allAnsweredQuestions;
  List<BooksMaster> listOfMasterBooks;
  PlayerPoints myPlayerPoints;

  Quanda(
      {Key key,
      Widget child,
      this.list_of_questions,
      this.my_text,
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
    return personal != oldWidget.personal ||
        myAvatarStats != oldWidget.myAvatarStats ||
        listOfMasterBooks != oldWidget.listOfMasterBooks ||
        myUser != oldWidget.myUser ||
        myItems != oldWidget.myItems ||
        userData != oldWidget.userData ||
        allAnsweredQuestions != oldWidget.userData ||
        masterListOfItems != oldWidget.masterListOfItems ||
        bookTypes != oldWidget.bookTypes ||
        list_of_questions != oldWidget.list_of_questions ||
        my_text != oldWidget.my_text;
  }

  @override
  bool updateShouldNotifyDependent(Quanda oldWidget, Set dependencies) {
    return (personal != oldWidget.personal &&
            dependencies.contains('personal')) ||
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
        (list_of_questions != oldWidget.list_of_questions &&
            dependencies.contains('list_of_questions')) ||
        (my_text != oldWidget.list_of_questions &&
            dependencies.contains('my_text'));
  }
}
