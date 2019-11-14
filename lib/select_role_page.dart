import 'package:bob_mobile/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:bob_mobile/widgets/text_formatted_body.dart';
import 'package:bob_mobile/widgets/scrollable_widget_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'constants.dart';

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
          height: 300,
          image:
              AssetImage(Constants.myAvatars.elementAt(location).asset_Large),
        ),
        RaisedButton(
          color: Constants.myAvatars.elementAt(location).color,
          onPressed: () {
            Quanda.of(context).myUser.role =
                DefaultTabController.of(context).index + 1;
            FireProvider.of(context).fireBase.setUpHero(
                FireProvider.of(context).auth.getLastUserLoged(),
                Quanda.of(context).myUser);
            print(
                'This is the index ${DefaultTabController.of(context).index}');
          },
          child: Center(
            child: TextFormattedLabelTwo('$contractText', 20, Colors.white),
          ),
        ),
        Container(
            height: 200,
            child: TextFormattedBody(
                Constants.myAvatars.elementAt(location).story)),
      ],
    );
  }
}
