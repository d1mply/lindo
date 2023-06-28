// ignore_for_file: empty_catches, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class MarketController extends GetxController {
  late StreamSubscription<List<PurchaseDetails>> subscription;
  final List<String> kProductIds = <String>[
    "boost_1h",
    "boost_3h",
    "1",
    "2",
  ];
  List<ProductDetails> products = <ProductDetails>[];

  @override
  void onInit() {
    initMarket();

    super.onInit();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(
      (PurchaseDetails purchaseDetails) async {
        {
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            if (purchaseDetails.productID == "") {}
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
    available = await InAppPurchase.instance.isAvailable();
    if (available) {
      final ProductDetailsResponse productDetailResponse = await InAppPurchase.instance.queryProductDetails(kProductIds.toSet());

      if (productDetailResponse.error != null) {
        products = productDetailResponse.productDetails;
      }
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
