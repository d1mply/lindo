
import 'package:get/get.dart';
import '../controllers/loginemail_controller.dart';


class LoginemailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginemailController>(() => LoginemailController());
  }
}