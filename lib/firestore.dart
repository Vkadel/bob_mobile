import 'package:bob_mobile/constants.dart';
import 'package:bob_mobile/data_type/book_types.dart';
import 'package:bob_mobile/data_type/items.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/proposed_books.dart';
import 'package:bob_mobile/data_type/proposed_questions.dart';
import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/qanda.dart';
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

    //Proposed_questions_Test_creation
    _proposed_question_test_creationg(uid);

    //Items_test_creation
    _items_list_test_generation(uid);

    //Proposed_books_test_creation(uid);
    _proposed_books_test_creation(uid);

    _read_books_test_creation(uid);
    _answered_questions_check(uid);
    //Todo: Check the query for documents works

    Quanda.of(context).myUser = user;
    _firestore.collection('users').document().setData(user.toJson());
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
    AnsweredQuestions question = new AnsweredQuestions('0', 1, uid);
    question.id = uid;
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
                await transaction.update(
                    freshSnapShot.reference, freshUser.toJson());
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
  Stream<QuerySnapshot> getQuestionsForMasterBook(int bookid) {
    return _firestore
        .collection('question')
        .where('id', isEqualTo: bookid)
        .snapshots();
  }
}
