import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bob_mobile/data_type/answered_questions.dart';
import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/books.dart';
import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/data_type/firstQuestionsUpload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data_type/question.dart';
import 'data_type/user.dart';

class QuestionEngine {
  User myUser;
  BuildContext mcontext;
  Stream<Question> generatedQuestion;
  BooksMaster bookQueried;
  int IdofBookChoosenFromQuanda;
  final StreamController _controller =
      StreamController<BookQuestion>.broadcast();
  List answeredQuestionsForBook;
  QuestionEngine();

  Stream<BookQuestion> getStream() {
    return _controller.stream.asBroadcastStream();
  }

  void InitEngine(BuildContext context) {
    mcontext = context;
    getUsersBooks();
  }

  void getUsersBooks() {
    print("Question engine Starting to get user books");
    FireProvider.of(mcontext)
        .fireBase
        .getUserReadListOfBooks(Quanda.of(mcontext).myUser)
        .listen((list) => updateQuandaListOfBooks(list));
  }

  void updateQuandaListOfBooks(DocumentSnapshot gotDocs) {
    Quanda.of(mcontext).userData = UserData.fromJson(gotDocs.data);
    print('Question engine Updated Quanda with books Read');
    selectBookRandom();
  }

  void selectBookRandom() {
    int listSize = Quanda.of(mcontext).userData.list_of_read_books.length;
    int selectedBook = new Random().nextInt(listSize);
    print('Question engine Selected Book number: ${listSize}');
    getMasterBookInfo(selectedBook);
  }

  void getMasterBookInfo(int bookLocationInQuanda) {
    /*new BookQuestionUpload().firstLargeUpload(context)*/;
    print('Question engine Getting Master Book Info');
    IdofBookChoosenFromQuanda = Quanda.of(mcontext)
        .userData
        .list_of_read_books
        .elementAt(bookLocationInQuanda);

    FireProvider.of(mcontext)
        .fireBase
        .getMasterBookInfo(IdofBookChoosenFromQuanda)
        .listen((bookSnapshot) =>
            getBookQuestions(bookSnapshot, bookLocationInQuanda));
  }

  void getAnsweredQuestions() {
    print('Question engine Getting Answered Questions');
    FireProvider.of(mcontext)
        .fireBase
        .getListOfAnsweredQuestins(mcontext, Quanda.of(mcontext).myUser.id)
        .first
        .then((d) => getListOfAnsweredQuestionsUpdateQuanda(d));
  }

  void getBookQuestions(DocumentSnapshot bookSnapshot, int booklocation) {
    print('Question engine Getting Book associated questions');
    bookQueried = BooksMaster.fromJson(bookSnapshot.data);
    FireProvider.of(mcontext)
        .fireBase
        .getQuestionsForMasterBook(Quanda.of(mcontext)
            .userData
            .list_of_read_books
            .elementAt(booklocation))
        .listen((listOfQuestions) =>
            selectOneQuestionToSendBack(listOfQuestions, booklocation));
  }

  void getListOfAnsweredQuestionsUpdateQuanda(DocumentSnapshot d) {
    List<Map> myMaps = new List();
    int answered_questions_location =
        d.data.keys.toList().indexOf('answered_questions');
    List values = d.data.values.toList()[answered_questions_location];
    print('Question engine Getting List of answered questions');
    List<Map<dynamic, dynamic>> second;
    List<AnsweredQuestions> myQuestions = new List();
    try {
      //Todo: May want to optimize this operation to just update those that have changed
      values
          .forEach((each) => myQuestions.add(AnsweredQuestions.fromJson(each)));
      print('Question engine Got Answered Question Without Errors');
      if (Quanda.of(mcontext).allAnsweredQuestions != myQuestions) {
        Quanda.of(mcontext).allAnsweredQuestions = myQuestions;
      }
    } catch (e) {
      print(e);
    }
  }

  void selectOneQuestionToSendBack(
      QuerySnapshot listOfQuestions, int booklocation) {
    List<BookQuestion> listOfBookQuestion = listOfQuestions.documents
        .toList()
        .map((each) => BookQuestion.fromJson(each.data))
        .toList();
    print(
        'Question engine First Element question: ${listOfBookQuestion.elementAt(0).question}');
    int selectRamdomQuestion = new Random().nextInt(listOfBookQuestion.length);
    //Check whether the user has done the question
    if (checkIfQuestionIsNew(listOfBookQuestion, selectRamdomQuestion)) {
      print('Question engine Question found');
      print(
          'Question engine The Question is: ${listOfBookQuestion.elementAt(selectRamdomQuestion).question}');
      //Send question to stream
      _controller.add(listOfBookQuestion.elementAt(selectRamdomQuestion));
      return;
    } else {
      //TODO:get Another question
      print('Will need to check another questions');
      //Checking forward
      print('Will check forward');
      for (int i = 0; i < listOfBookQuestion.length; i++) {
        int newQuestionIndex = selectRamdomQuestion + i;
        if (checkIfQuestionIsNew(listOfBookQuestion, newQuestionIndex)) {
          _controller.add(listOfBookQuestion.elementAt(newQuestionIndex));
          return;
        }
      }
      print(' That did not work Will check backwards');
      for (int i = selectRamdomQuestion; i >= 0; i--) {
        int newQuestionIndex = selectRamdomQuestion + i;
        if (checkIfQuestionIsNew(listOfBookQuestion, newQuestionIndex)) {
          _controller.add(listOfBookQuestion.elementAt(newQuestionIndex));
          return;
        }
      }
    }
  }

  bool checkIfQuestionIsNew(
      List<BookQuestion> listOfBookQuestion, int selectRamdomQuestion) {
    //Check if an item exists in the answered list for this question
    return Quanda.of(mcontext).userData.answered_questions.indexWhere((e) =>
                e['question'] ==
                listOfBookQuestion
                    .elementAt(selectRamdomQuestion)
                    .questionId) ==
            -1
        ? true
        : false;
  }

  void requestQuestionAgain() {
    selectBookRandom();
  }

  void createDummyListOfQuestionsAnswered() {
    AnsweredQuestions myQuestion = new AnsweredQuestions(89, 0);
    AnsweredQuestions myQuestion2 = new AnsweredQuestions(88, 0);
    AnsweredQuestions myQuestion3 = new AnsweredQuestions(55, 0);
    List<AnsweredQuestions> myQuestions = new List();
    myQuestions.add(myQuestion);
    myQuestions.add(myQuestion2);
    myQuestions.add(myQuestion3);
    Map map = new Map();
    List<Map> maps = new List();
    maps.add(myQuestion.toJson());
    maps.add(myQuestion2.toJson());
    maps.add(myQuestion3.toJson());
    myQuestions.forEach((i) => map.addAll(i.toJson()));
    FireProvider.of(mcontext)
        .fireBase
        .updateListofAnsweredQuestions(mcontext, maps);
  }
}
