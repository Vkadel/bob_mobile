import 'dart:async';
import 'dart:math';

import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/books.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:bob_mobile/widgets/firstQuestionsUpload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'data_type/question.dart';
import 'data_type/user.dart';

class QuestionEngine {
  User myUser;
  BuildContext context;
  Stream<Question> generatedQuestion;
  int IdofBookChoosenFromQuanda;
  final StreamController _controller = StreamController<Question>();

  QuestionEngine();

  Stream<Question> getQuestion() {
    return generatedQuestion;
  }

  void InitEngine() {
    getUsersBooks();
  }

  void getUsersBooks() {
    print("Starting to get user books");
    Provider.of(context)
        .fireBase
        .getUserReadListOfBooks(Quanda.of(context).myUser)
        .listen((list) => updateQuandaListOfBooks(list));
  }

  void updateQuandaListOfBooks(DocumentSnapshot gotDocs) {
    Quanda.of(context).userData = UserData.fromJson(gotDocs.data);
    print('Updated Quanda with books Read');
    selectBookRandom();
  }

  void selectBookRandom() {
    int listSize = Quanda.of(context).userData.list_of_read_books.length;
    int selectedBook = new Random().nextInt(listSize);
    print('Selected Book number: ${listSize}');
    getMasterBookInfo(selectedBook);
  }

  void getMasterBookInfo(int bookLocationInQuanda) {
    IdofBookChoosenFromQuanda=Quanda.of(context).userData.list_of_read_books.elementAt(bookLocationInQuanda);
    Provider.of(context)
        .fireBase
        .getMasterBookInfo(
        IdofBookChoosenFromQuanda)
        .listen((bookSnapshot) => getBookQuestions(bookSnapshot, bookLocationInQuanda));
  }

  void getBookQuestions(DocumentSnapshot bookSnapshot, int booklocation) {
    Provider.of(context)
        .fireBase
        .getQuestionsForMasterBook(Quanda.of(context)
            .userData
            .list_of_read_books
            .elementAt(booklocation))
        .listen(
            (listOfQuestions) => selectOneQuestionToSendBack(listOfQuestions));
  }

  void selectOneQuestionToSendBack(QuerySnapshot listOfQuestions) {
    List<BookQuestion> listOfBookQuestion = listOfQuestions.documents
        .toList()
        .map((each) => BookQuestion.fromJson(each.data))
        .toList();
    print(
        'First Element question: ${listOfBookQuestion.elementAt(0).question}');
  }
}
