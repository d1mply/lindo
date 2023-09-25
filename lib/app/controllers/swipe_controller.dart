import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/core/init/cache/cache_manager.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../core/init/network/network_manager.dart';
import '../ui/pages/swipe_page/swipe_page.dart';

GlobalKey one = GlobalKey();
GlobalKey two = GlobalKey();
GlobalKey three = GlobalKey();
GlobalKey four = GlobalKey();
GlobalKey five = GlobalKey();

class SwipeController extends GetxController {
  int pageSize = 100;
  List<Map<dynamic, dynamic>> usersList = [];
  List<Widget> cards = [];
  bool keyAdded = false;
  SwipeController(this.context);

  bool isLoading = false;
  getUsers({String? start}) async {
    isLoading = true;
    update();
    DataSnapshot currentUser = await NetworkManager.instance.getCurrentUserDetails();
    final data = currentUser.value as Map<Object?, Object?>;

    var gender = data["gender"];

    int selectedGender = 2;
    if (gender == 1) {
      selectedGender = 2;
    } else {
      selectedGender = 1;
    }
    await NetworkManager.instance.usersRef.orderByChild("gender").equalTo(selectedGender).limitToFirst(40).once().then(
      (DatabaseEvent snapshot) {
        Object? vals = snapshot.snapshot.value;
        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          UserController userController = Get.find();
          values.forEach(
            (key, value) {
              print(key);
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

          cards = usersList.map(
            (e) {
              return usersList.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: Story(
                          images: e["images"],
                          name: e["name"],
                          age: e["birth"],
                          show: e["kk"],
                          user: e,
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ).toList();
          cards.shuffle();
        }
      },
    );
    isLoading = false;
    update();
    showShowCaseView();
  }

  final BuildContext context;

  showShowCaseView() {
    bool? cached = CacheManager.instance.getValue("showCased");
    if (cached == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase(
          [one],
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
