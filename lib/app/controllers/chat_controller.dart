// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/app/ui/pages/market_page/market_page.dart';

import '../../core/init/network/network_manager.dart';
import '../../core/init/theme/color_manager.dart';
import '../ui/utils/custom_dialog.dart';
import '../ui/utils/k_button.dart';

class ChatController extends GetxController {
  final String uid;
  ChatController(this.uid);

  String chatRoomId = "";
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEmojiEditingController = TextEditingController();
  bool isBlocked = false;
  String calculateChatRoomId() {
    List<String> uidList = [uid];
    uidList.add(FirebaseAuth.instance.currentUser!.uid);
    uidList.sort();
    chatRoomId = "${uidList.first}-${uidList.last}";
    return chatRoomId;
  }

  List<Map<dynamic, dynamic>> messages = [];
  List<String> keys = [];

  StreamSubscription<DatabaseEvent>? messageAddedSubscription;
  final ScrollController scrollController = ScrollController();
  int? lastKey;

  Future<void> getMessages() async {
    DatabaseReference chatRef = NetworkManager.instance.chatRooms.child(chatRoomId);
    await chatRef.orderByChild("timestamp").limitToLast(20).once().then(
      (DatabaseEvent snapshot) {
        Object? vals = snapshot.snapshot.value;
        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          List<Map<dynamic, dynamic>> temp = [];
          String myUid = FirebaseAuth.instance.currentUser!.uid;
          values.forEach(
            (key, value) {
              if (value["receiver_uid"] == myUid) {
                if (value["isRead"] != null) {
                  if (value["isRead"] == false) {
                    chatRef.child(key).update(
                      {
                        "isRead": true,
                      },
                    );
                  }
                }
              }
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

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  int page = 1;

  Future<void> loadMoreMessages() async {
    page = page + 1;
    DatabaseReference chatRef = NetworkManager.instance.chatRooms.child(chatRoomId);
    chatRef.orderByChild("timestamp").endAt(lastKey).limitToLast(20 * page).once().then(
      (snapshot) {
        Object? vals = snapshot.snapshot.value;
        if (vals != null) {
          String myUid = FirebaseAuth.instance.currentUser!.uid;

          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          values.forEach(
            (key, value) {
              if (value["receiver_uid"] == myUid) {
                if (value["isRead"] != null) {
                  if (value["isRead"] == false) {
                    chatRef.child(key).update(
                      {
                        "isRead": true,
                      },
                    );
                  }
                }
              }
              if (!keys.contains(key)) {
                messages.add(value);
                keys.add(key);
              }
            },
          );

          messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
          update();
          lastKey = messages.last["timestamp"];
        }
      },
    );
  }

  Map<dynamic, dynamic>? user;

  Future<Map<dynamic, dynamic>?> getUser() async {
    DataSnapshot _user = await NetworkManager.instance.getUserDetailsWithId(uid);
    if (_user.exists) {
      Object? vals = _user.value;
      if (vals != null) {
        user = _user.value as Map<dynamic, dynamic>;
        try {
          if (user?["blocks"] != null) {
            if (user?["blocks"].contains(FirebaseAuth.instance.currentUser!.uid)) {
              isBlocked = true;
            }
          }
        } catch (e) {}
      }
      update();
    }
    return user;
  }

  sendMessage({
    bool? isLiked,
    required String type,
    required String message,
  }) async {
    if (message.replaceAll(" ", "").isNotEmpty) {
      UserController userController = Get.find();
      bool sendable = true;
      if (type == "text") {
        if (userController.coin < 25) {
          sendable = false;
        } else {
          await userController.removeCoin(25);
        }
      }
      if (type == "image") {
        if (userController.coin < 300) {
          sendable = false;
        } else {
          await userController.removeCoin(25);
        }
      }
      if (sendable) {
        DateTime now = DateTime.now();

        if (messages.isEmpty) {
          NetworkManager.instance.getUserReference(uid).child("chatrooms").child(chatRoomId).set(
            {
              "timestamp": now.millisecondsSinceEpoch,
              "uid": FirebaseAuth.instance.currentUser!.uid,
              "chatroomId": chatRoomId,
              "liked": isLiked == null ? false : true,
            },
          );
          NetworkManager.instance.getUserReference(FirebaseAuth.instance.currentUser!.uid).child("chatrooms").child(chatRoomId).set(
            {
              "timestamp": now.millisecondsSinceEpoch,
              "uid": uid,
              "chatroomId": chatRoomId,
              "liked": isLiked == null ? false : true,
            },
          );
          NetworkManager.instance.getUserReference(uid).update(
            {
              "lastMessage": DateTime.now().millisecondsSinceEpoch,
            },
          );
          await NetworkManager.instance.chatRooms.child(chatRoomId).push().set(
            {
              "timestamp": now.millisecondsSinceEpoch,
              "sender_uid": FirebaseAuth.instance.currentUser!.uid,
              "receiver_uid": uid,
              "type": type,
              "message": message,
              "isRead": false,
            },
          );
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          textEditingController.clear();
          update();
        } else {
          await NetworkManager.instance.chatRooms.child(chatRoomId).push().set(
            {
              "timestamp": now.millisecondsSinceEpoch,
              "sender_uid": FirebaseAuth.instance.currentUser!.uid,
              "receiver_uid": uid,
              "type": type,
              "message": message,
              "isRead": false,
            },
          );
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          textEditingController.clear();
          update();
        }
      } else {
        CustomDialog().showGeneralDialog(
          Get.context!,
          body: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                "Mesaj veya fotoğraf göndermek için altınınız yetersiz. Mesajlar 25, fotoğraflar 300 altın tüketir.",
              ),
              const SizedBox(height: 8),
              GetBuilder<UserController>(
                builder: (s) {
                  return Text(
                    "Mevcut Altın: ${s.coin}",
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32),
                child: KButton(
                  color: ColorManager.instance.pink,
                  textColor: ColorManager.instance.white,
                  onTap: () {
                    Get.to(
                      () => const MarketPage(
                        type: 3,
                      ),
                    );
                  },
                  title: "Altın Yükle",
                ),
              ),
            ],
          ),
          title: "Altın Yetersiz",
        );
      }
    }
  }

  initialize() async {
    calculateChatRoomId();
    await getUser();
    await getMessages();
    messageAddedSubscription = NetworkManager.instance.chatRooms.child(chatRoomId).limitToLast(1).onChildAdded.listen(
      (event) async {
        try {
          if (!keys.contains(event.snapshot.key)) {
            messages.add(event.snapshot.value as Map<dynamic, dynamic>);
            keys.add(event.snapshot.key ?? "");
          }
        } finally {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          update();
        }
      },
    );
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge && scrollController.position.pixels == 0) {
          loadMoreMessages();
        }
      },
    );
    try {
      Future.delayed(const Duration(milliseconds: 500), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
    } finally {}
  }

  @override
  void onReady() {
    initialize();
    super.onReady();
  }

  @override
  void onClose() {
    messageAddedSubscription?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}
