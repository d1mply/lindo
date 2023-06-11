import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:story_view/story_view.dart';
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

class SwipePage extends GetView<SwipeController> {
  const SwipePage({super.key});

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
                        c.controller.unswipe();
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
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: AppinioSwiper(
                                controller: c.controller,
                                cardsCount: c.usersList.length,
                                isDisabled: !swipaAble,
                                direction: AppinioSwiperDirection.right,
                                swipeOptions: AppinioSwipeOptions.allDirections,
                                onSwipe: (index, direction) {
                                  if (direction.name == "right") {
                                    swipeRight(c.usersList[index - 1]["uid"], context, c);
                                  }
                                  if (direction.name == "top") {
                                    addNotification(
                                      c.usersList[index - 1]["uid"],
                                      "Eşleşme sayfasında profilinizi görüntüledi.",
                                    );
                                    StoryController controller = StoryController();

                                    List<StoryItem> storyItems = [];
                                    if (c.usersList[index - 1]["images"] != null) {
                                      List items = c.usersList[index - 1]["images"];
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
                                                    c.usersList[index - 1]["name"],
                                                    style: TextStyle(
                                                      color: ColorManager.instance.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${DateTime.now().year - int.parse(c.usersList[index - 1]["birth"].toString().split("-").first.toString())}",
                                                    style: TextStyle(
                                                      color: ColorManager.instance.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            c.usersList[index - 1]["location"] != null
                                                ? Text(
                                                    c.usersList[index - 1]["location"],
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
                                                    () => ChatPage(uid: c.usersList[index - 1]["uid"]),
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
                                              controller: TextEditingController()..text = "${c.usersList[index - 1]["bio"] ?? ""}",
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
                                                      desc: c.usersList[index - 1]["height"] == null ? "" : "${c.usersList[index - 1]["height"]} cm",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/weight.png",
                                                      title: "Ağırlık",
                                                      desc: c.usersList[index - 1]["weight"] == null ? "" : "${c.usersList[index - 1]["weight"]} kg",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/smoking.png",
                                                      title: "Sigara",
                                                      desc: c.usersList[index - 1]["smoking"] == null ? "" : "${c.usersList[index - 1]["smoking"]}",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/wine-bottle.png",
                                                      title: "Alkol",
                                                      desc: c.usersList[index - 1]["wine-bottle"] == null ? "" : "${c.usersList[index - 1]["wine-bottle"]}",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/heart.png",
                                                      title: "İlişki Beklentim",
                                                      desc: c.usersList[index - 1]["hearth"] == null ? "" : "${c.usersList[index - 1]["hearth"]}",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/gender.png",
                                                      title: "Cinsellik",
                                                      desc: c.usersList[index - 1]["sex"] == null ? "" : "${c.usersList[index - 1]["sex"]}",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/personality.png",
                                                      title: "Kişilik",
                                                      desc: c.usersList[index - 1]["personality"] == null ? "" : "${c.usersList[index - 1]["personality"]}",
                                                      onTap: () {},
                                                    ),
                                                    Info(
                                                      img: "assets/images/money.png",
                                                      title: "İlgi Alanları",
                                                      desc: c.usersList[index - 1]["money"] == null ? "" : "${c.usersList[index - 1]["money"]}",
                                                      onTap: () {},
                                                    ),
                                                    GetBuilder<UserController>(
                                                      builder: (userController) {
                                                        return Info(
                                                          img: "assets/images/insta.png",
                                                          title: "Instagram",
                                                          desc: c.usersList[index - 1]["instagram"] == null
                                                              ? ""
                                                              : userController.isPremium == false
                                                                  ? "@*********"
                                                                  : "${c.usersList[index - 1]["instagram"]}",
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
                                                                            "Şikayetinizden ${c.usersList[index - 1]["name"]} kullanıcısının haberi olmayacak.",
                                                                            style: TextStyle(color: ColorManager.instance.secondary),
                                                                          ),
                                                                        ),
                                                                        KButton(
                                                                          color: ColorManager.instance.pink,
                                                                          onTap: () async {
                                                                            if (con.text.isNotEmpty) {
                                                                              UserController userController = Get.find();
                                                                              await userController.report(
                                                                                "${c.usersList[index - 1]["uid"]}",
                                                                                con.text,
                                                                              );
                                                                            }

                                                                            Get.back();
                                                                            Get.back();
                                                                            Get.snackbar(
                                                                              "Şikayetiniz alınmıştır.",
                                                                              "${c.usersList[index - 1]["name"]} kullanıcısı bundan haberdar olmayacak.",
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
                                                                      await userController.addBlock("${c.usersList[index - 1]["uid"]}");
                                                                      Get.back();
                                                                      Get.back();
                                                                      Get.snackbar(
                                                                        !userController.blockedUsers.contains("${c.usersList[index - 1]["uid"]}") ? "Engellendi" : "Engel kaldırıldı",
                                                                        !userController.blockedUsers.contains("${c.usersList[index - 1]["uid"]}") ? "${c.usersList[index - 1]["name"]} kullanıcısı engellendi." : "${c.usersList[index - 1]["name"]} kullanıcısının engeli kaldırıldı.",
                                                                        backgroundColor: ColorManager.instance.white,
                                                                        duration: const Duration(seconds: 5),
                                                                      );
                                                                    },
                                                                    title: userController.blockedUsers.contains("${c.usersList[index - 1]["uid"]}") ? "Engeli Kaldır" : "Engelle",
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
                                  if (index == c.usersList.length) {
                                    c.getMoreUsers();
                                  }
                                  c.update();
                                },
                                cardsBuilder: (BuildContext context, index) {
                                  return Stack(
                                    children: [
                                      c.usersList.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: SizedBox(
                                                height: Get.height,
                                                width: Get.width,
                                                child: Story(
                                                  images: c.usersList[index]["images"],
                                                  name: c.usersList[index]["name"],
                                                  age: c.usersList[index]["birth"],
                                                  show: c.usersList[index]["kk"],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Showcase(
                            key: two,
                            descriptionAlignment: TextAlign.center,
                            description: "Fotoğraflar arasında geçiş yapmak için sağa veya sola kaydır.",
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                color: ColorManager.instance.transparent,
                                width: Get.width / 2,
                                height: Get.height / 2,
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
  });
  final dynamic images;
  final String? name, age;
  final bool? show;

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
                          SwipeController c = Get.find();
                          c.controller.swipeLeft();
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
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (swipaAble) {
                            SwipeController c = Get.find();
                            c.controller.swipeRight();
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
