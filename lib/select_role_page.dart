import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/qanda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'constants.dart';
import 'data_type/text_formatted_body.dart';

class SelectRolePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SelectRoleState();
  }
}

class _SelectRoleState extends State<SelectRolePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          child:
          return Scaffold(
            appBar: AppBar(
              title: Text(Constants().select_your_role_page_title),
              bottom: TabBar(
                tabs: <Widget>[
                  new SvgPicture.asset(
                    Constants.myAvatars.elementAt(0).small_icon,
                    width: 50,
                    color: Constants.icon_Colors,
                  ),
                  new SvgPicture.asset(
                    Constants.myAvatars.elementAt(1).small_icon,
                    width: 50,
                    color: Constants.icon_Colors,
                  ),
                  new SvgPicture.asset(
                    Constants.myAvatars.elementAt(2).small_icon,
                    width: 50,
                    color: Constants.icon_Colors,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                myScrollableWindow(context, heroTab(0, context)),
                myScrollableWindow(context, heroTab(1, context)),
                myScrollableWindow(context, heroTab(2, context))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget heroTab(int location, BuildContext context) {
    final String contractText =
        Constants.myAvatars.elementAt(location).contract_button;
    final item_pressed = location + 1;
    return Column(
      children: <Widget>[
        Image(
          width: 300,
          image:
              AssetImage(Constants.myAvatars.elementAt(location).asset_Large),
        ),
        FlatButton(
          onPressed: () {
            /*   select_hero(DefaultTabController.of(context).index + 1);*/
            Quanda.of(context).myUser.role =
                DefaultTabController.of(context).index + 1;
            Provider.of(context).fireBase.setUpHero(
                Provider.of(context).auth.getLastUserLoged(),
                Quanda.of(context).myUser);
            print(
                'This is the index ${DefaultTabController.of(context).index}');
          },
          child: Row(
            children: <Widget>[Text('$contractText')],
          ),
        ),
        TextFormattedBody(Constants.myAvatars.elementAt(location).story),
      ],
    );
  }

  myScrollableWindow(BuildContext context, Widget heroTab) {}
}
