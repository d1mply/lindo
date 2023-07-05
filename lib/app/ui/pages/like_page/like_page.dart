import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/app/ui/pages/market_page/market_page.dart';
import 'package:lindo/app/ui/utils/k_bottom_sheet.dart';
import 'package:lindo/app/ui/utils/k_button.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../controllers/like_controller.dart';
import '../explore_page/explore_page.dart';

class LikePage extends GetView<LikeController> {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.instance.background_gray,
      appBar: AppBar(
        backgroundColor: ColorManager.instance.background_gray,
        elevation: 0,
        actions: const [
          ShopWidget(type: 2),
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
                              child: Stack(
                                children: [
                                  GetBuilder<UserController>(
                                    builder: (userController) {
                                      return Center(
                                        child: userController.isPremium == true
                                            ? ClipRRect(
                                                clipBehavior: Clip.hardEdge,
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                                child: CachedNetworkImage(
                                                  height: 150,
                                                  width: Get.width,
                                                  imageUrl: c.messages[index]["image"],
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  KBottomSheet.show(
                                                    context: context,
                                                    title: "Beğeniler",
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Size beğeni gönderen profili görüntülemek için premium olmanız gerekmektedir.",
                                                          ),
                                                        ),
                                                        KButton(
                                                          color: ColorManager.instance.pink,
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                            Get.to(() => const MarketPage(type: 2));
                                                          },
                                                          title: "Premium Ol",
                                                          borderColor: ColorManager.instance.pink,
                                                          textColor: ColorManager.instance.white,
                                                        ),
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: ImageFiltered(
                                                  imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0, tileMode: TileMode.decal),
                                                  child: ClipRRect(
                                                    clipBehavior: Clip.hardEdge,
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(12),
                                                      topRight: Radius.circular(12),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 2.0, right: 2),
                                                      child: CachedNetworkImage(
                                                        height: 150,
                                                        width: Get.width,
                                                        imageUrl: c.messages[index]["image"],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 52,
                                      width: Get.width,
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
                                              UserController userController = Get.find();
                                              if (userController.isPremium) {
                                                print(c.keys[index]);
                                                await NetworkManager.instance.swipe.child(c.keys[index]).remove();
                                                c.keys.removeAt(index);
                                                c.messages.removeAt(index);
                                                c.update();
                                              } else {
                                                KBottomSheet.show(
                                                  context: context,
                                                  title: "Beğeniler",
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Beğenilere karşılık verip sohbet başlatabilmek için premium olmanız gerekmektedir.",
                                                        ),
                                                      ),
                                                      KButton(
                                                        color: ColorManager.instance.pink,
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          Get.to(() => const MarketPage(type: 2));
                                                        },
                                                        title: "Premium Ol",
                                                        borderColor: ColorManager.instance.pink,
                                                        textColor: ColorManager.instance.white,
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: SvgPicture.asset("assets/svg/love.svg"),
                                            onPressed: () async {
                                              UserController userController = Get.find();
                                              if (userController.isPremium) {
                                                DateTime now = DateTime.now();
                                                String uid = c.messages[index]["senderUid"];
                                                String chatRoomId = calculateChatRoomId(uid, FirebaseAuth.instance.currentUser!.uid);
                                                NetworkManager.instance.getUserReference(uid).child("chatrooms").child(chatRoomId).set(
                                                  {
                                                    "timestamp": now.millisecondsSinceEpoch,
                                                    "uid": FirebaseAuth.instance.currentUser!.uid,
                                                    "chatroomId": chatRoomId,
                                                    "liked": true,
                                                  },
                                                );
                                                NetworkManager.instance.getUserReference(FirebaseAuth.instance.currentUser!.uid).child("chatrooms").child(chatRoomId).set(
                                                  {
                                                    "timestamp": now.millisecondsSinceEpoch,
                                                    "uid": uid,
                                                    "chatroomId": chatRoomId,
                                                    "liked": true,
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
                                                    "type": "text",
                                                    "message": "Eşleşme başladı.",
                                                    "isRead": false,
                                                  },
                                                );

                                                await NetworkManager.instance.swipe.child(c.keys[index]).remove();
                                                c.keys.removeAt(index);
                                                c.messages.removeAt(index);
                                                c.update();
                                              } else {
                                                KBottomSheet.show(
                                                  context: context,
                                                  title: "Beğeniler",
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Beğenilere karşılık verip sohbet başlatabilmek için premium olmanız gerekmektedir.",
                                                        ),
                                                      ),
                                                      KButton(
                                                        color: ColorManager.instance.pink,
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          Get.to(() => const MarketPage(type: 2));
                                                        },
                                                        title: "Premium Ol",
                                                        borderColor: ColorManager.instance.pink,
                                                        textColor: ColorManager.instance.white,
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(
                                delay: Duration(milliseconds: 300 * index),
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
