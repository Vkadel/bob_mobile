import 'package:bob_mobile/constants.dart';
import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/book_types.dart';
import 'package:bob_mobile/data_type/items.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/data_type/proposed_books.dart';
import 'package:bob_mobile/data_type/proposed_questions.dart';
import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'data_type/answered_questions.dart';
import 'data_type/books.dart';

abstract class BoBFireBase {
  Stream<QuerySnapshot> get_userprofile(String uid);
  Future<void> UserExist(String uid);
  Future<void> createUserProfile(
      String uid, String email, BuildContext context);
  Stream<QuerySnapshot> getQuestions();
  Future<void> setUpUserPersonality(FirebaseUser Firebaseuser, User user);
  Stream<QuerySnapshot> getPlayerRankings();
  Stream<QuerySnapshot> getTeamRankings();
  Stream<DocumentSnapshot> getClassStats(BuildContext context);
  Future<void> getBookTypes(BuildContext context);
  Stream<QuerySnapshot> getMyItems(BuildContext context);
  Stream<QuerySnapshot> getMyProposedQuestions(BuildContext context);
  Stream<QuerySnapshot> getMyProposedBooks(BuildContext context);
  Stream<QuerySnapshot> getMyReadBooks(BuildContext context);
  Stream<QuerySnapshot> getMyAnsweredQuestions(BuildContext context);
  Stream<QuerySnapshot> getMasterListOfItems(BuildContext context);
  Future<void> useItem(BuildContext context, Items itemType, int duration);
  Stream<DocumentSnapshot> getUserReadListOfBooks(User user);
  Stream<DocumentSnapshot> getMasterBookInfo(int bookid);
  Stream<QuerySnapshot> getQuestionsForMasterBook(int bookid);
  Stream<DocumentSnapshot> getListOfAnsweredQuestions(
      BuildContext context, String uid);
  Future<void> updateListofAnsweredQuestions(
      BuildContext context, List<Map> maps);
  Future<void> uploadQuestion(BookQuestion question, int documentId);
  Stream<QuerySnapshot> getMasterListofBooks();
  Future<void> reportAnswer(
      BuildContext context, int questionId, bool answeredCorrectly);
  Future<void> reportPointPersonal(BuildContext context, int pointsToAdd);
  Future<void> resetQuestionsForAbook(BuildContext context, int bookId);
}

class MBobFireBase implements BoBFireBase {
  final Firestore _firestore = Firestore.instance;
  User currentAppUser;

  @override
  Future<void> UserExist(String uid) {
    // TODO: implement persistance enabled
    get_userprofile(uid)
        .listen((data) => data.documents.forEach((doc) => print(doc["uid"])));
  }

  @override
  // ignore: non_constant_identifier_names
  Stream<QuerySnapshot> get_userprofile(String uid) {
    print('SNAPSHOT Connection: looking for $uid');
    return (_firestore
        .collection('users')
        .where('id', isEqualTo: uid)
        .snapshots());
  }

  @override
  Future<void> createUserProfile(
      String uid, String email, BuildContext context) {
    //TODO: String
    var user = new User(
        'Enter New Name',
        email,
        uid,
        1,
        0,
        {
          'value_e': 0,
          'value_i': 0,
          'value_s': 0,
          'value_n': 0,
          'value_t': 0,
          'value_f': 0,
          'value_j': 0,
          'value_p': 0,
        },
        0);

    /*//Proposed_questions_Test_creation
    _proposed_question_test_creationg(uid);

    //Items_test_creation
    _items_list_test_generation(uid);

    //Proposed_books_test_creation(uid);
    _proposed_books_test_creation(uid);

    _read_books_test_creation(uid);
    _answered_questions_check(uid);*/

    Quanda.of(context).myUser = user;
    _firestore.collection('users').document().setData(user.toJson());

    print('Creating user Data');
    UserData userData = new UserData(List<int>(), uid);
    userData.answered_questions = List<Map<dynamic, dynamic>>();
    print('Updating Firestore with User_data');
    _firestore.collection('user_data').document(uid).setData(userData.toJson());

    print('Creating Player ranking');
    PlayerPoints playerPoints = new PlayerPoints(
        Constants.initial_point_value, uid, Quanda.of(context).myUser.name);

    print('Updating Firestore with User_data');
    _firestore
        .collection('player_rankings')
        .document(uid)
        .setData(playerPoints.toJson());
  }

  void _proposed_question_test_creationg(String uid) {
    ProposedQuestions question = new ProposedQuestions(
        'question',
        'wronganswerone',
        'answertwo',
        'answerthree',
        'correctanswer',
        0,
        DateTime.now().millisecondsSinceEpoch,
        '48MJq4Ty2zyQP0xXd0hE');
    question.id = uid;
    List<ProposedQuestions> myquestionlist = new List<ProposedQuestions>();
    myquestionlist.add(question);
    myquestionlist.forEach((propQ) => _firestore
        .collection('user_data')
        .document('$uid')
        .collection('list_of_proposed_questions')
        .document()
        .setData(propQ.toJson()));

    //Todo: Create
  }

  void _items_list_test_generation(String uid) {
    Items item = new Items(
        0, 0, uid, Timestamp.now().millisecondsSinceEpoch + 5000000, false);
    Items item2 = new Items(
        1, 0, uid, Timestamp.now().millisecondsSinceEpoch + 5000000, false);
    List<Items> items = new List<Items>();

    items.add(item);
    items.add(item2);
    items.forEach((propQ) => _firestore
        .collection('user_data')
        .document('$uid')
        .collection('list_of_items')
        .document()
        .setData(propQ.toJson()));
  }

  void _proposed_books_test_creation(uid) {
    ProposedBooks proposedBooks =
        new ProposedBooks('name', 'author_name', true, uid);
    List<ProposedBooks> myProposedBooksList = new List<ProposedBooks>();
    myProposedBooksList.add(proposedBooks);
    myProposedBooksList.forEach((propQ) => _firestore
        .collection('user_data')
        .document('$uid')
        .collection('list_of_proposed_books')
        .document()
        .setData(propQ.toJson()));
  }

  void _read_books_test_creation(uid) {
    Books book1 = new Books(uid, 1, '0');
    List<Books> myProposedBooksList = new List<Books>();
    myProposedBooksList.add(book1);
    myProposedBooksList.forEach((propQ) => _firestore
        .collection('user_data')
        .document('$uid')
        .collection('list_of_read_books')
        .document()
        .setData(propQ.toJson()));
  }

  void _answered_questions_check(uid) {
    AnsweredQuestions question = new AnsweredQuestions(0, 1, 0);
    List<AnsweredQuestions> myquestionlist = new List<AnsweredQuestions>();
    myquestionlist.add(question);
    myquestionlist.forEach((propQ) => _firestore
        .collection('user_data')
        .document('$uid')
        .collection('list_of_answered_questions')
        .document()
        .setData(propQ.toJson()));
  }

  @override
  Stream<QuerySnapshot> getQuestions() {
    // TODO: String
    return _firestore.collection('personality_survey_q').snapshots();
  }

  @override
  Future<void> setUpUserPersonality(
      FirebaseUser firebaseuser, User user) async {
    String uid = firebaseuser.uid;

    await _firestore
        .collection('users')
        .where('id', isEqualTo: '$uid')
        .snapshots()
        .listen((data) => _firestore.runTransaction((transaction) async {
              DocumentSnapshot freshSnapShot =
                  await transaction.get(data.documents.elementAt(0).reference);
              if (freshSnapShot.exists) {
                /*String documentPath = freshSnapShot.reference.path.toString();
                final DocumentReference postRef =
                    Firestore.instance.document('$documentPath/personality');*/
                User freshUser = User.fromJson(freshSnapShot.data);
                freshUser.personality = user.personality;
                await transaction.update(
                    freshSnapShot.reference, freshUser.toJson());
              }
            }));
    print('I wrote');
  }

  @override
  Future<void> setUpHero(FirebaseUser firebaseuser, User user) async {
    String uid = firebaseuser.uid;
    await _firestore
        .collection('users')
        .where('id', isEqualTo: '$uid')
        .snapshots()
        .listen((data) => _firestore.runTransaction((transaction) async {
              DocumentSnapshot freshSnapShot =
                  await transaction.get(data.documents.elementAt(0).reference);
              if (freshSnapShot.exists) {
                User freshUser = User.fromJson(freshSnapShot.data);
                freshUser.role = user.role;
                freshUser.name = user.name;
                await transaction.update(
                    freshSnapShot.reference, freshUser.toJson());
                //TODO:Set up all the other lists for items and proposedbooks for the first time
                _setUpUserListOfProposedQuestion(firebaseuser);
              }
            }));
    print('I wrote');
  }

  void _setUpUserListOfProposedQuestion(FirebaseUser firebaseuser) {
    String uid = firebaseuser.uid;
    _firestore
        .collection('proposed_questions_user')
        .where('id', isEqualTo: '$uid')
        .snapshots()
        .listen((data) => _firestore.runTransaction((transaction) async {
              DocumentSnapshot freshSnapShot =
                  await transaction.get(data.documents.elementAt(0).reference);
              if (freshSnapShot.exists) {
                return;
              } else {
                _firestore
                    .collection('proposed_questions_user')
                    .document('$uid')
                    .setData({
                  'id': '$uid',
                });
              }
            }));
  }

  @override
  Stream<QuerySnapshot> getPlayerRankings() {
    print('Queried lists of rankings single user....');
    return (_firestore
        .collection('player_rankings')
        .orderBy('player_points', descending: true)
        .snapshots());
  }

  @override
  Stream<QuerySnapshot> getTeamRankings() {
    print('Queried lists of rankings teams....');
    return (_firestore
        .collection('team_ratings')
        .orderBy('team_points', descending: true)
        .snapshots());
  }

  @override
  Stream<DocumentSnapshot> getClassStats(BuildContext context) {
    int roleId = Quanda.of(context).myUser.role;
    return _firestore
        .collection('avatar_type_stats')
        .document(roleId.toString())
        .snapshots();
  }

  @override
  Future<void> getBookTypes(BuildContext context) {
    //Save book types on Quanda to share them with the application once they are needed.
    List<BookTypes> bookTypesList = new List();
    _firestore
        .collection('book_type')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.documents != null) {
        snapshot.documents.toList().forEach((DocumentSnapshot d) {
          bookTypesList.add(BookTypes.fromJson(d.data));
          bookTypesList.elementAt(int.parse(d.documentID)).id =
              int.parse(d.documentID);
        });
        Quanda.of(context).bookTypes = bookTypesList;
      }
    });
  }

  @override
  Stream<QuerySnapshot> getMyAnsweredQuestions(BuildContext context) {
    // TODO: implement getMyAnsweredQuestions
    return null;
  }

  @override
  Stream<QuerySnapshot> getMyItems(BuildContext context) {
    // Get items that are active and
    print('getting my items');
    return _firestore
        .collection('user_data')
        .document(Quanda.of(context).myUser.id)
        .collection('list_of_items')
        //leave the userID here because is the only way for firestore to
        //allow the read through rules
        .where('id', isEqualTo: Quanda.of(context).myUser.id)
        .where('endDate',
            isGreaterThanOrEqualTo: Timestamp.now().millisecondsSinceEpoch)
        .orderBy('endDate', descending: false)
        .snapshots();
  }

  @override
  Future<void> useItem(
      BuildContext context, Items itemType, int duration_per_days) async {
    int days_buff_last;
    BuildContext Main_context = context;
    QuerySnapshot querySnapshot = await _firestore
        .collection('user_data')
        .document(Quanda.of(context).myUser.id)
        .collection('list_of_items')
        .where('id', isEqualTo: Quanda.of(context).myUser.id)
        .where('item', isEqualTo: itemType.item)
        .where('inuse', isEqualTo: false)
        .snapshots()
        .first
        .then((data) {
      _firestore.runTransaction((transaction) async {
        DocumentSnapshot freshSnapshot =
            await transaction.get(data.documents.first.reference);
        Items freshItem = new Items(
            Items.fromJson(freshSnapshot.data).item,
            Items.fromJson(freshSnapshot.data).status,
            Items.fromJson(freshSnapshot.data).id,
            Items.fromJson(freshSnapshot.data).endDate,
            Items.fromJson(freshSnapshot.data).inuse);
        freshItem.status = Constants.item_used;
        freshItem.inuse = true;
        days_buff_last = Quanda.of(Main_context)
            .masterListOfItems
            .elementAt((freshItem.item))
            .duration_days;
        freshItem.endDate = days_buff_last * (24 * 3600000) +
            Timestamp.now().millisecondsSinceEpoch;
        await transaction.update(freshSnapshot.reference, freshItem.toJson());
        print('I wrote on itemID: ${freshSnapshot.reference.path}');
      });
    });
  }

  @override
  Stream<QuerySnapshot> getMasterListOfItems(context) {
    print('Fetching master list of items');
    return _firestore
        .collection('items_master')
        .where('status', isGreaterThanOrEqualTo: 1)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> getMyProposedBooks(BuildContext context) {
    // TODO: implement getMyProposedBooks
    return null;
  }

  @override
  Stream<QuerySnapshot> getMyProposedQuestions(BuildContext context) {
    // TODO: implement getMyProposedQuestions
    return null;
  }

  @override
  Stream<QuerySnapshot> getMyReadBooks(BuildContext context) {
    // TODO: implement getMyReadBooks
    return null;
  }

  @override
  Stream<DocumentSnapshot> getUserReadListOfBooks(User user) {
    return _firestore
        .collection('user_data')
        .document('${user.id}')
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot> getMasterBookInfo(int bookid) {
    return _firestore
        .collection('book_master')
        .document('${bookid}')
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> getMasterListofBooks() {
    return _firestore.collection('book_master').snapshots();
  }

  @override
  Stream<QuerySnapshot> getQuestionsForMasterBook(int bookid) {
    return _firestore
        .collection('question')
        .where('id', isEqualTo: bookid)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot> getListOfAnsweredQuestions(
      BuildContext context, String uid) {
    return _firestore
        .collection('user_data')
        .document(Quanda.of(context).myUser.id)
        .snapshots();
  }

  @override
  Future<void> updateListofAnsweredQuestions(
      BuildContext context, List<Map> maps) async {
    DocumentReference documentReference = await _firestore
        .collection('user_data')
        .document(Quanda.of(context).myUser.id);
    _firestore.runTransaction((tran) async {
      await tran.update(documentReference, {'answered_questions': maps});
    });
  }

  @override
  Future<void> uploadQuestion(BookQuestion question, int documentId) async {
    // TODO: implement uploadQuestion
    await _firestore
        .collection('question')
        .document('$documentId')
        .setData(question.toJson());
  }

  @override
  Future<void> reportAnswer(
      BuildContext context, int questionId, bool answeredCorrectly) async {
    DocumentReference reference = _firestore
        .collection('user_data')
        .document(Quanda.of(context).myUser.id);
    //Start transaction to get the item first and lock it
    _firestore.runTransaction((transaction) async {
      transaction.get(reference).then((data) {
        UserData userData = UserData.fromJson(data.data);
        List<AnsweredQuestions> answeredQuestionsList = new List();
        try {
          //Try to create a list of answeredQuestions for searching.
          answeredQuestionsList = userData.answered_questions
              .toList()
              .map((item) => AnsweredQuestions.fromJson(item))
              .toList();
        } catch (e) {
          print('e');
        }

        int thisQuestionIndex = -1;
        //identify where this item is located in the list

        thisQuestionIndex =
            answeredQuestionsList.indexWhere((a) => a.question == questionId);

        //if question doesn't exist add it,
        // but if it does replace it and update status
        if (thisQuestionIndex == -1) {
          answeredQuestionsList.add(
              new AnsweredQuestions(questionId, answeredCorrectly ? 0 : 1, 0));
        } else {
          answeredCorrectly
              ? answeredQuestionsList.elementAt(thisQuestionIndex).status = 0
              : answeredQuestionsList.elementAt(thisQuestionIndex).status =
                  answeredQuestionsList.elementAt(thisQuestionIndex).status + 1;
        }
        //Replace the value of answeredquestions with updated one on firestore
        var map;
        try {
          map = answeredQuestionsList.map((item) => item.toJson()).toList();
          userData.answered_questions = map;
        } catch (e) {
          print(e);
        }

        print('I will write the questions answered');
        try {
          _firestore.runTransaction((transa) async {
            await transa.update(reference, userData.toJson());
          });
        } catch (e) {
          print(e);
        }
      });
    });
  }

  Future<void> resetQuestionsForAbook(BuildContext context, int bookId) async {
    await getQuestionsForMasterBook(bookId).forEach((item) {
      List<BookQuestion> bookQuestions;
      List<AnsweredQuestions> answeredQuestionsList;
      try {
        //Try to create a list of answeredQuestions for searching.
        answeredQuestionsList = Quanda.of(context)
            .userData
            .answered_questions
            .toList()
            .map((item) => AnsweredQuestions.fromJson(item))
            .toList();
      } catch (e) {
        print('e');
      }
      try {
        bookQuestions = item.documents
            .map((each) => BookQuestion.fromJson(each.data))
            .toList();
        print('I got the book questions');
      } catch (e) {
        print(e);
      }
      for (int i = 0; i <= bookQuestions.length - 1; i++) {
        int index = answeredQuestionsList.indexWhere(
            (e) => e.question == bookQuestions.elementAt(i).questionId);
        answeredQuestionsList.elementAt(index).resetAnsweredQuestion();
        print(
            'Will Reset question: ${answeredQuestionsList.elementAt(index).question}');
      }
      print('Will start update to local to reset for Awnsered Questions');
      //Need to save it in Quanda
      try {
        Quanda.of(context).userData.answered_questions =
            answeredQuestionsList.map((anq) => anq.toJson()).toList();
        print('Updated local reset for Awnsered Questions');
      } catch (e) {
        print(e);
      }
      print('Will need to send to firestore');
      List<Map> maps = new List();
      answeredQuestionsList.forEach((item) => maps.add(item.toJson()));
      updateListofAnsweredQuestions(context, maps);
    });
  }

  @override
  Future<void> reportPointPersonal(
      BuildContext context, int pointsToAdd) async {
    var playerPointsDocument = await _firestore
        .collection('player_rankings')
        .document(Quanda.of(context).myUser.id)
        .get();
    if (playerPointsDocument.data == null || !playerPointsDocument.exists) {
      print('Had to create a playerpoints');
      await _firestore
          .collection('player_rankings')
          .document(Quanda.of(context).myUser.id)
          .setData(new PlayerPoints(pointsToAdd, Quanda.of(context).myUser.id,
                  Quanda.of(context).myUser.name)
              .toJson());
    } else {
      _firestore.runTransaction((transa) async {
        DocumentSnapshot playerPointdata =
            await transa.get(playerPointsDocument.reference);
        PlayerPoints playerPoints =
            await PlayerPoints.fromJson(playerPointdata.data);
        playerPoints.player_points = playerPoints.player_points + pointsToAdd;
        transa
            .set(playerPointsDocument.reference, playerPoints.toJson())
            .catchError((e) => print(e));
      });
    }
  }

  Future<bool> checkIfNameExistAndCreateRanking(
      BuildContext context, String name) async {
    bool nameExist;
    PlayerPoints playerPoints =
        new PlayerPoints(0, Quanda.of(context).myUser.id, name);
    QuerySnapshot itemSnapShot = await _firestore
        .collection('player_rankings')
        .where('player_name', isEqualTo: name)
        .snapshots()
        .first;
    if (itemSnapShot.documents.length > 0) {
      return true;
    } else {
      print('Setting up player ranking');
      var response = await _firestore
          .collection('player_rankings')
          .document(Quanda.of(context).myUser.id)
          .setData(playerPoints.toJson());
      var response2 = await setUpHero(
          FireProvider.of(context).auth.getLastUserLoged(),
          Quanda.of(context).myUser);
      return false;
    }
  }
}
