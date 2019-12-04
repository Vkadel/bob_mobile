import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/widgets/loading_indicator_message.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    int playerPointsAvailable;
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream:
                  FireProvider.of(context).fireBase.getPlayerRanking(context),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  PlayerPoints playerPoints =
                      PlayerPoints.fromJson(snapshot.data.documents.first.data);
                  return SliverAppBar(
                    title: Row(
                      children: <Widget>[
                        TextFormattedLabelTwo(
                          'Shop',
                        ),
                        TextFormattedLabelTwo(
                            'Points available: ${playerPoints.player_points}'),
                      ],
                    ),
                    expandedHeight: Constants.height_extended_bars,
                  );
                } else {
                  return LoadingIndicatorMessage(
                      message: 'Loading player available points..');
                }
              }),
          StreamBuilder<QuerySnapshot>(
              stream: null,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  print('Load master items');
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {}),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return LoadingIndicatorMessage(
                        message: 'Loading Items for purchase');
                }
              }),
        ],
      ),
    );
  }
}
