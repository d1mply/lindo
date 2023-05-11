import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/chat_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/k_textformfield.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({required this.uid, super.key});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(uid),
      builder: (c) {
        return Container(
          color: ColorManager.instance.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: ColorManager.instance.greyBG,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: ColorManager.instance.secondary,
                  ),
                  onPressed: () => Get.back(),
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
                                  Text(
                                    c.messages[index]["message"],
                                    style: TextStyle(
                                      color: senderIsme ? ColorManager.instance.white : ColorManager.instance.black,
                                      fontSize: 14.sp,
                                      fontFamily: "Regular",
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
                      onFieldSubmitted: (value) => c.sendMessage(),
                      labelText: "Mesaj gönder",
                      leadingIcon: IconButton(
                        icon: Icon(
                          Icons.image,
                          color: ColorManager.instance.primary,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          c.sendMessage();
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
            ),
          ),
        );
      },
    );
  }
}
