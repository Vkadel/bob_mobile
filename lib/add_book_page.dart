import 'dart:ui';

import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/helpers/not_null_not_empty.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/loading_indicator_message.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'modelData/add_book_form_data.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({Key key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          _buildHeader(),
          _buildList(),
        ],
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
              Stack(
                children: <Widget>[
                  Image.network(
                    '${Quanda.of(context).listOfMasterBooks.elementAt(index).online_picture_link}',
                    width: (MediaQuery.of(context).size.width - 20) / 3,
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.width - 20) / 3,
                    color: Color.fromRGBO(10, 10, 10, 50),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
