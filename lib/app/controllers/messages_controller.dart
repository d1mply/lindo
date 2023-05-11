import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../core/init/network/network_manager.dart';

class MessagesController extends GetxController {
  @override
  void onReady() {
    init();
    super.onReady();
  }

  List<Map<dynamic, dynamic>> chatRooms = [];

  init() async {
    await NetworkManager.instance.getUserReference(FirebaseAuth.instance.currentUser!.uid).child("chatrooms").get().then(
      (DataSnapshot value) async {
        if (value.exists) {
          Object? vals = value.value;
          if (vals != null) {
            Map<dynamic, dynamic> values = value.value as Map<dynamic, dynamic>;

            values.forEach(
              (key, value) {
                chatRooms.add(value);
              },
            );
          }
          update();
        }
      },
    );
  }
}
