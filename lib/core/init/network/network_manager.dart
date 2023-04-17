import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

  Future<DataSnapshot> getCurrentUserDetails() async {
    return await FirebaseDatabase.instance.ref().child('users').child("${FirebaseAuth.instance.currentUser?.uid}").get();
  }

  Future<DataSnapshot> userProfilePics() async {
    return await FirebaseDatabase.instance.ref().child("users").child("${FirebaseAuth.instance.currentUser?.uid}").child("userProfilePics").get();
  }
}
