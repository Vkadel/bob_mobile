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
  bool isGettingQuestion = false;
  User myUser;
  BuildContext mcontext;
  Stream<Question> generatedQuestion;
  BooksMaster bookQueried;
  int IdofBookChoosenFromQuanda;
  final StreamController _controller =
      StreamController<BookQuestion>.broadcast();
  List answeredQuestionsForBook;
  bool engineIsRunning = false;
  QuestionEngine();

  Stream<BookQuestion> getStream() {
    return _controller.stream.asBroadcastStream();
  }

  void InitEngine(BuildContext context) {
    engineIsRunning = true;
    print('Initializing Question Engine.....');
    isGettingQuestion = true;
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
        .getListOfAnsweredQuestions(mcontext, Quanda.of(mcontext).myUser.id)
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
    List values;
    values = d.data.values.toList()[answered_questions_location];
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
      QuerySnapshot listOfQuestions, int booklocation) async {
    if (Quanda.of(mcontext).userData.answered_questions == null) {
      print(
          'Will create List of Anwsered question in Firestore after manual reset');
      this.createDummyListOfQuestionsAnswered();
    }
    List<BookQuestion> listOfBookQuestion = listOfQuestions.documents
        .toList()
        .map((each) => BookQuestion.fromJson(each.data))
        .toList();
    print(
        'Question engine First Element question: ${listOfBookQuestion.elementAt(0).question}');
    int randomqIndex = new Random().nextInt(listOfBookQuestion.length);

    if (checkQuestionToSend(listOfBookQuestion, randomqIndex)) {
      print(
          'Question found. The Question is: ${listOfBookQuestion.elementAt(randomqIndex).question}');
      _controller.add(listOfBookQuestion.elementAt(randomqIndex));
    } else {
      print('Will need to check another questions');
      if (willLookForQuestionsUp(listOfBookQuestion, randomqIndex) != null) {
        print('Found Question going Up');
        _controller
            .add(willLookForQuestionsUp(listOfBookQuestion, randomqIndex));
      } else {
        print(' That did not work Will check backwards');
        if (willLookForQuestionsDown(listOfBookQuestion, randomqIndex) !=
            null) {
          print('Found Question going Down');
          _controller
              .add(willLookForQuestionsDown(listOfBookQuestion, randomqIndex));
        } else {
          print(
              'Search did not find a question will need to reset questions for this book');
          FireProvider.of(mcontext).fireBase.resetQuestionsForAbook(
              mcontext, listOfBookQuestion.elementAt(0).id);
          /* _controller
              .add(willLookForQuestionsDown(listOfBookQuestion, randomqIndex));*/
        }
      }
    }
  }

  bool checkQuestionToSend(
      List<BookQuestion> listOfBookQuestion, int randomqIndex) {
    return checkIfQuestionIsNew(listOfBookQuestion, randomqIndex) ||
        checkIfQuestionHasNotBeenCorrect(listOfBookQuestion, randomqIndex);
  }

  bool checkIfQuestionIsNew(
      List<BookQuestion> listOfBookQuestion, int new_question_index) {
    //Check if an item exists in the answered list for this question
    int number = Quanda.of(mcontext).userData.answered_questions.indexWhere(
        (e) =>
            e['question'] ==
            listOfBookQuestion.elementAt(new_question_index).questionId);
    return Quanda.of(mcontext).userData.answered_questions.indexWhere((e) =>
                e['question'] ==
                listOfBookQuestion.elementAt(new_question_index).questionId) ==
            -1
        ? true
        : false;
  }

  bool checkIfQuestionHasNotBeenCorrect(
      List<BookQuestion> listOfBookQuestion, int new_question_index) {
    //Check if an item exists in the answered list for this question
    int number = Quanda.of(mcontext).userData.answered_questions.indexWhere(
        (e) =>
            e['question'] ==
            listOfBookQuestion.elementAt(new_question_index).questionId);
    return number != -1 &&
            Quanda.of(mcontext)
                    .userData
                    .answered_questions
                    .elementAt(number)['status'] >
                0
        ? true
        : false;
  }

  BookQuestion willLookForQuestionsDown(
      List<BookQuestion> listOfBookQuestion, int randomqIndex) {
    for (var i = randomqIndex; i >= 0; i--) {
      if (checkQuestionToSend(listOfBookQuestion, i)) {
        print(
            'Broadcasting question from backwards: ${listOfBookQuestion.elementAt(i).question}');
        return listOfBookQuestion.elementAt(i);
      }
    }
    return null;
  }

  BookQuestion willLookForQuestionsUp(
      List<BookQuestion> listOfBookQuestion, int randomqIndex) {
    for (var i = randomqIndex; i < listOfBookQuestion.length; i++) {
      if (checkQuestionToSend(listOfBookQuestion, i)) {
        print(
            'Broadcasting question from backwards: ${listOfBookQuestion.elementAt(i).question}');
        return listOfBookQuestion.elementAt(i);
      }
    }
    return null;
  }

  void requestQuestionAgain() {
    selectBookRandom();
  }

  void createDummyListOfQuestionsAnswered() {
    AnsweredQuestions myQuestion = new AnsweredQuestions(0, 0, 0);

    List<AnsweredQuestions> myQuestions = new List();
    myQuestions.add(myQuestion);

    Map map = new Map();
    List<Map> maps = new List();
    maps.add(myQuestion.toJson());

    myQuestions.forEach((i) => map.addAll(i.toJson()));
    FireProvider.of(mcontext)
        .fireBase
        .updateListofAnsweredQuestions(mcontext, maps);
    return;
  }
}
