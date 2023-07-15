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
  bool isLoaded = false;
  List<Map<dynamic, dynamic>> chatRooms = [];
  List<Map<dynamic, dynamic>> chatRoomsForSwiped = [];

  getData() async {
    chatRoomsForSwiped = [];
    chatRooms = [];
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
    sortList();
  }

  sortList() async {
    List<Map<dynamic, dynamic>> sortedListChat = [];
    List<Map<dynamic, dynamic>> sortedListSwiped = [];

    for (int i = 0; i < chatRooms.length; i++) {
      String uid = chatRooms[i]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "");
      Map<String, dynamic> x = await NetworkManager.instance.getUserLastMessages(uid);
      int count = x["count"];
      Map<dynamic, dynamic> data = chatRooms[i];
      data["count"] = count;
      sortedListChat.add(data);
    }
    sortedListChat.sort((a, b) => b["count"].compareTo(a["count"]));
    chatRooms = sortedListChat;

    for (int i = 0; i < chatRoomsForSwiped.length; i++) {
      String uid = chatRoomsForSwiped[i]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "");
      Map<String, dynamic> x = await NetworkManager.instance.getUserLastMessages(uid);
      int count = x["count"];
      Map<dynamic, dynamic> data = chatRoomsForSwiped[i];
      data["count"] = count;
      sortedListSwiped.add(data);
    }
    sortedListSwiped.sort((a, b) => b["count"].compareTo(a["count"]));
    chatRoomsForSwiped = sortedListSwiped;
    isLoaded = true;
    update();
  }
}
