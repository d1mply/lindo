import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/app/ui/utils/k_bottom_sheet.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/chat_controller.dart';

import '../../../controllers/messages_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../global_widgets/full_screen_image.dart';
import '../../utils/k_button.dart';
import '../../utils/k_textformfield.dart';
import '../market_page/market_page.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatPage extends GetView<ChatController> {
  const ChatPage({required this.uid, super.key});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.instance.white,
      child: SafeArea(
        child: GetBuilder<UserController>(
          builder: (userController) {
            return GetBuilder<ChatController>(
              init: ChatController(uid),
              builder: (c) {
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: ColorManager.instance.greyBG,
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: ColorManager.instance.secondary,
                      ),
                      onPressed: () {
                        try {
                          MessagesController s = Get.find();
                          s.update();
                        } catch (e) {}

                        Get.back();
                      },
                    ),
                    elevation: 1,
                    actions: [
                      PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 0) {
                            TextEditingController con = TextEditingController();
                            KBottomSheet.show(
                              context: context,
                              withoutHeader: true,
                              content: SingleChildScrollView(
                                child: Column(
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
                                        "Şikayetinizden ${c.user?["name"]} kullanıcısının haberi olmayacak.",
                                        style: TextStyle(color: ColorManager.instance.secondary),
                                      ),
                                    ),
                                    KButton(
                                      color: ColorManager.instance.pink,
                                      onTap: () async {
                                        if (con.text.isNotEmpty) {
                                          UserController userController = Get.find();
                                          await userController.report(
                                            "${c.user?["uid"]}",
                                            con.text,
                                          );
                                        }

                                        Get.back();

                                        Get.snackbar(
                                          "Şikayetiniz alınmıştır.",
                                          "${c.user?["name"]} kullanıcısı bundan haberdar olmayacak.",
                                          backgroundColor: ColorManager.instance.white,
                                          duration: const Duration(seconds: 5),
                                        );
                                      },
                                      title: "Şikayet Et",
                                      textColor: ColorManager.instance.white,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            );
                          } else if (value == 1) {
                            await userController.addBlock("${c.user?["uid"]}");
                            Get.snackbar(
                              userController.blockedUsers.contains("${c.user?["uid"]}") ? "Engellendi" : "Engel kaldırıldı",
                              userController.blockedUsers.contains("${c.user?["uid"]}") ? "${c.user?["name"]} kullanıcısı engellendi." : "${c.user?["name"]} kullanıcısının engeli kaldırıldı.",
                              backgroundColor: ColorManager.instance.white,
                              duration: const Duration(seconds: 5),
                            );
                          }
                        },
                        itemBuilder: (BuildContext bc) {
                          return [
                            const PopupMenuItem(
                              value: 0,
                              child: Text("Şikayet Et"),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                userController.blockedUsers.contains("${c.user?["uid"]}") ? "Engeli Kaldır" : "Engelle",
                                style: TextStyle(
                                  color: ColorManager.instance.pink,
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                    centerTitle: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5000),
                          child: c.user?["images"] == null
                              ? SvgPicture.asset(
                                  "assets/svg/no_gender.svg",
                                  width: 30.w,
                                  height: 30.w,
                                  fit: BoxFit.cover,
                                )
                              : c.user?["images"] == []
                                  ? SvgPicture.asset(
                                      "assets/svg/no_gender.svg",
                                      width: 30.w,
                                      height: 30.w,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: c.user?["images"].first,
                                      width: 30.w,
                                      height: 30.w,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0.w),
                            child: Text(
                              c.user?["name"] ?? "",
                              style: TextStyle(
                                color: ColorManager.instance.secondary,
                                fontSize: 13.sp,
                                fontFamily: "Medium",
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 20,
                          bottom: 90,
                          child: SvgPicture.asset(
                            "assets/svg/logo.svg",
                          ),
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: c.scrollController,
                                itemCount: c.messages.length,
                                itemBuilder: (context, index) {
                                  bool senderIsme = c.messages[index]["receiver_uid"] == uid;
                                  return Align(
                                    alignment: senderIsme ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: senderIsme ? ColorManager.instance.pink : ColorManager.instance.very_light_pink.withOpacity(0.2),
                                              border: Border.all(
                                                color: senderIsme ? ColorManager.instance.pink : ColorManager.instance.very_light_pink.withOpacity(0.2),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topRight: senderIsme ? Radius.zero : const Radius.circular(12),
                                                topLeft: const Radius.circular(12),
                                                bottomRight: const Radius.circular(12),
                                                bottomLeft: senderIsme ? const Radius.circular(12) : Radius.zero,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                c.messages[index]["type"] == "text"
                                                    ? Text(
                                                        c.messages[index]["message"],
                                                        style: TextStyle(
                                                          color: senderIsme ? ColorManager.instance.white : ColorManager.instance.black,
                                                          fontSize: 15.sp,
                                                          fontFamily: "Regular",
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            UserController userController = Get.find();
                                                            if (userController.isPremium) {
                                                              Get.to(
                                                                () => FullScreenImage(
                                                                  imgUrl: c.messages[index]["message"],
                                                                ),
                                                              );
                                                            } else {
                                                              KBottomSheet.show(
                                                                context: context,
                                                                title: "Fotoğraf Görüntüleme",
                                                                content: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "Fotoğraf göndermek ve görüntülemek için premium kullanıcı olmanız gerekmektedir.",
                                                                      ),
                                                                    ),
                                                                    KButton(
                                                                      color: ColorManager.instance.pink,
                                                                      onTap: () {
                                                                        Navigator.pop(context);
                                                                        Get.to(
                                                                          () => const MarketPage(
                                                                            type: 2,
                                                                          ),
                                                                        );
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
                                                          child: GetBuilder<UserController>(
                                                            builder: (userController) {
                                                              if (userController.isPremium) {
                                                                return ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl: c.messages[index]["message"],
                                                                    height: 160,
                                                                    width: 160,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                );
                                                              } else {
                                                                return ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  clipBehavior: Clip.hardEdge,
                                                                  child: SizedBox(
                                                                    height: 160,
                                                                    width: 160,
                                                                    child: Stack(
                                                                      children: [
                                                                        CachedNetworkImage(
                                                                          imageUrl: c.messages[index]["message"],
                                                                          height: 160,
                                                                          width: 160,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                        BackdropFilter(
                                                                          filter: ImageFilter.blur(
                                                                            sigmaX: 4.0,
                                                                            sigmaY: 4.0,
                                                                          ),
                                                                          child: Container(
                                                                            color: ColorManager.instance.transparent,
                                                                            height: 160,
                                                                            width: 160,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 13.w),
                                          child: Text(
                                            DateFormat("hh.mm").format(DateTime.fromMillisecondsSinceEpoch(c.messages[index]["timestamp"])),
                                            style: TextStyle(
                                              color: ColorManager.instance.gray,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            userController.blockedUsers.contains(c.user?["uid"]) || c.isBlocked == true
                                ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: KTextFormField.instance.widget(
                                      context: context,
                                      fillColor: ColorManager.instance.white,
                                      readOnly: true,
                                      controller: TextEditingController(text: c.isBlocked == true ? "${c.user?["name"]} sizi engelledi." : "Engellediğiniz için mesaj gönderemezsiniz"),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: KTextFormField.instance.widget(
                                      context: context,
                                      fillColor: ColorManager.instance.white,
                                      controller: c.textEditingController,
                                      onFieldSubmitted: (value) => c.sendMessage(type: "text", message: value),
                                      labelText: "Mesaj yaz...",
                                      labelStyle: TextStyle(
                                        color: ColorManager.instance.pink,
                                      ),
                                      leadingIcon: IconButton(
                                        icon: Image.asset("assets/images/emoji.png"),
                                        onPressed: () {
                                          KBottomSheet.show(
                                            context: context,
                                            title: "Emoji Seç",
                                            content: Expanded(
                                              child: EmojiPicker(
                                                onEmojiSelected: (Category? category, Emoji emoji) {
                                                  Navigator.pop(context);
                                                  c.textEditingController.text = "${c.textEditingController.text}${emoji.emoji}";
                                                },
                                                onBackspacePressed: () {},
                                                textEditingController: c.textEmojiEditingController,
                                                config: Config(
                                                  columns: 7,
                                                  emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                                                  verticalSpacing: 0,
                                                  horizontalSpacing: 0,
                                                  gridPadding: EdgeInsets.zero,
                                                  initCategory: Category.RECENT,
                                                  bgColor: ColorManager.instance.white,
                                                  indicatorColor: ColorManager.instance.pink,
                                                  iconColor: Colors.grey,
                                                  iconColorSelected: ColorManager.instance.pink,
                                                  backspaceColor: ColorManager.instance.pink,
                                                  skinToneDialogBgColor: Colors.white,
                                                  skinToneIndicatorColor: Colors.grey,
                                                  enableSkinTones: true,
                                                  recentTabBehavior: RecentTabBehavior.RECENT,
                                                  recentsLimit: 28,
                                                  noRecents: const Text(
                                                    'Son Kullanılan Emoji Yok',
                                                    style: TextStyle(fontSize: 20, color: Colors.black26),
                                                    textAlign: TextAlign.center,
                                                  ), // Needs to be const Widget
                                                  loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
                                                  tabIndicatorAnimDuration: kTabScrollDuration,
                                                  categoryIcons: const CategoryIcons(),
                                                  buttonMode: ButtonMode.CUPERTINO,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            child: Image.asset("assets/images/gallery.png"),
                                            onTap: () {
                                              UserController userController = Get.find();
                                              if (userController.isPremium) {
                                                showCupertinoModalPopup<void>(
                                                  context: context,
                                                  builder: (BuildContext context) => CupertinoActionSheet(
                                                    title: const Text('Fotoğraf Gönderme'),
                                                    actions: <CupertinoActionSheetAction>[
                                                      CupertinoActionSheetAction(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          final ImagePicker picker = ImagePicker();
                                                          XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
                                                          String? downloadUrl = await uploadImage(image);
                                                          if (downloadUrl != "") {
                                                            c.sendMessage(isLiked: false, type: "image", message: downloadUrl!);
                                                          }
                                                        },
                                                        child: const Text('Kamera'),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          final ImagePicker picker = ImagePicker();
                                                          XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
                                                          String? downloadUrl = await uploadImage(image);
                                                          if (downloadUrl != null) {
                                                            if (downloadUrl != "") {
                                                              c.sendMessage(isLiked: false, type: "image", message: downloadUrl);
                                                            }
                                                          }
                                                        },
                                                        child: const Text('Galeri'),
                                                      ),
                                                      CupertinoActionSheetAction(
                                                        isDestructiveAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('Kapat'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                KBottomSheet.show(
                                                  context: context,
                                                  title: "Fotoğraf Görüntüleme",
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Fotoğraf göndermek ve görüntülemek için premium kullanıcı olmanız gerekmektedir.",
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
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12, right: 12),
                                            child: InkWell(
                                              child: Image.asset("assets/images/send.png"),
                                              onTap: () {
                                                c.sendMessage(type: "text", message: c.textEditingController.text);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
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
    );
  }
}
