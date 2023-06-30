import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../core/init/network/network_manager.dart';

class UserController extends GetxController {
  List<String> blockedUsers = [];

  @override
  void onInit() {
    getBlockedUsers();
    getCurrentUserData();
    super.onInit();
  }

  getBlockedUsers() async {
    if (FirebaseAuth.instance.currentUser != null) {
      DataSnapshot snapshot = await NetworkManager.instance.currentUserRef().child("blocks").get();
      final List<String> items = [];
      if (snapshot.exists) {
        for (var element in snapshot.children) {
          items.add(element.value as String);
        }
      }
      blockedUsers = items;
      print(items);
    }
    update();
  }

  Future<bool> addBlock(String uid) async {
    if (blockedUsers.contains(uid)) {
      await removeBlock(uid);
    } else {
      await getBlockedUsers();
      if (!blockedUsers.contains(uid)) {
        blockedUsers.add(uid);
        NetworkManager.instance.currentUserRef().child("blocks").set(blockedUsers);
      }
      await getBlockedUsers();
    }
    update();

    return true;
  }

  Future<bool> removeBlock(String uid) async {
    if (blockedUsers.contains(uid)) {
      await getBlockedUsers();
      if (blockedUsers.contains(uid)) {
        blockedUsers.remove(uid);
        NetworkManager.instance.currentUserRef().child("blocks").set(blockedUsers);
      }
      await getBlockedUsers();
    } else {
      await addBlock(uid);
    }

    update();
    return true;
  }

  Future<bool> report(String uid, String text) async {
    await FirebaseDatabase.instance.ref("reports").push().set(
      {
        "reportedUid": uid,
        "text": text,
        "dateTime": DateTime.now().toString(),
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "reporterUid": FirebaseAuth.instance.currentUser!.uid,
      },
    );

    return true;
  }

  bool isPremium = false;
  bool boosted = false;

  int coin = 0;

  getCurrentUserData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();
      final data = user.value as Map<Object?, Object?>;
      if (data["premiumEndDate"] != null) {
        int premiumDate = data["premiumEndDate"] as int;
        if (DateTime.now().millisecondsSinceEpoch < premiumDate) {
          isPremium = true;
        }
      }
      if (data["boostEndDate"] != null) {
        int boostEndDate = data["boostEndDate"] as int;
        if (DateTime.now().millisecondsSinceEpoch < boostEndDate) {
          boosted = true;
        }
      }
      if (data["coin"] != null) {
        coin = data["coin"] as int;
      }
      update();
    }
  }
}
