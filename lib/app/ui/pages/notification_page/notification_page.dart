// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/core/init/network/network_manager.dart';
import 'package:story_view/story_view.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/notification_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../controllers/usercontroller.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/k_bottom_sheet.dart';
import '../../utils/k_button.dart';
import '../../utils/k_textformfield.dart';
import '../chat_page/chat_page.dart';
import '../market_page/market_page.dart';
import '../profile_page/profile_page.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.instance.background_gray,
        elevation: 0,
        title: Text(
          "Bildirimler",
          style: TextStyle(
            color: ColorManager.instance.black,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: ColorManager.instance.background_gray,
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
                child: GetBuilder<NotificationController>(
                  init: NotificationController(),
                  builder: (c) {
                    return ListView.builder(
                      itemCount: c.messages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            UserController userController = Get.find();
                            if (!userController.isPremium) {
                              KBottomSheet.show(
                                context: context,
                                title: "Profil Görüntüleme",
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Profilinizi görüntüleyen kullanıcıların profillerini görüntülemek ve mesaj gönderebilmek için premium hesaba geçiş yapmalısınız.",
                                      ),
                                    ),
                                    KButton(
                                      color: ColorManager.instance.pink,
                                      onTap: () {
                                        Navigator.pop(context);
                                        Get.to(() => const MarketPage());
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
                            } else {
                              Map<dynamic, dynamic>? user = await c.getUser(c.messages[index]["senderUid"]);
                              StoryController controller = StoryController();

                              List<StoryItem> storyItems = [];
                              if (user?["images"] != null) {
                                List items = user?["images"];
                                for (var e in items) {
                                  storyItems.add(
                                    StoryItem.inlineImage(
                                      url: e,
                                      controller: StoryController(),
                                      duration: const Duration(seconds: 6),
                                    ),
                                  );
                                }
                              }

                              CustomDialog().showGeneralDialog(
                                context,
                                icon: const SizedBox(),
                                isExpanded: true,
                                body: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      storyItems.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: SizedBox(
                                                height: Get.height / 2,
                                                width: Get.width,
                                                child: StoryView(
                                                  storyItems: storyItems,
                                                  controller: controller,
                                                  inline: true,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              user?["name"],
                                              style: TextStyle(
                                                color: ColorManager.instance.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${DateTime.now().year - int.parse(user?["birth"].toString().split("-").first.toString() ?? "")}",
                                              style: TextStyle(
                                                color: ColorManager.instance.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      user?["location"] != null
                                          ? Text(
                                              user?["location"],
                                              style: TextStyle(
                                                color: ColorManager.instance.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const SizedBox(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                                        child: KButton(
                                          color: ColorManager.instance.pink,
                                          onTap: () {
                                            Get.back();
                                            Get.to(
                                              () => ChatPage(uid: user?["uid"]),
                                            );
                                          },
                                          title: "Mesaj Gönder",
                                          textColor: ColorManager.instance.white,
                                        ),
                                      ),
                                      KTextFormField.instance.widget(
                                        context: context,
                                        labelText: "Biyografi",
                                        readOnly: true,
                                        controller: TextEditingController()..text = "${user?["bio"] ?? ""}",
                                        maxLines: 5,
                                        minLines: 1,
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color: ColorManager.instance.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                const Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "Bilgi",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Info(
                                                  img: "assets/images/height.png",
                                                  title: "Boy",
                                                  desc: user?["height"] == null ? "" : "${user?["height"]} cm",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/weight.png",
                                                  title: "Ağırlık",
                                                  desc: user?["weight"] == null ? "" : "${user?["weight"]} kg",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/smoking.png",
                                                  title: "Sigara",
                                                  desc: user?["smoking"] == null ? "" : "${user?["smoking"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/wine-bottle.png",
                                                  title: "Alkol",
                                                  desc: user?["wine-bottle"] == null ? "" : "${user?["wine-bottle"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/heart.png",
                                                  title: "İlişki Beklentim",
                                                  desc: user?["hearth"] == null ? "" : "${user?["hearth"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/gender.png",
                                                  title: "Cinsellik",
                                                  desc: user?["sex"] == null ? "" : "${user?["sex"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/personality.png",
                                                  title: "Kişilik",
                                                  desc: user?["personality"] == null ? "" : "${user?["personality"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/money.png",
                                                  title: "İlgi Alanları",
                                                  desc: user?["money"] == null ? "" : "${user?["money"]}",
                                                  onTap: () {},
                                                ),
                                                GetBuilder<UserController>(
                                                  builder: (userController) {
                                                    return Info(
                                                      img: "assets/images/insta.png",
                                                      title: "Instagram",
                                                      desc: user?["instagram"] == null
                                                          ? ""
                                                          : userController.isPremium == false
                                                              ? "@*********"
                                                              : "${user?["instagram"]}",
                                                      onTap: () {
                                                        if (userController.isPremium == false) {
                                                          Get.to(() => const MarketPage());
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {},
                                      ),
                                      InkWell(
                                        onTap: () {
                                          CustomDialog().showGeneralDialog(
                                            context,
                                            icon: const SizedBox(),
                                            isExpanded: false,
                                            body: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                                                        child: KButton(
                                                          color: ColorManager.instance.pink,
                                                          onTap: () {
                                                            Get.back();
                                                            Get.back();
                                                            TextEditingController con = TextEditingController();
                                                            KBottomSheet.show(
                                                              context: context,
                                                              withoutHeader: true,
                                                              content: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "Şikayet sebebiniz;",
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  KTextFormField.instance.widget(
                                                                    context: context,
                                                                    maxLines: 4,
                                                                    controller: con,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      left: 8.0,
                                                                      right: 8,
                                                                      bottom: 8,
                                                                    ),
                                                                    child: Text(
                                                                      "Şikayetinizden ${user?["name"]} kullanıcısının haberi olmayacak.",
                                                                      style: TextStyle(color: ColorManager.instance.secondary),
                                                                    ),
                                                                  ),
                                                                  KButton(
                                                                    color: ColorManager.instance.pink,
                                                                    onTap: () async {
                                                                      if (con.text.isNotEmpty) {
                                                                        UserController userController = Get.find();
                                                                        await userController.report(
                                                                          "${user?["uid"]}",
                                                                          con.text,
                                                                        );
                                                                      }

                                                                      Get.back();
                                                                      Get.back();
                                                                      Get.snackbar(
                                                                        "Şikayetiniz alınmıştır.",
                                                                        "${user?["name"]} kullanıcısı bundan haberdar olmayacak.",
                                                                        backgroundColor: ColorManager.instance.white,
                                                                        duration: const Duration(seconds: 5),
                                                                      );
                                                                    },
                                                                    title: "Şikayet Et",
                                                                    textColor: ColorManager.instance.white,
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          title: "Şikayet Et",
                                                          textColor: ColorManager.instance.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                                                        child: GetBuilder<UserController>(
                                                          builder: (userController) {
                                                            return KButton(
                                                              color: ColorManager.instance.pink,
                                                              onTap: () async {
                                                                await userController.addBlock("${user?["uid"]}");
                                                                Get.back();
                                                                Get.back();
                                                                Get.snackbar(
                                                                  !userController.blockedUsers.contains("${user?["uid"]}") ? "Engellendi" : "Engel kaldırıldı",
                                                                  !userController.blockedUsers.contains("${user?["uid"]}") ? "${user?["name"]} kullanıcısı engellendi." : "${user?["name"]} kullanıcısının engeli kaldırıldı.",
                                                                  backgroundColor: ColorManager.instance.white,
                                                                  duration: const Duration(seconds: 5),
                                                                );
                                                              },
                                                              title: userController.blockedUsers.contains("${user?["uid"]}") ? "Engeli Kaldır" : "Engelle",
                                                              textColor: ColorManager.instance.white,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                KButton(
                                                  color: ColorManager.instance.white,
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  title: "Vazgeç",
                                                  textColor: ColorManager.instance.pink,
                                                  borderColor: ColorManager.instance.pink,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Şikayet et veya Engelle",
                                          style: TextStyle(
                                            color: ColorManager.instance.gray_text,
                                            decoration: TextDecoration.underline,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              onDismissed: (direction) async {
                                await NetworkManager.instance.notificationRef.child(c.keys[index]).remove();
                                c.keys.removeAt(index);
                              },
                              key: Key("$index"),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: ColorManager.instance.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: ColorManager.instance.white,
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorManager.instance.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      c.messages[index]["image"] != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(right: 12.0),
                                              child: GetBuilder<UserController>(builder: (userController) {
                                                if (userController.isPremium) {
                                                  return ClipRRect(
                                                    borderRadius: BorderRadius.circular(500),
                                                    child: CachedNetworkImage(
                                                      imageUrl: c.messages[index]["image"],
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                } else {
                                                  return ClipRRect(
                                                    borderRadius: BorderRadius.circular(500),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: Stack(
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: c.messages[index]["image"],
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        BackdropFilter(
                                                            filter: ImageFilter.blur(
                                                              sigmaX: 2.0,
                                                              sigmaY: 2.0,
                                                            ),
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              color: ColorManager.instance.transparent,
                                                            )),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(right: 12.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(500),
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset("assets/images/bigender.png"),
                                                ),
                                              ),
                                            ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              c.messages[index]["sender"] ?? "",
                                              style: TextStyle(
                                                color: ColorManager.instance.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              c.messages[index]["message"] ?? "",
                                              style: TextStyle(
                                                color: ColorManager.instance.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  timeago.format(
                                                    DateTime.fromMillisecondsSinceEpoch(c.messages[index]["timestamp"]),
                                                    locale: "tr",
                                                  ),
                                                  style: TextStyle(
                                                    color: ColorManager.instance.text_gray,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
