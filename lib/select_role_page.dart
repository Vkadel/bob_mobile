import 'package:bob_mobile/data_type/user.dart';
import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/validators.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:bob_mobile/widgets/text_formatted_body.dart';
import 'package:bob_mobile/widgets/scrollable_widget_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'constants.dart';
import 'data_type/player_points.dart';

class SelectRolePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SelectRoleState();
  }
}

class _SelectRoleState extends State<SelectRolePage> {
  String _player_name;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireProvider.of(context).fireBase.getPlayerRankings(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active &&
            !snapshot.hasError) {
          List<PlayerPoints> playerRankings = snapshot.data.documents
              .map((item) => PlayerPoints.fromJson(item.data))
              .toList();
          Quanda.of(context).playerRankings = playerRankings;
          return DefaultTabController(
            length: 3,
            child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(Constants().select_your_role_page_title),
                    bottom: TabBar(
                      tabs: <Widget>[
                        Tab(
                          icon: new SvgPicture.asset(
                            Constants.myAvatars.elementAt(0).small_icon,
                            width: 50,
                            color: Constants.icon_Colors,
                          ),
                        ),
                        Tab(
                          icon: new SvgPicture.asset(
                            Constants.myAvatars.elementAt(1).small_icon,
                            width: 50,
                            color: Constants.icon_Colors,
                          ),
                        ),
                        Tab(
                          icon: new SvgPicture.asset(
                            Constants.myAvatars.elementAt(2).small_icon,
                            width: 50,
                            color: Constants.icon_Colors,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    dragStartBehavior: DragStartBehavior.start,
                    children: <Widget>[
                      myScrollableWindow(context, heroTab(0)),
                      myScrollableWindow(context, heroTab(1)),
                      myScrollableWindow(context, heroTab(2))
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}

class heroTab extends StatelessWidget {
  const heroTab(
    @required this.location, {
    Key key,
  }) : super(key: key);
  final int location;
  @override
  Widget build(BuildContext context) {
    final String contractText =
        Constants.myAvatars.elementAt(location).contract_button;
    final _playerNameformKey = new GlobalKey<FormState>();
    String userName;
    final item_pressed = location + 1;
    final NameValidator myValidator = NameValidator(context);
    return Column(
      children: <Widget>[
        Image(
          height: MediaQuery.of(context).size.height / 2.5,
          image:
              AssetImage(Constants.myAvatars.elementAt(location).asset_Large),
        ),
        RaisedButton(
          color: Constants.myAvatars.elementAt(location).color,
          onPressed: () async {
            print('Checking user name is ok');
            bool nameDoesNotExist;
            Quanda.of(context).myUser.role =
                DefaultTabController.of(context).index + 1;
            Quanda.of(context).myUser.name = userName;
            if (_playerNameformKey.currentState.validate()) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: <Widget>[
                    Text('Creating Hero'),
                    CircularProgressIndicator()
                  ],
                ),
                backgroundColor: ColorLogicbyPersonality(context),
              ));
              nameDoesNotExist =
                  await myValidator.checkNameIsNotUsed(userName, context);
            } else {
              String mesage;
              nameDoesNotExist
                  ? mesage = Constants.name_exist
                  : mesage = mesage;
              !_playerNameformKey.currentState.validate()
                  ? mesage = Constants.name_cannot_be_empty
                  : mesage = mesage;
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(mesage),
                backgroundColor: ColorLogicbyPersonality(context),
              ));
            }
          },
          child: Center(
            child: TextFormattedLabelTwo('$contractText', 20, Colors.white),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height / 4,
            child: TextFormattedBody(
                Constants.myAvatars.elementAt(location).story)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Form(
            key: _playerNameformKey,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: Constants.hint_text_for_hero_name,
                  icon: SvgPicture.asset(
                    Constants.myAvatars.elementAt(location).small_icon,
                    height: 45,
                    color: Theme.of(context).primaryColor,
                  )),
              textAlign: TextAlign.center,
              validator: myValidator.validate,
              maxLengthEnforced: true,
              maxLength: 25,
              cursorColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                userName = value.trim();
              },
            ),
          ),
        )
      ],
    );
  }
}
