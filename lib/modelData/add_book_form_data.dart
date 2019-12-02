import 'package:bob_mobile/data_type/books.dart';
import 'package:bob_mobile/data_type/books_master.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddBookFormData with ChangeNotifier {
  UserData _userData = UserData(List(), 'userid');
  List<Map<dynamic, dynamic>> answered_questions = List();
  List<Books> _list_of_read_books = List();
  List<BooksMaster> _listOfMasterBooks;
  bool _masterListIsUpdating = true;
  bool _elementChanged = false;
  bool _formChanged = false;
  bool _savingProgress = false;
  int _indexOfChanged;

  //May need later for sorting search as list grows
  /* String _authorName = "";
  String _bookName = "";
  String _ISN = "";*/

  //Getters
  UserData get userData => _userData;
  List<Books> get list_of_read_books => _list_of_read_books;
  List<BooksMaster> get listOfMasterBooks => _listOfMasterBooks;
  bool get masterListIsUpdating => _masterListIsUpdating;
  bool get elementChanged => _elementChanged;
  int get indexOfChanged => _indexOfChanged;
  bool get formChanged => _formChanged;
  bool get savingProgress => _savingProgress;

  /*  String get authorName => _authorName;
  String get bookName => _bookName;
  String get ISN => _ISN;*/

  void initDataOnline(BuildContext context) async {
    FireProvider.of(context)
        .fireBase
        .getMasterListofBooks()
        .listen((onData) => _tryUpdateMasters(onData, context));
    var userDataSnap =
        await FireProvider.of(context).fireBase.getUserData(context).first;
    userData = UserData.fromJson(userDataSnap.data);
    list_of_read_books = userData.list_of_read_books;
    Quanda.of(context).userData = userData;
    masterListIsUpdating = false;
  }

  BooksMaster itemConversion(DocumentSnapshot item) {
    BooksMaster returnable;
    returnable = BooksMaster.fromJson(item.data);
    print('Converting Item ${item.reference} : ${returnable.name}');
    return returnable;
  }

  void _tryUpdateMasters(QuerySnapshot onData, BuildContext context) {
    if (onData.documents != null && onData.documents.length > 0) {
      List<BooksMaster> tranList;
      tranList = onData.documents
          .toList()
          .map((item) => itemConversion(item))
          .toList();
      listOfMasterBooks = tranList;
      Quanda.of(context).listOfMasterBooks = tranList;
    } else {
      SnackBarMessage('Not able to retrieve the main list of books', context);
    }
  }

  set formChanged(bool newformChanged) {
    if (_formChanged != newformChanged) {
      this._formChanged = newformChanged;
    }
  }

  set elementChanged(bool newElementChanged) {
    if (_elementChanged != newElementChanged) {
      this._elementChanged = newElementChanged;
    }
  }

  set indexOfChanged(int newindexOfChanged) {
    if (_elementChanged != newindexOfChanged) {
      this._indexOfChanged = newindexOfChanged;
    }
  }

  set savingProgress(bool newsavingProgress) {
    if (_savingProgress != newsavingProgress) {
      this._savingProgress = newsavingProgress;
      notifyListeners();
    }
  }

  void elementHasChanged(int indexChanged, bool hasChanged) {
    indexOfChanged = indexChanged;
    elementChanged = hasChanged;
    notifyListeners();
  }

  set listOfMasterBooks(List<BooksMaster> new_listOfMasterBooks) {
    if (_listOfMasterBooks != new_listOfMasterBooks) {
      this._listOfMasterBooks = new_listOfMasterBooks;
      notifyListeners();
    }
  }

  set masterListIsUpdating(bool newmasterListIsUpdating) {
    if (newmasterListIsUpdating != _masterListIsUpdating) {
      this._masterListIsUpdating = newmasterListIsUpdating;
      notifyListeners();
    }
  }

  set userData(UserData newUserData) {
    if (newUserData != _userData) {
      this._userData = newUserData;
      notifyListeners();
    }
  }

  set list_of_read_books(List<Books> new_list_of_read_books) {
    if (_list_of_read_books != new_list_of_read_books) {
      this._list_of_read_books = new_list_of_read_books;
    }
  }

  void syncReadList(List<Books> new_list_of_read_books, BuildContext context) {
    if (_list_of_read_books != new_list_of_read_books) {
      this._list_of_read_books = new_list_of_read_books;
      notifyListeners();
    }
  }

  /*set authorName(String newAuthorName) {
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
  }*/

  Future<void> getUserData(BuildContext context) async {
    DocumentSnapshot userDataSnapShot = await FireProvider.of(context)
        .fireBase
        .getUserData(context)
        .forEach((data) {
      this.userData = Quanda.of(context).userData;
    });
  }
}
