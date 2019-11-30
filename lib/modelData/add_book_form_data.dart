import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddBookFormData with ChangeNotifier {
  UserData _userData = UserData(List(), 'userid');
  List<Map<dynamic, dynamic>> answered_questions;
  List<int> _list_of_read_books;
  List<BooksMaster> _listOfMasterBooks;
  bool _masterListIsUpdating = true;
  String _authorName = "";
  String _bookName = "";
  String _ISN = "";

  //Getters
  get userData => _userData;
  get list_of_read_books => _list_of_read_books;
  get authorName => _authorName;
  get bookName => _bookName;
  get ISN => _ISN;
  get listOfMasterBooks => _listOfMasterBooks;
  get masterListIsUpdating => _masterListIsUpdating;

  set listOfMasterBooks(List<BooksMaster> new_listOfMasterBooks) {
    if (_listOfMasterBooks != new_listOfMasterBooks) {
      this._listOfMasterBooks = _listOfMasterBooks;
      notifyListeners();
    }
  }

  set masterListIsUpdating(bool newmasterListIsUpdating) {
    if (newmasterListIsUpdating != _masterListIsUpdating) {
      this._masterListIsUpdating = masterListIsUpdating;
      notifyListeners();
    }
  }

  set userData(UserData newUserData) {
    if (newUserData != _userData) {
      this._userData = newUserData;
      notifyListeners();
    }
  }

  set list_of_read_books(List<int> new_list_of_read_books) {
    if (_list_of_read_books != new_list_of_read_books) {
      this._list_of_read_books = _list_of_read_books;
      notifyListeners();
    }
  }

  set authorName(String newAuthorName) {
    if (authorName != newAuthorName) {
      this._authorName = newAuthorName;
      notifyListeners();
    }
  }

  set bookName(String newbookName) {
    if (authorName != newbookName) {
      this._bookName = newbookName;
      print(newbookName);
      notifyListeners();
    }
  }

  set ISN(String newISN) {
    if (ISN != newISN) {
      this._ISN = newISN;
      notifyListeners();
    }
  }

  Future<void> getUserData(BuildContext context) async {
    DocumentSnapshot userDataSnapShot = await FireProvider.of(context)
        .fireBase
        .getUserData(context)
        .forEach((data) {
      Quanda.of(context).userData = UserData.fromJson(data.data);
      this.userData = Quanda.of(context).userData;
    });
  }

  Future<void> getListOfMasterBooks(BuildContext context) async {
    QuerySnapshot querySnapshot =
        await FireProvider.of(context).fireBase.getMasterListofBooks().first;
    Quanda.of(context).listOfMasterBooks = querySnapshot.documents
        .toList()
        .map((item) => BooksMaster.fromJson(item.data))
        .toList();
    print('I searched for the book');
    masterListIsUpdating = false;
  }
}
