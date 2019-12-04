import 'dart:convert';

import 'package:bob_mobile/battle_page.dart';
import 'package:bob_mobile/data_type/private.dart';
import 'package:bob_mobile/data_type/team.dart';
import 'package:bob_mobile/data_type/team_invites.dart';
import 'package:bob_mobile/data_type/team_points.dart';
import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/book_types.dart';
import 'package:bob_mobile/data_type/items.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/data_type/proposed_books.dart';
import 'package:bob_mobile/data_type/proposed_questions.dart';
import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/team_formation_data.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import '../data_type/answered_questions.dart';
import '../data_type/books.dart';

abstract class BoBFireBase {
  Stream<QuerySnapshot> get_userprofile(String uid);
  Future<void> UserExist(String uid);
  Future<User> refreshUser(BuildContext context);
  Future<void> createUserProfile(
      String uid, String email, BuildContext context);
  Stream<QuerySnapshot> getQuestions();
  Future<void> setUpUserPersonality(FirebaseUser Firebaseuser, User user);
  Stream<QuerySnapshot> getPlayerRankings();
  Stream<DocumentSnapshot> getPlayerRankingPoints(BuildContext context);
  Stream<QuerySnapshot> getTeamRankings();
  Future<Stream<DocumentSnapshot>> getClassStats(BuildContext context);
  Future<void> getBookTypes(BuildContext context);
  Future<Stream<QuerySnapshot>> getMyItems(BuildContext context);
  Stream<QuerySnapshot> getMyProposedQuestions(BuildContext context);
  Stream<QuerySnapshot> getMyProposedBooks(BuildContext context);
  /*Stream<QuerySnapshot> getMyReadBooks(BuildContext context);*/
  Stream<QuerySnapshot> getMasterListOfItems(BuildContext context);
  Future<void> useItem(BuildContext context, Items itemType, int duration);
  Stream<DocumentSnapshot> getUserReadListOfBooks(User user);
  Stream<DocumentSnapshot> getMasterBookInfo(int bookid);
  Stream<QuerySnapshot> getQuestionsForMasterBook(int bookid, int book_section);
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
  Future<bool> createTeam(BuildContext context, String teamName);
  Future<void> getTeam(BuildContext context, String teamName);
  Stream<QuerySnapshot> getOutstandingTeamInvitations(BuildContext context);
  Future<void> acceptTeamInvite(int indexOfinvite, BuildContext context);
  Future<void> deleteDenyMember(Team team, BuildContext context, int index);
  Future<Stream<DocumentSnapshot>> getUserData(BuildContext context);
  Future<void> updateReadBooks(
      BuildContext context, List<Books> theBooks, Null Function());
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

  Future<User> refreshUser(BuildContext context) async {
    String userIdLogged = await FireProvider.of(context).auth.currentUser();
    QuerySnapshot userProfileSnap = await get_userprofile(userIdLogged).first;
    User userRefresh = User.fromJson(userProfileSnap.documents[0].data);
    Quanda.of(context).myUser = userRefresh;
    return userRefresh;
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
    _firestore.collection('users').document(uid).setData(user.toJson());

    print('Creating user Data');
    UserData userData = new UserData(List<Books>(), uid);
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
    Books book1 = new Books(uid, 1, 0);
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
                freshUser.team_id = user.team_id;
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

  ///This will provide the list of suggestions for players name
  ///it most always remain sync to avoid name repetition
  @override
  Stream<QuerySnapshot> getPlayerRankings() {
    print('Queried lists of rankings single user....');
    return (_firestore
        .collection('player_rankings')
        .orderBy('player_points', descending: true)
        .snapshots());
  }

  @override
  Stream<QuerySnapshot> getPlayerRanking(BuildContext context) {
    /*print('Queried lists of rankings single user....');*/
    return (_firestore
        .collection('player_rankings')
        .where('id', isEqualTo: Quanda.of(context).myUser.id)
        .orderBy('player_points', descending: true)
        .snapshots());
  }

  ///This will provide the list of suggestions for Team name
  ///it most always remain sync to avoid name repetition
  @override
  Stream<QuerySnapshot> getTeamRankings() {
    print('Queried lists of rankings teams....');
    return (_firestore
        .collection('team_ratings')
        .orderBy('team_points', descending: true)
        .snapshots());
  }

  @override
  Future<Stream<DocumentSnapshot>> getClassStats(BuildContext context) async {
    int roleId;
    if (Quanda.of(context).myUser != null &&
        Quanda.of(context).myUser.role != null) {
      roleId = Quanda.of(context).myUser.role;
    } else {
      //there is noUser
      User userRefresh = await refreshUser(context);
      roleId = userRefresh.role;
    }
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
  Future<Stream<QuerySnapshot>> getMyItems(BuildContext context) async {
    // Get items that are active and
    print('getting my items');
    if (Quanda.of(context).myUser == null) {
      //user need refresh
      await refreshUser(context);
    }
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

  //This method will only load items for sale that are active
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

  ///This query has a composite field in firestore the field is designated
  ///based on the section and the book id
  @override
  Stream<QuerySnapshot> getQuestionsForMasterBook(
      int bookid, int book_section) {
    return _firestore
        .collection('question')
        .where('id', isEqualTo: bookid)
        .where('book_section', isLessThanOrEqualTo: book_section)
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
    await getQuestionsForMasterBook(bookId, 3).forEach((item) {
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

  @override
  Future<bool> createTeam(BuildContext context, String teamName) async {
    //Prepare the documents
    Transaction transaction;
    TeamPoints teamPoints = new TeamPoints(0, null, teamName);
    teamPoints.addUserIdToLeader(Quanda.of(context).myUser.id);
    Team team = new Team().formInitialTeamWithNameLeader(
        teamName,
        Quanda.of(context).myUser.name,
        Quanda.of(context).myUser.id,
        Quanda.of(context).myUser.school_id);
    Private private = new Private();
    private.members = new Map();
    private.members['userOwnerid'] = Quanda.of(context).myUser.id;

    QuerySnapshot querySnapShot = await _firestore
        .collection('team_ratings')
        .where('team_name', isEqualTo: teamName)
        .snapshots()
        .first;
    //Document exist return false
    if (querySnapShot.documents.length > 0) {
      return false;
    } else {
      //Document does not exist we can create it
      WriteBatch teamCreationWrite = _firestore.batch();
      teamCreationWrite.setData(
          _firestore.collection('team_ratings').document(teamName),
          teamPoints.toJson());
      teamCreationWrite.setData(
          _firestore.collection('team').document(teamName), team.toJson());
      teamCreationWrite.setData(
          _firestore
              .collection('team')
              .document(teamName)
              .collection('private_data')
              .document('private'),
          private.toJson());
      try {
        teamCreationWrite.commit().then((item) {
          SnackBarMessage(
              'Team: ${teamName} was formed, add some members now', context);
          print(
              'I was able to write I will update all the items internally to move on to add members');
          User transitionUser = Quanda.of(context).myUser;
          transitionUser.team_id = teamName;
          setUpHero(
              FireProvider.of(context).auth.getLastUserLoged(), transitionUser);
          Provider.of<TeamFormationData>(context, listen: false)
              .updateteamGenerated(true);
        }).catchError(() {
          SnackBarMessage(
              'Not able to create a team try again, perhaps with other name',
              context);
          print('I was not able to create a team');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  //This method keeps the data information cache updated
  Future<void> getTeam(BuildContext context, String teamName) async {
    await _firestore
        .collection('team')
        .document(teamName)
        .snapshots()
        .listen((item) => {
              item != null
                  ? Quanda.of(context).myTeam = Team.fromJson(item.data)
                  : Quanda.of(context).myTeam = Team()
            });
  }

  //This method keeps the data information cache updated
  Stream<DocumentSnapshot> getTeamStream(
      BuildContext context, String teamName) {
    return _firestore.collection('team').document(teamName).snapshots();
  }

  Future<void> sendInviteToMember(String invitedName, String teamId,
      BuildContext context, int index) async {
    TeamInvites invitation = new TeamInvites();
    invitation.team_name = teamId;
    invitation.team_id = teamId;
    invitation.pending = true;
    invitation.accepted = false;
    invitation.invited_name = invitedName;
    invitation.from = Quanda.of(context).myUser.name;
    invitation.date_sent = Timestamp.now().millisecondsSinceEpoch;
    String invitationId = '${teamId}-${invitedName}';

    Team transicionTeam = Quanda.of(context).myTeam;
    String privateAggreDesignation;

    _firestore.runTransaction((tran) async {
      DocumentSnapshot teamSnapShot =
          await tran.get(_firestore.collection('team').document(teamId));

      //Will only start the transactions if a team exists
      if (teamSnapShot.exists) {
        transicionTeam = Team.fromJson(teamSnapShot.data);
        transicionTeam.memberOneName = 'New member';
        if (index == 1) {
          transicionTeam.memberOneName = invitedName;
          transicionTeam.invitationMemberOnePending = true;
          privateAggreDesignation = Private.memberid1;
        }
        if (index == 2) {
          transicionTeam.memberTwoName = invitedName;
          transicionTeam.invitationMemberTwoPending = true;
          privateAggreDesignation = Private.memberid2;
        }
        if (index == 3) {
          transicionTeam.memberThreeName = invitedName;
          transicionTeam.invitationMemberThreePending = true;
          privateAggreDesignation = Private.memberid3;
        }

        await tran.set(teamSnapShot.reference, transicionTeam.toJson());
        await tran.set(
            _firestore.collection('team_invites').document(invitationId),
            invitation.toJson());
      }
    }, timeout: Duration(seconds: 30));

    _firestore.runTransaction((trans2) async {
      DocumentSnapshot privateSnapshot = await trans2.get(_firestore
          .collection('team')
          .document(teamId)
          .collection('private_data')
          .document('private'));
      if (privateSnapshot.exists) {
        Private private = Private.fromJson(privateSnapshot.data);
        private.members[privateAggreDesignation] = invitedName;
        await trans2.set(privateSnapshot.reference, private.toJson());
        print('Updated the privates');
      }
    }, timeout: Duration(seconds: 20));
  }

  Future<void> makeTeamActive(String teamId) async {
    _firestore.runTransaction((tran) async {
      DocumentSnapshot fresh =
          await tran.get(_firestore.collection('team').document(teamId));
      if (fresh.exists) {
        Team team = Team.fromJson(fresh.data);
        team.teamIsActive = true;
        tran.set(fresh.reference, team.toJson());
      }
    });
  }

  Stream<QuerySnapshot> getOutstandingTeamInvitations(BuildContext context) {
    return _firestore
        .collection('team_invites')
        .where('invited_name', isEqualTo: Quanda.of(context).myUser.name)
        .orderBy('date_sent', descending: true)
        .snapshots();
  }

  Future<void> acceptTeamInvite(int indexOfinvite, BuildContext context) {
    TeamInvites team =
        Quanda.of(context).pendingTeamInvites.elementAt(indexOfinvite);
    SnackBarMessage('Accepting Invitation from ${team.team_id}', context);

    _firestore.runTransaction((tran) async {
      DocumentSnapshot freshSnapShot = await tran.get(_firestore
          .collection('team_invites')
          .document('${team.team_id}-${Quanda.of(context).myUser.name}'));
      if (freshSnapShot.exists) {
        TeamInvites freshInvite =
            await TeamInvites.fromJson(freshSnapShot.data);
        freshInvite.accepted = true;
        freshInvite.pending = false;
        var acceptedInvite =
            await tran.update(freshSnapShot.reference, freshInvite.toJson());
        _firestore.runTransaction((transactionUser) async {
          DocumentSnapshot freshUserSnap = await transactionUser.get(_firestore
              .collection('users')
              .document(Quanda.of(context).myUser.id));
          if (freshUserSnap.exists) {
            print('Adding team to user profile');
            User freshUser = User.fromJson(freshUserSnap.data);
            freshUser.team_id = Quanda.of(context)
                .pendingTeamInvites
                .elementAt(indexOfinvite)
                .team_name;
            await transactionUser.update(
                freshUserSnap.reference, freshUser.toJson());
            print('Accepting invitation');
          }
        });

        print('updating team info with accepted response');

        _firestore.runTransaction((myTeamAcceptanceTransaction) async {
          DocumentSnapshot freshTeamAccepted = await myTeamAcceptanceTransaction
              .get(_firestore.collection('team').document(freshInvite.team_id));
          if (freshTeamAccepted.exists) {
            print('Will let team know I accepted');
            Team acceptedTeam = Team.fromJson(freshTeamAccepted.data);
            if (acceptedTeam.memberOneName == Quanda.of(context).myUser.name) {
              acceptedTeam.invitationMemberOnePending = false;
              acceptedTeam.invitationMemberOneAccepted = true;
            }
            if (acceptedTeam.memberTwoName == Quanda.of(context).myUser.name) {
              acceptedTeam.invitationMemberTwoPending = false;
              acceptedTeam.invitationMemberTwoAccepted = true;
            }
            if (acceptedTeam.memberThreeName ==
                Quanda.of(context).myUser.name) {
              acceptedTeam.invitationMemberThreePending = false;
              acceptedTeam.invitationMemberThreeAccepted = true;
            }
            await myTeamAcceptanceTransaction.set(
                freshTeamAccepted.reference, acceptedTeam.toJson());
          }
        });

        print('Will decline all other pending invites');
        WriteBatch mybatch = _firestore.batch();
        Future<QuerySnapshot> myfutureQuery =
            getOutstandingTeamInvitations(context).first;
        myfutureQuery.then((onSnapshot) async {
          onSnapshot.documents.forEach((document) async {
            TeamInvites teamInvites = TeamInvites.fromJson(document.data);
            teamInvites.pending = false;
            if (teamInvites.team_id != team.team_id) {
              mybatch.setData(document.reference, teamInvites.toJson());
              await _firestore.runTransaction((transactionTeamDeny) async {
                DocumentSnapshot freshTeamSnapShot =
                    await transactionTeamDeny.get(_firestore
                        .collection('team')
                        .document(teamInvites.team_id));
                if (freshTeamSnapShot.exists) {
                  Team deniedTeam = Team.fromJson(freshTeamSnapShot.data);
                  if (deniedTeam.memberOneName ==
                      Quanda.of(context).myUser.name) {
                    deniedTeam.invitationMemberOnePending = false;
                    deniedTeam.invitationMemberOneAccepted = false;
                    mybatch.updateData(
                        _firestore
                            .collection('team')
                            .document(teamInvites.team_id)
                            .collection('private_data')
                            .document('private'),
                        {'${Private.memberid1}': ''});
                  }
                  if (deniedTeam.memberTwoName ==
                      Quanda.of(context).myUser.name) {
                    deniedTeam.invitationMemberTwoPending = false;
                    deniedTeam.invitationMemberTwoAccepted = false;
                    mybatch.updateData(
                        _firestore
                            .collection('team')
                            .document(teamInvites.team_id)
                            .collection('private_data')
                            .document('private'),
                        {'${Private.memberid2}': ''});
                  }
                  if (deniedTeam.memberThreeName ==
                      Quanda.of(context).myUser.name) {
                    deniedTeam.invitationMemberThreePending = false;
                    deniedTeam.invitationMemberThreeAccepted = false;
                    mybatch.updateData(
                        _firestore
                            .collection('team')
                            .document(teamInvites.team_id)
                            .collection('private_data')
                            .document('private'),
                        {'${Private.memberid3}': ''});
                  }

                  mybatch.updateData(
                      freshTeamSnapShot.reference, deniedTeam.toJson());
                }
              });
            }
          });
          mybatch.commit();
        });
      } else {
        SnackBarMessage('Sorry that invitation had an issue', context);
      }
    });
  }

  Future<void> deleteDenyMember(
      Team team, BuildContext context, int index) async {
    String member_to_delete;
    index == 1 ? member_to_delete = team.memberOneName : null;
    index == 2 ? member_to_delete = team.memberTwoName : null;
    index == 3 ? member_to_delete = team.memberThreeName : null;
    SnackBarMessage(
        'Will delete ${member_to_delete}, so you can add someone else',
        context);
    _firestore.runTransaction((deleteMeanyTran) async {
      DocumentSnapshot documentSnapshot = await deleteMeanyTran
          .get(_firestore.collection('team').document(team.team_name));
      if (documentSnapshot.exists) {
        Team freshteam = Team.fromJson(documentSnapshot.data);
        if (index == 1) {
          freshteam.memberOneName = "";
          freshteam.invitationMemberOnePending = false;
          freshteam.invitationMemberOneAccepted = false;
        }
        if (index == 2) {
          freshteam.memberTwoName = "";
          freshteam.invitationMemberTwoPending = false;
          freshteam.invitationMemberTwoAccepted = false;
        }
        if (index == 3) {
          freshteam.memberThreeName = "";
          freshteam.invitationMemberThreePending = false;
          freshteam.invitationMemberThreeAccepted = false;
        }

        deleteMeanyTran.set(documentSnapshot.reference, freshteam.toJson());
      }
    });
  }

  Future<Stream<DocumentSnapshot>> getUserData(BuildContext context) async {
    if (Quanda.of(context).myUser != null) {
      return await _firestore
          .collection('user_data')
          .document(Quanda.of(context).myUser.id)
          .snapshots();
    } else {
      print('Getting user id and updating quanda');
      await get_userprofile(await FireProvider.of(context).auth.currentUser())
          .listen((onData) {
        Quanda.of(context).myUser =
            User.fromJson(onData.documents.elementAt(0).data);
      });
      return _firestore
          .collection('user_data')
          .document(await FireProvider.of(context).auth.currentUser())
          .snapshots();
    }
  }

  Stream<QuerySnapshot> searchForBook(String book_name) {
    return _firestore
        .collection('book_master')
        .where('name', arrayContains: book_name)
        .snapshots();
  }

  @override
  Future<void> updateReadBooks(
      BuildContext context, List<Books> theBooks, void Function() onComplete) {
    _firestore.runTransaction((tran) async {
      DocumentSnapshot snapUserData = await tran.get(_firestore
          .collection('user_data')
          .document(Quanda.of(context).myUser.id));
      UserData userData = UserData.fromJson(snapUserData.data);
      userData.list_of_read_books = theBooks;
      tran.set(snapUserData.reference, userData.toJson());
    }, timeout: Duration(seconds: 50)).whenComplete(
      () {
        print('Updated UserData');
        onComplete();
      },
    ).catchError((e) {
      print('error after user_data fireBase Update: $e');
    });
    return null;
  }

  @override
  Stream<DocumentSnapshot> getPlayerRankingPoints(BuildContext context) {
    return _firestore
        .collection('player_rankings')
        .document(Quanda.of(context).myUser.id)
        .snapshots();
  }

  Future<void> buyItem(ItemsMaster item, BuildContext context) async {
    _firestore.runTransaction((tran) async {
      DocumentSnapshot playerRankingPoints = await tran.get(_firestore
          .collection('player_rankings')
          .document(Quanda.of(context).myUser.id));
      if (playerRankingPoints.exists) {
        //buy item
        print('Updating player points');
        PlayerPoints playerPoints =
            PlayerPoints.fromJson(playerRankingPoints.data);
        playerPoints.player_points = playerPoints.player_points - item.cost;
        Items purchasedItem =
            Items(item.id, 1, Quanda.of(context).myUser.id, null, false);
        purchasedItem.purchaseNow(Timestamp.now());
        //Todo cost: may want to make rankings the sole location for points
        print('updating player points in the user profile');
        tran.update(
            _firestore
                .collection('users')
                .document(Quanda.of(context).myUser.id),
            {'points': playerPoints.player_points});
        tran.set(playerRankingPoints.reference, playerPoints.toJson());
        tran.set(
            _firestore
                .collection('user_data')
                .document(Quanda.of(context).myUser.id)
                .collection('list_of_items')
                .document(),
            purchasedItem.toJson());
      }
    });
  }
}
