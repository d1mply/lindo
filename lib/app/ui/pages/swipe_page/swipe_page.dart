
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:story_view/story_view.dart' as stry;
import 'package:swipe_stack_null_safe/swipe_stack_null_safe.dart';
import '../../../../core/base/state.dart';
import '../../../../core/init/cache/cache_manager.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/explore_controller.dart';
import '../../../controllers/swipe_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../controllers/usercontroller.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/k_bottom_sheet.dart';
import '../../utils/k_button.dart';
import '../../utils/k_textformfield.dart';
import '../chat_page/chat_page.dart';
import '../explore_page/explore_page.dart';
import '../market_page/market_page.dart';
import '../profile_page/profile_page.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

final GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();

class _SwipePageState extends State<SwipePage> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        CacheManager.instance.setValue("showCased", true);
      },
      onComplete: (p0, p1) {
        CacheManager.instance.setValue("showCased", true);
      },
      builder: Builder(
        builder: (context) {
          return GetBuilder<SwipeController>(
            init: SwipeController(context),
            builder: (c) {
              return Scaffold(
                backgroundColor: ColorManager.instance.background_gray,
                appBar: AppBar(
                  leading: Showcase(
                    key: one,
                    targetBorderRadius: BorderRadius.circular(500),
                    description: "Bir önceki seçimi geri alabilmek için bu butona tıklayabilirsin.",
                    child: IconButton(
                      onPressed: () {
                        swipeKey.currentState?.rewind();
                      },
                      icon: SvgPicture.asset(
                        "assets/svg/undo.svg",
                      ),
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: ColorManager.instance.background_gray,
                  actions: const [
                    ShopWidget(),
                  ],
                  title: Image.asset(
                    "assets/images/lindo.png",
                    width: 79,
                    height: 54,
                  ),
                ),
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: SwipeStack(
                          key: swipeKey,
                          visibleCount: 10,
                          onSwipe: (int index, SwiperPosition position) {
                            if (position == SwiperPosition.Right) {
                              swipeRight(c.usersList[index]["uid"], context);
                            }
                          },
                          children: c.cards.map(
                            (e) {
                              return SwiperItem(
                                builder: (p0, progress) {
                                  return e;
                                },
                              );
                            },
                          ).toList(),
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
    );
  }
}

class Story extends StatefulWidget {
  const Story({
    super.key,
    required this.images,
    this.age,
    this.name,
    required this.show,
    required this.user,
  });
  final dynamic images;
  final String? name, age;
  final bool? show;
  final Map<dynamic, dynamic> user;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    if (widget.images == null) {
      return const SizedBox();
    }
    if (widget.images.length == 0) {
      return const SizedBox();
    }
    return GetBuilder<SwipeController>(
      builder: (c) {
        return Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: ColorManager.instance.gray.withOpacity(1),
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.images?.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return widget.images != null
                      ? CachedNetworkImage(
                          imageUrl: widget.images?[index] ?? "",
                          fit: BoxFit.cover,
                        )
                      : const SizedBox();
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.linear);
                      },
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width / 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pageController.nextPage(duration: const Duration(milliseconds: 150), curve: Curves.linear);
                      },
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width / 2,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SmoothPageIndicator(
                        controller: pageController,
                        count: widget.images?.length ?? 0,
                        effect: ScrollingDotsEffect(
                          dotColor: ColorManager.instance.gray,
                          activeDotColor: ColorManager.instance.white,
                          dotHeight: Utility.dynamicWidthPixel(2),
                          dotWidth: Utility.dynamicWidthPixel(70),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name ?? "",
                              style: TextStyle(
                                color: ColorManager.instance.white,
                                fontSize: 17,
                                fontFamily: "Rubik-Medium",
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              widget.age != null ? "${DateTime.now().year - int.parse(widget.age.toString().split("-").first.toString())}" : "",
                              style: TextStyle(
                                color: ColorManager.instance.white,
                                fontSize: 17,
                                fontFamily: "Rubik-Medium",
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 26,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          swipeKey.currentState?.swipeLeft();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorManager.instance.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset("assets/svg/love_off.svg"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.chevron_up,
                          color: ColorManager.instance.white,
                        ),
                        onPressed: () {
                          addNotification(
                            widget.user["uid"],
                            "Eşleşme sayfasında profilinizi görüntüledi.",
                          );
                          stry.StoryController controller = stry.StoryController();

                          List<stry.StoryItem> storyItems = [];
                          if (widget.user["images"] != null) {
                            List items = widget.user["images"];
                            for (var e in items) {
                              storyItems.add(
                                stry.StoryItem.inlineImage(
                                  url: e,
                                  controller: stry.StoryController(),
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
                                            child: stry.StoryView(
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
                                          widget.user["name"],
                                          style: TextStyle(
                                            color: ColorManager.instance.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${DateTime.now().year - int.parse(widget.user["birth"].toString().split("-").first.toString())}",
                                          style: TextStyle(
                                            color: ColorManager.instance.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.user["location"] != null
                                      ? Text(
                                          widget.user["location"],
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
                                          () => ChatPage(uid: widget.user["uid"]),
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
                                    controller: TextEditingController()..text = "${widget.user["bio"] ?? ""}",
                                    maxLines: 5,
                                    minLines: 1,
                                  ),
                                  Container(
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
                                            desc: widget.user["height"] == null ? "" : "${widget.user["height"]} cm",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/weight.png",
                                            title: "Ağırlık",
                                            desc: widget.user["weight"] == null ? "" : "${widget.user["weight"]} kg",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/smoking.png",
                                            title: "Sigara",
                                            desc: widget.user["smoking"] == null ? "" : "${widget.user["smoking"]}",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/wine-bottle.png",
                                            title: "Alkol",
                                            desc: widget.user["wine-bottle"] == null ? "" : "${widget.user["wine-bottle"]}",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/heart.png",
                                            title: "İlişki Beklentim",
                                            desc: widget.user["hearth"] == null ? "" : "${widget.user["hearth"]}",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/gender.png",
                                            title: "Cinsellik",
                                            desc: widget.user["sex"] == null ? "" : "${widget.user["sex"]}",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/personality.png",
                                            title: "Kişilik",
                                            desc: widget.user["personality"] == null ? "" : "${widget.user["personality"]}",
                                            onTap: () {},
                                          ),
                                          Info(
                                            img: "assets/images/money.png",
                                            title: "İlgi Alanları",
                                            desc: widget.user["money"] == null ? "" : "${widget.user["money"]}",
                                            onTap: () {},
                                          ),
                                          GetBuilder<UserController>(
                                            builder: (userController) {
                                              return Info(
                                                img: "assets/images/insta.png",
                                                title: "Instagram",
                                                desc: widget.user["instagram"] == null
                                                    ? ""
                                                    : userController.isPremium == false
                                                        ? "@*********"
                                                        : "${widget.user["instagram"]}",
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
                                                                  "Şikayetinizden ${widget.user["name"]} kullanıcısının haberi olmayacak.",
                                                                  style: TextStyle(color: ColorManager.instance.secondary),
                                                                ),
                                                              ),
                                                              KButton(
                                                                color: ColorManager.instance.pink,
                                                                onTap: () async {
                                                                  if (con.text.isNotEmpty) {
                                                                    UserController userController = Get.find();
                                                                    await userController.report(
                                                                      "${widget.user["uid"]}",
                                                                      con.text,
                                                                    );
                                                                  }

                                                                  Get.back();
                                                                  Get.back();
                                                                  Get.snackbar(
                                                                    "Şikayetiniz alınmıştır.",
                                                                    "${widget.user["name"]} kullanıcısı bundan haberdar olmayacak.",
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
                                                            await userController.addBlock("${widget.user["uid"]}");
                                                            Get.back();
                                                            Get.back();
                                                            Get.snackbar(
                                                              !userController.blockedUsers.contains("${widget.user["uid"]}") ? "Engellendi" : "Engel kaldırıldı",
                                                              !userController.blockedUsers.contains("${widget.user["uid"]}") ? "${widget.user["name"]} kullanıcısı engellendi." : "${widget.user["name"]} kullanıcısının engeli kaldırıldı.",
                                                              backgroundColor: ColorManager.instance.white,
                                                              duration: const Duration(seconds: 5),
                                                            );
                                                          },
                                                          title: userController.blockedUsers.contains("${widget.user["uid"]}") ? "Engeli Kaldır" : "Engelle",
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
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (swipaAble) {
                            swipeKey.currentState?.swipeRight();
                          } else {
                            KBottomSheet.show(
                              context: context,
                              title: "Kaydırma",
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Premium olmayan kullanıcılar günde sadece 6 tane sağa kaydırma yapabilir. Daha fazla kaydırma yapabilmek için premium olmalısınız.",
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
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorManager.instance.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset("assets/svg/love.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
