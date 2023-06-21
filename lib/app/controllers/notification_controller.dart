import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../core/init/network/network_manager.dart';

class NotificationController extends GetxController {
  int? lastKey;

  List<Map<dynamic, dynamic>> messages = [];
  List<String> keys = [];

  Future<Map<dynamic, dynamic>?> getUser(String uid) async {
    Map<dynamic, dynamic>? user;

    DataSnapshot user0 = await NetworkManager.instance.getUserDetailsWithId(uid);
    if (user0.exists) {
      Object? vals = user0.value;
      if (vals != null) {
        user = user0.value as Map<dynamic, dynamic>;
      }
      update();
    }
    return user;
  }

  @override
  void onInit() {
    super.onInit();
    getMessages();
  }

  Future<void> getMessages() async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    await NetworkManager.instance.notificationRef.orderByChild("uid").equalTo(myUid).once().then(
      (DatabaseEvent snapshot) {
        Object? vals = snapshot.snapshot.value;
        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          List<Map<dynamic, dynamic>> temp = [];
          values.forEach(
            (key, value) {
              if (!keys.contains(key)) {
                temp.add(value);
                keys.add(key);
              }
            },
          );

          messages = temp;
          messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
          update();
          lastKey = messages.last["timestamp"];
        }
      },
    );
  }
}
