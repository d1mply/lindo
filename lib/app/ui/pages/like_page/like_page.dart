import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../controllers/like_controller.dart';

class LikePage extends GetView<LikeController> {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.instance.background_gray,
      appBar: AppBar(
        backgroundColor: ColorManager.instance.background_gray,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/shop.png",
              height: 24,
              width: 24,
            ),
          ),
        ],
        title: Text(
          "Beğeniler",
          style: TextStyle(
            color: ColorManager.instance.black,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Stack(
            children: [
              Positioned(
                left: 20,
                bottom: 60,
                child: SvgPicture.asset(
                  "assets/svg/logo.svg",
                ),
              ),
              SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: Center(
                  child: GetBuilder<LikeController>(
                    init: LikeController(),
                    builder: (c) {
                      return GridView.builder(
                        itemCount: c.messages.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 8.0,
                          mainAxisExtent: 202,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: c.messages[index]["image"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorManager.instance.white,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          icon: SvgPicture.asset("assets/svg/love_off.svg"),
                                          onPressed: () async {
                                            await NetworkManager.instance.notificationRef.child(c.keys[index]).remove();
                                            c.keys.removeAt(index);
                                            c.messages.removeAt(index);
                                            c.update();
                                          },
                                        ),
                                        IconButton(
                                          icon: SvgPicture.asset("assets/svg/love.svg"),
                                          onPressed: () async {
                                            DateTime now = DateTime.now();
                                            String chatRoomId = calculateChatRoomId(c.messages[index]["uid"], c.messages[index]["senderUid"]);
                                            NetworkManager.instance.getUserReference(c.messages[index]["uid"]).child("chatrooms").child(chatRoomId).set(
                                              {
                                                "timestamp": now.millisecondsSinceEpoch,
                                                "uid": c.messages[index]["senderUid"],
                                                "chatroomId": chatRoomId,
                                                "liked": true,
                                              },
                                            );
                                            NetworkManager.instance.getUserReference(c.messages[index]["senderUid"]).child("chatrooms").child(chatRoomId).set(
                                              {
                                                "timestamp": now.millisecondsSinceEpoch,
                                                "uid": c.messages[index]["uid"],
                                                "chatroomId": chatRoomId,
                                                "liked": true,
                                              },
                                            );

                                            await NetworkManager.instance.notificationRef.child(c.keys[index]).remove();
                                            c.keys.removeAt(index);
                                            c.messages.removeAt(index);
                                            c.update();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String calculateChatRoomId(String uid1, String uid2) {
  String chatRoomId = "";
  List<String> uidList = [uid1];
  uidList.add(FirebaseAuth.instance.currentUser!.uid);
  uidList.sort();
  chatRoomId = "${uidList.first}-${uidList.last}";
  return chatRoomId;
}
