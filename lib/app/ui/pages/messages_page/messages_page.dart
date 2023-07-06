import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/core/base/state.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/messages_controller.dart';
import '../chat_page/chat_page.dart';
import '../explore_page/explore_page.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.instance.white,
      child: SafeArea(
        child: GetBuilder<MessagesController>(
          init: MessagesController(),
          builder: (c) {
            return GetBuilder<UserController>(
              builder: (userController) {
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    leading: const ShopWidget(type: 3),
                    elevation: 0,
                    backgroundColor: ColorManager.instance.background_gray,
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/coin.png",
                              height: 24,
                              width: 24,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Text(
                                "${userController.coin}",
                                style: TextStyle(
                                  color: ColorManager.instance.black,
                                  fontSize: 16,
                                  fontFamily: "Bold",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    title: Image.asset(
                      "assets/images/lindo.png",
                      width: 79,
                      height: 54,
                    ),
                  ),
                  backgroundColor: ColorManager.instance.background_gray,
                  body: c.isLoaded == true
                      ? SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                bottom: 60,
                                child: SvgPicture.asset(
                                  "assets/svg/logo.svg",
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 16.w,
                                      top: 16.w,
                                      bottom: 16.w,
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            c.flag = false;
                                            c.update();
                                          },
                                          child: Text(
                                            "Mesajlar",
                                            style: TextStyle(
                                              color: c.flag == false ? ColorManager.instance.black : ColorManager.instance.softBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              decoration: c.flag == false ? TextDecoration.underline : null,
                                              fontFamily: "Medium",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            c.flag = true;
                                            c.update();
                                          },
                                          child: Text(
                                            "Eşleşmeler",
                                            style: TextStyle(
                                              color: c.flag == true ? ColorManager.instance.black : ColorManager.instance.softBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              decoration: c.flag == true ? TextDecoration.underline : null,
                                              fontFamily: "Medium",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: c.isLoaded == true
                                              ? ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: c.flag == false ? c.chatRooms.length : c.chatRoomsForSwiped.length,
                                                  itemBuilder: (context, index) {
                                                    String uid = c.flag == false ? c.chatRooms[index]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "") : c.chatRoomsForSwiped[index]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "");
                                                    return FutureBuilder(
                                                      future: NetworkManager.instance.getUserDetailsWithId(uid),
                                                      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
                                                        if (snapshot.hasData) {
                                                          Map<dynamic, dynamic> user = snapshot.data!.value as Map<dynamic, dynamic>;
                                                          return InkWell(
                                                            onTap: () {
                                                              String? uid = c.flag == false ? c.chatRooms[index]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "") : c.chatRoomsForSwiped[index]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "");
                                                              Get.to(
                                                                () => ChatPage(uid: uid!),
                                                              );
                                                            },
                                                            child: FutureBuilder(
                                                              future: NetworkManager.instance.getUserLastMessages(uid),
                                                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                                                if (snapshot.hasData) {
                                                                  return Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.w),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(color: ColorManager.instance.white, borderRadius: BorderRadius.circular(8)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(4.0.w),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Stack(
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(500),
                                                                                    child: snapshot.hasData
                                                                                        ? user["images"] == null
                                                                                            ? SvgPicture.asset(
                                                                                                "assets/svg/no_gender.svg",
                                                                                                width: 40.w,
                                                                                                height: 40.w,
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                            : CachedNetworkImage(
                                                                                                imageUrl: user["images"].first,
                                                                                                width: 40.w,
                                                                                                height: 40.w,
                                                                                                fit: BoxFit.cover,
                                                                                              )
                                                                                        : const SizedBox(),
                                                                                  ),
                                                                                  c.flag == true
                                                                                      ? Positioned(
                                                                                          left: 0,
                                                                                          bottom: 0,
                                                                                          child: Icon(
                                                                                            Icons.favorite,
                                                                                            size: Utility.dynamicWidthPixel(16),
                                                                                            color: ColorManager.instance.pink,
                                                                                          ),
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 8.0.w, right: 8.w),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "${snapshot.hasData ? user["name"] ?? "" : ""}",
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: ColorManager.instance.primary,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 14,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      "${snapshot.hasData ? (snapshot.data!["message"] ?? "") : ""}",
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                        color: ColorManager.instance.primary,
                                                                                        fontWeight: snapshot.data!["count"] != 0 ? FontWeight.bold : FontWeight.normal,
                                                                                        fontSize: 14,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Text(
                                                                                  "${snapshot.hasData ? (snapshot.data!["time"] ?? "") : ""}",
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(
                                                                                    color: ColorManager.instance.gray,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                                snapshot.hasData
                                                                                    ? snapshot.data!["count"] != 0
                                                                                        ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: ColorManager.instance.pink,
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Text(
                                                                                                snapshot.data!["count"].toString(),
                                                                                                maxLines: 1,
                                                                                                style: TextStyle(
                                                                                                  color: ColorManager.instance.white,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  fontSize: 14,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : const SizedBox()
                                                                                    : const Text(""),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return const SizedBox();
                                                                }
                                                              },
                                                            ),
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },
                                                    );
                                                  },
                                                )
                                              : const SizedBox(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 16,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: Get.width,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
