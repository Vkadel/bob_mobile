import 'package:bob_mobile/widgets/color_logic_backs_role.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:flutter/material.dart';

class AddMoreBooksReadTab extends StatelessWidget {
  const AddMoreBooksReadTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: ColorLogicbyRole(context),
        builder: (context, snapshot) {
          return Container(
            color: snapshot.data,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormattedLabelTwo(
                        'Add some books you have read into your library',
                        MediaQuery.of(context).size.width / 20,
                        null,
                        null,
                        TextAlign.center),
                    FlatButton.icon(
                        shape: Border.all(color: Colors.white, width: 2),
                        onPressed: () {
                          print('I will launch add book screen');
                          Navigator.of(context).pushNamed('/add_read_book');
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: TextFormattedLabelTwo(
                            'Add Read Books',
                            MediaQuery.of(context).size.width / 20,
                            null,
                            null,
                            TextAlign.center)),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
