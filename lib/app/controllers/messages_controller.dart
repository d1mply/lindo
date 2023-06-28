import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../core/init/network/network_manager.dart';

class MessagesController extends GetxController {
  @override
  void onReady() {
    getData();
    super.onReady();
  }

  bool noMessage = false;
  bool flag = false;
  List<Map<dynamic, dynamic>> chatRooms = [];
  List<Map<dynamic, dynamic>> chatRoomsForSwiped = [];

  getData() async {
    await NetworkManager.instance.getUserReference(FirebaseAuth.instance.currentUser!.uid).child("chatrooms").get().then(
      (DataSnapshot value) async {
        if (value.exists) {
          Object? vals = value.value;
          if (vals != null) {
            Map<dynamic, dynamic> values = value.value as Map<dynamic, dynamic>;

            values.forEach(
              (key, value) {
                if (value["liked"] == true) {
                  chatRoomsForSwiped.add(value);
                } else {
                  chatRooms.add(value);
                }
              },
            );
          }
          update();
        }
      },
    );
  }
}
