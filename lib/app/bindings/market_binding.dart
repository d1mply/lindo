
import 'package:get/get.dart';
import '../controllers/market_controller.dart';


class MarketBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketController>(() => MarketController());
  }
}