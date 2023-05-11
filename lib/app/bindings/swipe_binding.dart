
import 'package:get/get.dart';
import '../controllers/swipe_controller.dart';


class SwipeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwipeController>(() => SwipeController());
  }
}