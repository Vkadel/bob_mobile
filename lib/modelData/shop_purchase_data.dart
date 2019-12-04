import 'package:bob_mobile/data_type/items_master.dart';
import 'package:bob_mobile/data_type/player_points.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/modelData/qanda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ShopPurchaseData with ChangeNotifier {
  bool _shopHasItemsForSale = true;
  PlayerPoints _playerPoints;
  List<ItemsMaster> _itemsMasters = List();
  bool updateItemsMasters = true;
  ShopPurchaseData();

  bool get shopHasItemsForSale => shopHasItemsForSale;
  PlayerPoints get playerPoints => _playerPoints;
  List<ItemsMaster> get itemsMasters => _itemsMasters;

  void initOnline(BuildContext context) async {
    if (_playerPoints == null) {
      FireProvider.of(context)
          .fireBase
          .getPlayerRankingPoints(context)
          .listen((onData) {
        playerPointsTransform(onData);
      });
    }
    if (updateItemsMasters ||
        itemsMasters == null ||
        itemsMasters.length == 0) {
      FireProvider.of(context)
          .fireBase
          .getMasterListOfItems(context)
          .listen((OnData) {
        List<ItemsMaster> tranList = OnData.documents
            .toList()
            .map((item) => transformItem(item))
            .toList();
        updateitemsMasters(tranList, context);
      });
      updateItemsMasters = false;
    }
  }

  ItemsMaster transformItem(item) {
    print('Transforming item: ${ItemsMaster.fromJson(item.data).name}');
    return ItemsMaster.fromJson(item.data);
  }

  PlayerPoints playerPointsTransform(DocumentSnapshot onData) {
    print('Updating player online');
    updatePlayerPoints(PlayerPoints.fromJson(onData.data));
  }

  set shopHasItemsForSale(bool newshopHasItemsForSale) {
    if (newshopHasItemsForSale != _shopHasItemsForSale) {
      this._shopHasItemsForSale = newshopHasItemsForSale;
      notifyListeners();
    }
  }

  set playerPoints(PlayerPoints newplayerPoints) {
    if (newplayerPoints != _playerPoints) {
      this._playerPoints = newplayerPoints;
      notifyListeners();
    }
  }

  set itemsMasters(List<ItemsMaster> newitemsMasters) {
    if (newitemsMasters != _itemsMasters) {
      this._itemsMasters = newitemsMasters;
      notifyListeners();
    }
  }

  void updateitemsMasters(
      List<ItemsMaster> newitemsMasters, BuildContext context) {
    if (newitemsMasters != _itemsMasters) {
      this._itemsMasters = newitemsMasters;
      Quanda.of(context).masterListOfItems = newitemsMasters;
      notifyListeners();
    }
  }

  void updatePlayerPoints(PlayerPoints newplayerPoints) {
    if (newplayerPoints != _playerPoints) {
      this._playerPoints = newplayerPoints;
      notifyListeners();
    }
  }

  void buyItem(ItemsMaster item, BuildContext context) {
    FireProvider.of(context).fireBase.buyItem(item, context);
  }
}
