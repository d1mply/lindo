import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/messages_controller.dart';
import '../chat_page/chat_page.dart';

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
            return Scaffold(
              backgroundColor: ColorManager.instance.background_gray,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: c.chatRooms.length,
                      itemBuilder: (context, index) {
                        String uid = c.chatRooms[index]["chatroomId"].replaceAll("-", "").replaceAll(FirebaseAuth.instance.currentUser!.uid, "");
                        return FutureBuilder(
                          future: NetworkManager.instance.getUserDetailsWithId(uid),
                          builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              Map<dynamic, dynamic> user = snapshot.data!.value as Map<dynamic, dynamic>;
                              return InkWell(
                                onTap: () {
                                  pushNewScreen(
                                    context,
                                    screen: ChatPage(
                                      uid: uid,
                                    ),
                                    withNavBar: false,
                                  );
                                },
                                child: FutureBuilder(
                                    future: NetworkManager.instance.getUserLastMessages(uid),
                                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(500),
                                                    child: user["images"] == null
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
                                                          ),
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
                                                          user["name"] ?? "",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: ColorManager.instance.primary,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.hasData ? (snapshot.data!["message"]) : "",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: ColorManager.instance.primary,
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
                                                      snapshot.hasData ? (snapshot.data!["time"]) : "",
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
                                    }),
                              );
                            } else {
                              return const CupertinoActivityIndicator();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
