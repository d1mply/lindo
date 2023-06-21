import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/app/ui/utils/k_bottom_sheet.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/chat_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../controllers/messages_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../global_widgets/full_screen_image.dart';
import '../../utils/k_button.dart';
import '../../utils/k_textformfield.dart';
import '../market_page/market_page.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({required this.uid, super.key});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.instance.white,
      child: SafeArea(
        child: GetBuilder<ChatController>(
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
                      print("sssss");
                      Get.back();
                    },
                  ),
                  elevation: 1,
                  actions: [
                    IconButton(
                      icon: SvgPicture.asset("assets/svg/more_vertical.svg"),
                      onPressed: () {},
                    )
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
                body: Column(
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
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: senderIsme ? ColorManager.instance.mor : ColorManager.instance.white,
                                  border: Border.all(
                                    color: senderIsme ? ColorManager.instance.mor : ColorManager.instance.white,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: const Radius.circular(16),
                                    topLeft: const Radius.circular(16),
                                    bottomRight: senderIsme ? Radius.zero : const Radius.circular(16),
                                    bottomLeft: senderIsme ? const Radius.circular(16) : Radius.zero,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    c.messages[index]["type"] == "text"
                                        ? Text(
                                            c.messages[index]["message"],
                                            style: TextStyle(
                                              color: senderIsme ? ColorManager.instance.white : ColorManager.instance.black,
                                              fontSize: 14.sp,
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
                                    Text(
                                      timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(c.messages[index]["timestamp"]),
                                        locale: "tr",
                                      ),
                                      style: TextStyle(
                                        color: senderIsme ? ColorManager.instance.spacer_gray : ColorManager.instance.gray,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: KTextFormField.instance.widget(
                        context: context,
                        fillColor: ColorManager.instance.white,
                        controller: c.textEditingController,
                        onFieldSubmitted: (value) => c.sendMessage(type: "text", message: value),
                        labelText: "Mesaj gönder",
                        leadingIcon: IconButton(
                          icon: Icon(
                            Icons.image,
                            color: ColorManager.instance.primary,
                          ),
                          onPressed: () {
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
                                        if (downloadUrl != "") {
                                          c.sendMessage(isLiked: false, type: "image", message: downloadUrl!);
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
                            }
                          },
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            c.sendMessage(type: "text", message: c.textEditingController.text);
                          },
                          icon: SvgPicture.asset(
                            "assets/svg/send.svg",
                            color: ColorManager.instance.mor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
