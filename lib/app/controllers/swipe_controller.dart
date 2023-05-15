import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';

import '../../core/init/network/network_manager.dart';

class SwipeController extends GetxController {
  AppinioSwiperController controller = AppinioSwiperController();
  int pageSize = 100;
  List<Map<dynamic, dynamic>> usersList = [];
  getUsers({String? start}) async {
    await NetworkManager.instance.usersRef.orderByChild("uid").startAfter(start).limitToFirst(pageSize).once().then(
      (DatabaseEvent snapshot) {
        Object? vals = snapshot.snapshot.value;
        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          UserController userController = Get.find();
          values.forEach(
            (key, value) {
              if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                usersList.add(value);
                update();
              }
            },
          );
        }
      },
    );
    update();
  }

  getMoreUsers() {
    try {
      String uid = usersList.last["uid"];
      usersList = [];
      getUsers(start: uid);
    } finally {}
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}
