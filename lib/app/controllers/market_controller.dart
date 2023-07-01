// ignore_for_file: empty_catches, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/core/init/network/network_manager.dart';

class MarketController extends GetxController {
  late StreamSubscription<List<PurchaseDetails>> subscription;
  PageController pageController = PageController();
  int groupValue = 0;

  final List<String> kProductIds = <String>[
    "boost_1h",
    "boost_3h",
    "boost_524h",
    "1",
    "2",
    "3",
  ];

  final List<String> kProductIdsforIOS = <String>[
    "boost_1h",
    "boost_3h",
    "boost_524h",
    "1m",
    "2m",
    "3m",
  ];

  List<ProductDetails> products = [];
  List<ProductDetails> premiums = [];

  @override
  void onInit() {
    initMarket();

    super.onInit();
  }

  List<String> boostDetails = [];
  List<String> premiumDetails = [];

  getMarketDescriptionData() async {
    try {
      DataSnapshot snapshot = await NetworkManager.instance.boostRef.get();

      if (snapshot.exists) {
        for (var element in snapshot.children) {
          boostDetails.add(element.value as String);
        }
      }
    } catch (e) {}

    try {
      DataSnapshot snapshot2 = await NetworkManager.instance.premiumRef.get();

      if (snapshot2.exists) {
        for (var element in snapshot2.children) {
          premiumDetails.add(element.value as String);
        }
      }
    } catch (e) {}
  }

  final int hour = 3600000;

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(
      (PurchaseDetails purchaseDetails) async {
        {
          DateTime now = DateTime.now();
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            NetworkManager.instance.buyTransactionsRef.push().set(
              {
                "uid": FirebaseAuth.instance.currentUser!.uid,
                "email": FirebaseAuth.instance.currentUser!.email,
                "dateTime": now.toString(),
                "timestamp": now.millisecondsSinceEpoch,
                "productId": purchaseDetails.productID,
                "transactionDate": purchaseDetails.transactionDate,
                "purchaseId": purchaseDetails.purchaseID,
              },
            );

            if (purchaseDetails.productID == "boost_1h") {
              int newTime = now.millisecondsSinceEpoch + hour;
              await NetworkManager.instance.currentUserRef().update({"boostEndDate": newTime});
            } else if (purchaseDetails.productID == "boost_3h") {
              int newTime = now.millisecondsSinceEpoch + (hour * 3);
              await NetworkManager.instance.currentUserRef().update({"boostEndDate": newTime});
            } else if (purchaseDetails.productID == "boost_524h") {
              int newTime = now.millisecondsSinceEpoch + (hour * 24);
              await NetworkManager.instance.currentUserRef().update({"boostEndDate": newTime});
            } else if (purchaseDetails.productID == "1") {
              int newTime = now.millisecondsSinceEpoch + ((hour * 24) * 30);
              await NetworkManager.instance.currentUserRef().update({"premiumEndDate": newTime});
            } else if (purchaseDetails.productID == "1") {
              int newTime = now.millisecondsSinceEpoch + ((hour * 24) * 90);
              await NetworkManager.instance.currentUserRef().update({"premiumEndDate": newTime});
            } else if (purchaseDetails.productID == "1") {
              int newTime = now.millisecondsSinceEpoch + ((hour * 24) * 180);
              await NetworkManager.instance.currentUserRef().update({"premiumEndDate": newTime});
            }
            UserController userController = Get.find();
            await userController.getCurrentUserData();
            Get.back();
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      },
    );
  }

  bool available = false;
  initMarket() async {
    await getMarketDescriptionData();
    available = await InAppPurchase.instance.isAvailable();
    if (available) {
      final ProductDetailsResponse productDetailResponse = await InAppPurchase.instance.queryProductDetails(Platform.isAndroid ? kProductIds.toSet() : kProductIdsforIOS.toSet());

      if (productDetailResponse.error == null) {
        for (int i = 0; i < productDetailResponse.productDetails.length; i++) {
          if (productDetailResponse.productDetails[i].id == "1" || productDetailResponse.productDetails[i].id == "2" || productDetailResponse.productDetails[i].id == "3") {
            premiums.add(productDetailResponse.productDetails[i]);
          } else {
            products.add(productDetailResponse.productDetails[i]);
          }
        }
        update();
      }
      print(products.length);
      subscription = InAppPurchase.instance.purchaseStream.listen(
        (purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        },
        onDone: () {},
        onError: (error) {},
      );
    }
    update();
  }

  @override
  void onClose() {
    closeMarket();
    super.onClose();
  }

  closeMarket() async {
    try {
      subscription.cancel();
    } catch (e) {}
  }
}
