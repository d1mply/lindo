import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/core/init/cache/cache_manager.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../core/init/network/network_manager.dart';

GlobalKey one = GlobalKey();
GlobalKey two = GlobalKey();
GlobalKey three = GlobalKey();
GlobalKey four = GlobalKey();
GlobalKey five = GlobalKey();

class SwipeController extends GetxController {
  AppinioSwiperController controller = AppinioSwiperController();
  int pageSize = 100;
  List<Map<dynamic, dynamic>> usersList = [];
  bool keyAdded = false;
  SwipeController(this.context);
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
                if (keyAdded == false) {
                  value["kk"] = true;
                  keyAdded = true;
                }
                usersList.add(value);
                update();
              }
            },
          );
        }
      },
    );
    update();
    showShowCaseView();
  }

  getMoreUsers() {
    try {
      String uid = usersList.last["uid"];
      usersList = [];
      getUsers(start: uid);
    } finally {}
  }

  final BuildContext context;
  showShowCaseView() {
    bool? cached = CacheManager.instance.getValue("showCased");
    if (cached == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase(
          [one, two],
        ),
      );
    }
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}
