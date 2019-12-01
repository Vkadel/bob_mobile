import 'dart:ui';

import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/data_type/user_data.dart';
import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
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
import 'modelData/add_book_form_data.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({Key key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            _buildHeader(),
            _buildList(),
          ],
          //Todo: Update User Data Online
        ),floatingActionButton: FloatingActionButton.extended(onPressed: (){print('Will save changes online');}, label: Text('Save changes online')),
      ),
    );
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
        return _buildListOfBooks();
      } else {
        Provider.of<AddBookFormData>(context, listen: false)
            .getListOfMasterBooks(context);
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
              Quanda.of(context).listOfMasterBooks != null) {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildBookTile(index);
              }, childCount: Quanda.of(context).listOfMasterBooks.length),
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
      double titleFontSize = MediaQuery.of(context).size.width / 18;
      Quanda.of(context).listOfMasterBooks.elementAt(index).name.length > 17
          ? titleFontSize = titleFontSize / 1.5
          : null;
      Quanda.of(context).listOfMasterBooks.elementAt(index).name.length > 30
          ? titleFontSize = (titleFontSize * 1.5) / 1.6
          : null;
      Quanda.of(context).listOfMasterBooks.elementAt(index).name.length > 47
          ? titleFontSize = (titleFontSize * 1.6) / 1.65
          : null;
      double titleFont = MediaQuery.of(context).size.width / 25;
      if (Quanda.of(context).listOfMasterBooks.elementAt(index).by.length >
          17) {
        titleFont = MediaQuery.of(context).size.width / 30;
      }

      return ListTile(
        title: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: TextFormattedLabelTwo(
                    Quanda.of(context).listOfMasterBooks.elementAt(index).name,
                    titleFontSize,
                    ColorLogicbyRole(context),
                    null,
                    TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                child: TextFormattedLabelTwo(
                    'by ${Quanda.of(context).listOfMasterBooks.elementAt(index).by} ',
                    titleFont,
                    ColorLogicbyRole(context),
                    null,
                    TextAlign.center),
              ),
              FlatButton(onPressed: ()async{
                //Check status of current item
                int indexPressedInMaster=Quanda.of(context).listOfMasterBooks.elementAt(index).id;
                print('the book selected was: ${Quanda.of(context).listOfMasterBooks.elementAt(index).name}');
                //check if list of readbooks is null
                if(Quanda.of(context).userData==null || Quanda.of(context).userData.list_of_read_books==null){
                  var snap =await FireProvider.of(context).fireBase.getUserData(context).first;
                  Quanda.of(context).userData=UserData.fromJson(snap.data);
                  //Todo: check that the user_data has been consulted online before this, otherwise call it
                  addReadBookToQuandaFirstTime(context, indexPressedInMaster);
                  print('User has not read any books');
                } else{
                  // ignore: unrelated_type_equality_checks
                  int indexOnReadBooks=Quanda.of(context).
                  userData.list_of_read_books.indexWhere(
                          (book)=>book.bookId==indexPressedInMaster);
                 if(indexOnReadBooks==-1){
                   print('Book has not beed added');
                   addReadBookToQuandaFirstTime(context, indexPressedInMaster);
                 }else{
                   print('The book is in the level will be updated');
                   print('the pressed book id is:$indexOnReadBooks');
                   int status=Quanda.of(context).userData.list_of_read_books.elementAt(indexOnReadBooks).status;
                   print('status was $status');
                   (status==0||status==1)?
                   status=status+1:
                   status=0;
                   Quanda.of(context).userData.list_of_read_books.elementAt(indexOnReadBooks).status=status;
                   print('status is: $status');
                 }
                }
              },
                child: Stack(
                children: <Widget>[
                  Container(
                    height: (MediaQuery.of(context).size.width - 20) / 3,
                    child: FlareActor(
                      "assets/anim/book_progress_anim.flr",
                      alignment: Alignment.center,
                      animation: "100-66",
                      fit: BoxFit.fill,
                      callback: (String name){
                        print('$name finished');
                      },
                    ),
                  ),
                  Image.network(
                    '${Quanda.of(context).listOfMasterBooks.elementAt(index).online_picture_link}',
                    height: (MediaQuery.of(context).size.width - 20) / 2,
                    width: (MediaQuery.of(context).size.width - 20) / 3,
                  ),
                ],
              ),),
            ],
          ),
        ),
      );
    },
  );
}

void addReadBookToQuandaFirstTime(BuildContext context, int indexPressedInMaster) {
   Books bookRead=Books(Quanda.of(context).myUser.id,0,indexPressedInMaster);
  Quanda.of(context).userData.list_of_read_books.add(bookRead);
}

class mAnimController with FlareController{
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    // TODO: implement advance
    return null;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    // TODO: implement initialize
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // TODO: implement setViewTransform
  }
}