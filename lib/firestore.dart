import 'package:bob_mobile/data_type/book_types.dart';
import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
    Quanda.of(context).myUser = user;
    _firestore.collection('users').document().setData(user.toJson());
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
                /*String documentPath = freshSnapShot.reference.path.toString();
                final DocumentReference postRef =
                    Firestore.instance.document('$documentPath/personality');*/
                User freshUser = User.fromJson(freshSnapShot.data);
                freshUser.role = user.role;
                await transaction.update(
                    freshSnapShot.reference, freshUser.toJson());
              }
            }));
    print('I wrote');
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
}
