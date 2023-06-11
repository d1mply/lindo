import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';

class MarketController extends GetxController {
  List<String> productIds = [
    "gold_50",
    "gold_200",
    "gold_500",
    "gold_1000",
    "gold_2000",
    "gold_5000",
  ];
  List<String> subProductIds = ["1", "2"];
  @override
  void onInit() {
    initMarket();
    super.onInit();
  }

  late StreamSubscription _conectionSubscription;
  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  initMarket() async {
    await FlutterInappPurchase.instance.initialize();

    getSubs();
    getItems();
    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen(
      (connected) {
        debugPrint('connected: $connected');
      },
    );
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
      print(productItem?.productId);
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      debugPrint('purchase-error: $purchaseError');
    });
    update();
  }

  @override
  void onClose() {
    closeMarket();
    super.onClose();
  }

  closeMarket() async {
    await FlutterInappPurchase.instance.finalize();
    _conectionSubscription.cancel();
    _purchaseUpdatedSubscription.cancel();
    _purchaseErrorSubscription.cancel();
  }

  List<IAPItem> items = [];

  List<IAPItem> subItems = [];

  void getItems() async {
    items = await FlutterInappPurchase.instance.getProducts(productIds);
    update();
  }

  void getSubs() async {
    subItems = await FlutterInappPurchase.instance.getSubscriptions(subProductIds);
    update();
  }

  void purchase(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestPurchase(item.productId!);
    } finally {
      update();
    }
  }
}
