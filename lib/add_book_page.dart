import 'dart:ui';

import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/loading_indicator_message.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'data_type/books.dart';
import 'helpers/status_to_string.dart';
import 'modelData/add_book_form_data.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({Key key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<AddBookFormData>(context, listen: false)
                .listOfMasterBooks ==
            null ||
        Provider.of<AddBookFormData>(context, listen: false)
                .list_of_read_books ==
            null) {
      Provider.of<AddBookFormData>(context, listen: false)
          .initDataOnline(context);
    }

    return WillPopScope(
      onWillPop: mOnWillPop,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              _buildHeader(),
              _buildList(),
              SliverToBoxAdapter(
                child: Container(height: _widthForBookPic(context)),
              ),
            ],
            //Todo: Update User Data Online
          ),
          floatingActionButton:
              Provider.of<AddBookFormData>(context, listen: true).formChanged
                  ? Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          onPressed: () {
                            print('Will save changes online');
                            FireProvider.of(context).fireBase.updateReadBooks(
                                context,
                                Provider.of<AddBookFormData>(context,
                                        listen: false)
                                    .list_of_read_books,
                                updateModifyFlags);
                            Provider.of<AddBookFormData>(context, listen: false)
                                .savingProgress = true;
                          },
                          label: Text('Save changes online '),
                        ),
                        Provider.of<AddBookFormData>(context, listen: true)
                                .savingProgress
                            ? CircularProgressIndicator()
                            : Container(),
                      ],
                    )
                  : Container(),
        ),
      ),
    );
  }

  Future<bool> mOnWillPop() {
    if (Provider.of<AddBookFormData>(context, listen: false).formChanged) {
      return showDialog<bool>(
        context: this.context,
        builder: (context) => FutureBuilder<Object>(
            future: ColorLogicbyPersonality(context),
            builder: (context, color) {
              return AlertDialog(
                title: Text(
                    'Do you want to leave your library without saving? If so all your changes will be lost'),
                actions: <Widget>[
                  FlatButton(
                    shape: CircleBorder(side: BorderSide(color: color.data)),
                    child: Text(
                      'stay',
                      style: TextStyle(color: color.data),
                    ),
                    onPressed: () => {Navigator.pop(context, false)},
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: color.data)),
                    child: Text(
                      'leave',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: okToLeave,
                  ),
                ],
              );
            }),
        barrierDismissible: false,
      );
    }
    Navigator.pop(context, true);
  }

  void okToLeave() {
    Provider.of<AddBookFormData>(context, listen: false)
        .initDataOnline(context);
    Navigator.pop(context, true);
  }

  void updateModifyFlags() {
    Provider.of<AddBookFormData>(context, listen: false).savingProgress = false;
    Provider.of<AddBookFormData>(context, listen: false).formChanged = false;
  }
}

Widget _buildHeader() {
  return Builder(
    builder: (context) {
      return SliverAppBar(
        title: TextFormattedLabelTwo('Tap to make books active'),
        expandedHeight: Constants.height_extended_bars,
      );
    },
  );
}

Widget _buildList() {
  return Builder(
    builder: (BuildContext context) {
      if (Quanda.of(context).listOfMasterBooks != null ||
          !Provider.of<AddBookFormData>(context, listen: true)
              .masterListIsUpdating) {
        Provider.of<AddBookFormData>(context, listen: false).listOfMasterBooks =
            Quanda.of(context).listOfMasterBooks;
        return _buildListOfBooks();
      } else {
        print('Getting List of Master Books online');
        return SliverToBoxAdapter(
          child: LoadingIndicatorMessage(
            message: 'Loading Books',
          ),
        );
      }
    },
  );
}

Widget _buildListOfBooks() {
  return Builder(
    builder: (BuildContext context) {
      return Consumer<AddBookFormData>(
        builder: (BuildContext context, AddBookFormData value, _) {
          if (!value.masterListIsUpdating ||
              Provider.of<AddBookFormData>(context, listen: false)
                      .listOfMasterBooks !=
                  null) {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildBookTile(index);
              },
                  childCount:
                      Provider.of<AddBookFormData>(context, listen: false)
                          .listOfMasterBooks
                          .length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.6),
            );
          } else {
            return SliverToBoxAdapter(
              child: LoadingIndicatorMessage(
                message: 'Loading List of Books ',
              ),
            );
          }
        },
      );
    },
  );
}

Widget _buildBookTile(int index) {
  return Builder(
    builder: (BuildContext context) {
      var masterBookList = Provider.of<AddBookFormData>(context, listen: false)
          .listOfMasterBooks;
      if (masterBookList == null) {
        print('Master list is not ready it will send and empty container');
        return Container();
      } else {
        print('MasterList of books is ready');
        double titleFontSize = MediaQuery.of(context).size.width / 18;
        masterBookList.elementAt(index).name.length > 15
            ? titleFontSize = titleFontSize / 1.5
            : null;
        masterBookList.elementAt(index).name.length > 30
            ? titleFontSize = (titleFontSize * 1.5) / 1.6
            : null;
        masterBookList.elementAt(index).name.length > 47
            ? titleFontSize = (titleFontSize * 1.6) / 1.65
            : null;
        double titleFont = MediaQuery.of(context).size.width / 25;
        if (masterBookList.elementAt(index).by.length > 17) {
          titleFont = MediaQuery.of(context).size.width / 30;
        }
        return ListTile(
          title: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                      child: TextFormattedLabelTwo(
                          masterBookList.elementAt(index).name,
                          titleFontSize,
                          ColorLogicbyRole(context),
                          null,
                          TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      child: TextFormattedLabelTwo(
                          'by ${masterBookList.elementAt(index).by} ',
                          titleFont,
                          ColorLogicbyRole(context),
                          null,
                          TextAlign.center),
                    ),
                  ],
                ),
                FlatButton(
                  onPressed: () async {
                    Provider.of<AddBookFormData>(context, listen: false)
                        .formChanged = true;
                    int bookId = bookIdNumberInMaster(index, context);
                    print(
                        'the book selected was: ${Provider.of<AddBookFormData>(context, listen: false).listOfMasterBooks.elementAt(index).name}');
                    //check if list of readbooks is null
                    if (Provider.of<AddBookFormData>(context, listen: false)
                                .userData ==
                            null ||
                        Provider.of<AddBookFormData>(context, listen: false)
                                .userData
                                .list_of_read_books ==
                            null) {
                      print('User has not read any books');
                      await Provider.of<AddBookFormData>(context, listen: false)
                          .initDataOnline(context);
                      addReadBookToQuandaFirstTime(context, bookId);
                    } else {
                      // ignore: unrelated_type_equality_checks
                      int indexOnReadBooks =
                          getPositionInReadBooks(bookId, context);
                      if (indexOnReadBooks == -1) {
                        print('Book has not beed added');
                        addReadBookToQuandaFirstTime(context, bookId);
                      } else {
                        _increaseStatus(indexOnReadBooks, context);
                      }
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        '${Provider.of<AddBookFormData>(context, listen: false).listOfMasterBooks.elementAt(index).online_picture_link}',
                        height: _heighForBookPic(context),
                        width: _widthForBookPic(context),
                      ),
                      Consumer<AddBookFormData>(builder: (context, data, _) {
                        String animation = '';
                        String status = "";
                        var readBook;
                        int indexInReadBooks = getPositionInReadBooks(
                            bookIdNumberInMaster(index, context), context);
                        if (indexInReadBooks != -1) {
                          print('position $indexInReadBooks');
                          List<Books> listOfRead = data.list_of_read_books;
                          readBook = listOfRead.elementAt(indexInReadBooks);
                          animation =
                              getAnimationId(data, indexInReadBooks, readBook);
                          status = StatusToString(readBook).getStatus();
                        } else {
                          animation = '100';
                        }
                        return Column(
                          children: <Widget>[
                            Container(
                              height: _heighForBookPic(context),
                              width: _widthForBookPic(context),
                              child: FlareActor(
                                "assets/anim/book_progress_anim.flr",
                                alignment: Alignment.center,
                                animation: animation,
                                fit: BoxFit.cover,
                                callback: (String name) {
                                  print('$name finished for item $index');
                                },
                              ),
                            ),
                            TextFormattedLabelTwo(
                                status,
                                titleFontSize - 5,
                                ColorLogicbyRole(context),
                                null,
                                TextAlign.center)
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}

double _heighForBookPic(BuildContext context) {
  return ((MediaQuery.of(context).size.width - 20) / 2);
}

double _widthForBookPic(BuildContext context) {
  return ((MediaQuery.of(context).size.width - 20) / 3);
}

void _increaseStatus(int indexOnReadBooks, BuildContext context) {
  print('The book is in the level will be updated');
  print('the pressed book id is:$indexOnReadBooks');
  int status;
  var listOfReadBooks =
      Provider.of<AddBookFormData>(context, listen: false).list_of_read_books;
  status = listOfReadBooks.elementAt(indexOnReadBooks).status;
  print('status was $status');
  (status == 0 || status == 1 || status == 2)
      ? status = status + 1
      : status = 0;
  listOfReadBooks.elementAt(indexOnReadBooks).status = status;
  Provider.of<AddBookFormData>(context, listen: false)
      .elementHasChanged(indexOnReadBooks, true);
  Provider.of<AddBookFormData>(context, listen: false)
      .syncReadList(listOfReadBooks, context);
  print('status is: $status');
}

void addReadBookToQuandaFirstTime(
    BuildContext context, int indexPressedInMaster) {
  Books bookRead = Books(Quanda.of(context).myUser.id, 1, indexPressedInMaster);
  List<Books> tranList =
      Provider.of<AddBookFormData>(context, listen: false).list_of_read_books;
  tranList.add(bookRead);
  Provider.of<AddBookFormData>(context, listen: false)
      .syncReadList(tranList, context);
  Provider.of<AddBookFormData>(context, listen: false)
      .elementHasChanged(tranList.length - 1, true);
}

int getPositionInReadBooks(int masterBookIndex, BuildContext context) {
  int index = -1;
  try {
    index = Provider.of<AddBookFormData>(context, listen: false)
        .list_of_read_books
        .indexWhere((book) => book.bookId == masterBookIndex);
  } catch (e) {
    print(e);
  }
  return index;
}

String getAnimationId(data, indexInReadBooks, Books readBook) {
  final String anim0to33percent = '100-66';
  final String anim33to66percent = '66-33';
  final String anim66to100percent = '33-0';
  final String anim100to0percent = '0-100';
  final String idle100percent = '100';
  final String idle66percent = '66';
  final String idle33percent = '33';
  final String idle0percent = '0';
  String animation;
  print('Will find animation for readbook: ${readBook.bookId}');
  if (data.elementChanged) {
    //an element changed check if it's this one
    if (data.indexOfChanged == indexInReadBooks) {
      data.elementChanged = false;
      //This is the item that changed
      if (readBook.status == 0) {
        animation = anim100to0percent;
      }
      if (readBook.status == 1) {
        animation = anim0to33percent;
      }
      if (readBook.status == 2) {
        animation = anim33to66percent;
      }
      if (readBook.status == 3) {
        animation = anim66to100percent;
      }
    }
  } else {
    //This is not the item that changed
    if (readBook.status == 0) {
      animation = idle100percent;
    }
    if (readBook.status == 1) {
      animation = idle66percent;
    }
    if (readBook.status == 2) {
      animation = idle33percent;
    }
    if (readBook.status == 3) {
      animation = idle0percent;
    }
  }
  return animation;
}

int bookIdNumberInMaster(int index, BuildContext context) {
  return Provider.of<AddBookFormData>(context)
      .listOfMasterBooks
      .elementAt(index)
      .id;
}
