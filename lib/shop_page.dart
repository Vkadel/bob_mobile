import 'package:bob_mobile/data_type/items.dart';
import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/helpers/constants.dart';
import 'package:bob_mobile/helpers/snack_bar_message.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/shop_purchase_data.dart';
import 'package:bob_mobile/widgets/color_logic_backs_personality.dart';
import 'package:bob_mobile/widgets/loading_indicator_message.dart';
import 'package:bob_mobile/widgets/text_formated_raking_label_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modelData/qanda.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    print('getting items master');
    //Todo: May want to condition this refresh
    Provider.of<ShopPurchaseData>(context, listen: true).initOnline(context);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextFormattedLabelTwo(
                    'Shop',
                  ),
                  TextFormattedLabelTwo(
                    'Points available: ${Provider.of<ShopPurchaseData>(context, listen: true).playerPoints.player_points}',
                  )
                ],
              ),
              flexibleSpace: Image.asset(Constants.myAvatars
                  .elementAt(Quanda.of(context).myUser.role - 1)
                  .asset_Large),
              expandedHeight: Constants.height_extended_bars,
            ),
            Provider.of<ShopPurchaseData>(context, listen: true)
                        .itemsMasters
                        .length ==
                    0
                ? SliverToBoxAdapter(
                    child: Center(
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      child:
                          Provider.of<ShopPurchaseData>(context, listen: true)
                                  .updateItemsMasters
                              ? LoadingIndicatorMessage(
                                  message: "Getting items...",
                                )
                              : _buildNoItemsForSale(),
                    ),
                  ))
                : _buildListOfMasterItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildListOfMasterItems(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return _buildShopListItem(index);
      },
          childCount: Provider.of<ShopPurchaseData>(context, listen: true)
              .itemsMasters
              .length),
    );
  }

  _buildNoItemsForSale() {
    return Builder(
      builder: (BuildContext context) {
        //Todo: May want to add a closed shop picture or animation
        return TextFormattedLabelTwo(
            'Sorry we do not have any items for sale right now',
            MediaQuery.of(context).size.width / 5,
            Future.value(Colors.black),
            null,
            TextAlign.justify);
      },
    );
  }

  _buildShopListItem(int index) {
    double fontSize = MediaQuery.of(context).size.width / 20;
    return Builder(
      builder: (BuildContext context) {
        ItemsMaster item = Provider.of<ShopPurchaseData>(context, listen: true)
            .itemsMasters
            .elementAt(index);
        return FutureBuilder<Object>(
            future: ColorLogicbyPersonality(context),
            builder: (context, snapshotColor) {
              return Card(
                shape: RoundedRectangleBorder(),
                color: snapshotColor.data,
                child: ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextFormattedLabelTwo(item.name, fontSize * 1.15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                ///Cost
                                itemCostPoints(fontSize: fontSize, item: item),

                                ///Duration
                                itemBuffDuration(fontSize: fontSize, item: item)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Bonuses
                      itemBonuses(fontSize: fontSize, item: item),
                      //Button for purchase
                      buttonForItemPurchase(item)
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  @override
  void didChangeDependencies() {}
}

class itemCostPoints extends StatelessWidget {
  const itemCostPoints({
    Key key,
    @required this.fontSize,
    @required this.item,
  }) : super(key: key);

  final double fontSize;
  final ItemsMaster item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextFormattedLabelTwo('Cost', fontSize / 2),
        TextFormattedLabelTwo(' ${item.cost} ', fontSize),
        TextFormattedLabelTwo('points', fontSize / 2),
      ],
    );
  }
}

class itemBuffDuration extends StatelessWidget {
  const itemBuffDuration({
    Key key,
    @required this.fontSize,
    @required this.item,
  }) : super(key: key);

  final double fontSize;
  final ItemsMaster item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextFormattedLabelTwo('duration:', fontSize / 2),
        TextFormattedLabelTwo(' ${item.duration_days} ', fontSize),
        item.duration_days > 1
            ? TextFormattedLabelTwo('days', fontSize / 2)
            : TextFormattedLabelTwo('day', fontSize / 2),
      ],
    );
  }
}

class itemBonuses extends StatelessWidget {
  const itemBonuses({
    Key key,
    @required this.fontSize,
    @required this.item,
  }) : super(key: key);

  final double fontSize;
  final ItemsMaster item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (2 / 3),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormattedLabelTwo(
              'Bonuses', fontSize * 1.1, null, null, TextAlign.left),
          TextFormattedLabelTwo('+ ${item.addition} ${Constants.buff_gain}',
              fontSize / 1.4, null, null, TextAlign.start),
          TextFormattedLabelTwo('- ${item.subtraction} ${Constants.buff_loss}',
              fontSize / 1.4, null, null, TextAlign.start)
        ],
      ),
    );
  }
}

class buttonForItemPurchase extends StatelessWidget {
  final ItemsMaster item;
  const buttonForItemPurchase(
    this.item, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width / 5,
      child: FlatButton.icon(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            buyItem(context, item);
          },
          icon: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
          label: Text(
            "buy",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

void buyItem(BuildContext context, ItemsMaster item) {
  print("I'm buying this item");
  Provider.of<ShopPurchaseData>(context, listen: false)
              .playerPoints
              .player_points >
          item.cost
      ? Provider.of<ShopPurchaseData>(context, listen: false)
          .buyItem(item, context)
      : SnackBarMessage(
          'Your point balance needs to be greater than the cost of the item',
          context);
}
