import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init();

  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
  DatabaseReference messagesRef = FirebaseDatabase.instance.ref().child('messages');
  DatabaseReference chatRooms = FirebaseDatabase.instance.ref().child('chat_rooms');

  DatabaseReference getUserReference(String uid) {
    return FirebaseDatabase.instance.ref().child('users').child(uid);
  }

  Future<DataSnapshot> getUserDetailsWithId(String uid) async {
    return await FirebaseDatabase.instance.ref().child('users').child(uid).get();
  }

  Future<Map<String, dynamic>> getUserLastMessages(String uid) async {
    String text = "";
    int count = 0;
    String time = "";

    await FirebaseDatabase.instance.ref().child('chat_rooms').child(calculateChatRoomId(uid)).orderByChild("timestamp").limitToLast(15).once().then(
      (DatabaseEvent snapshot) {
        Object? vals = snapshot.snapshot.value;
        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          dynamic tim = "";
          values.forEach(
            (key, value) {
              if (value["isRead"] != null) {
                print(value["isRead"]);
                if (value["isRead"] == false) {
                  count += 1;
                }
              }
              text = value["message"];
              tim = value["timestamp"];
              try {
                time = "${DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(tim.toString())))}";
              } catch (e) {}
            },
          );
        }
      },
    );
    return {"message": text, "count": count, "time": time};
  }

  String calculateChatRoomId(String uid) {
    List<String> uidList = [uid];
    uidList.add(FirebaseAuth.instance.currentUser!.uid);
    uidList.sort();
    String chatRoomId = "${uidList.first}-${uidList.last}";
    return chatRoomId;
  }

  Future<DataSnapshot> getCurrentUserDetails() async {
    return await FirebaseDatabase.instance.ref().child('users').child("${FirebaseAuth.instance.currentUser?.uid}").get();
  }

  DatabaseReference currentUserRef() {
    return FirebaseDatabase.instance.ref().child('users').child("${FirebaseAuth.instance.currentUser?.uid}");
  }

  Future<DataSnapshot> userProfilePics() async {
    return await FirebaseDatabase.instance.ref().child("users").child("${FirebaseAuth.instance.currentUser?.uid}").child("userProfilePics").get();
  }
}
