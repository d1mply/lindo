import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/app/ui/pages/chat_page/chat_page.dart';
import 'package:lindo/app/ui/pages/market_page/market_page.dart';
import 'package:lindo/app/ui/pages/notification_page/notification_page.dart';
import 'package:lindo/app/ui/utils/custom_dialog.dart';
import 'package:lindo/app/ui/utils/k_textformfield.dart';
import 'package:lindo/core/base/state.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:story_view/story_view.dart';
import '../../../controllers/explore_controller.dart';
import '../../utils/k_bottom_sheet.dart';
import '../../utils/k_button.dart';
import '../profile_page/profile_page.dart';

class ExplorePage extends GetView<ExploreController> {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExploreController>(
      init: ExploreController(),
      autoRemove: false,
      builder: (c) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(context, screen: const NotificationPage(), withNavBar: false);
                      },
                      child: Image.asset(
                        "assets/images/notification.png",
                        height: 26,
                        width: 26,
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(
                        "assets/images/settings.png",
                        height: 24,
                        width: 24,
                      ),
                      onPressed: () {
                        UserController userController = Get.find();
                        if (!userController.isPremium) {
                          KBottomSheet.show(
                            context: context,
                            title: "Filtrele",
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Yaş, Şehir, Cinsiyet filtrelemesi yapabilmek için premium hesaba geçiş yapmanız gerekmektedir.",
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
                        } else {
                          KBottomSheet.show(
                            context: context,
                            title: "Filtrele",
                            content: GetBuilder<ExploreController>(
                              init: ExploreController(),
                              autoRemove: false,
                              builder: (c) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Sadece doğrulanmış hesaplar",
                                                style: TextStyle(color: ColorManager.instance.softBlack),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6),
                                                child: Image.asset(
                                                  "assets/images/tick-circle.png",
                                                  height: 18,
                                                  width: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        FlutterSwitch(
                                          width: 55,
                                          height: 30,
                                          toggleSize: 30,
                                          value: c.onlyValidatedUsers,
                                          borderRadius: 30,
                                          toggleColor: ColorManager.instance.pink,
                                          activeColor: ColorManager.instance.pink.withOpacity(0.3),
                                          inactiveColor: ColorManager.instance.pink.withOpacity(0.1),
                                          padding: 3.0,
                                          showOnOff: false,
                                          onToggle: (val) {
                                            c.onlyValidatedUsers = val;
                                            c.update();
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: Text(
                                              "Yaş aralığı (${c.currentRangeValue.start.round()}-${c.currentRangeValue.end.round()})",
                                              style: TextStyle(color: ColorManager.instance.softBlack),
                                            ),
                                          ),
                                        ),
                                        RangeSlider(
                                          values: c.currentRangeValue,
                                          min: 18,
                                          max: 100,
                                          divisions: 82,
                                          activeColor: ColorManager.instance.pink,
                                          inactiveColor: ColorManager.instance.pink.withOpacity(0.3),
                                          labels: RangeLabels(
                                            c.currentRangeValue.start.round().toString(),
                                            c.currentRangeValue.end.round().toString(),
                                          ),
                                          onChanged: (RangeValues values) {
                                            c.currentRangeValue = values;
                                            c.update();
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: Text(
                                              "Bulunduğu Şehir",
                                              style: TextStyle(color: ColorManager.instance.softBlack),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (_) => StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Material(
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            width: double.infinity,
                                                            color: ColorManager.instance.gray_spacer,
                                                            child: Padding(
                                                              padding: EdgeInsets.all(Utility.dynamicWidthPixel(16)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(context, rootNavigator: true).pop("Discard");
                                                                      c.selectedCity = null;
                                                                      c.update();
                                                                    },
                                                                    child: Text(
                                                                      'Temizle',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(context, rootNavigator: true).pop("Discard");
                                                                    },
                                                                    child: Text(
                                                                      "Tamam",
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.darkGray,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: const BoxDecoration(),
                                                            width: double.infinity,
                                                            height: Utility.dynamicHeightPixel(250),
                                                            child: CupertinoPicker(
                                                              backgroundColor: ColorManager.instance.white,
                                                              itemExtent: 30,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: c.cities.map((item) => Text(item)).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                setState(
                                                                  () {
                                                                    c.selectedCity = c.cities[value];
                                                                    c.update();
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorManager.instance.pink,
                                              ),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              c.selectedCity ?? "Şehir Seç",
                                              style: TextStyle(
                                                color: ColorManager.instance.pink,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: Text(
                                              "Cinsiyet",
                                              style: TextStyle(color: ColorManager.instance.softBlack),
                                            ),
                                          ),
                                        ),
                                        ToggleButtons(
                                          fillColor: ColorManager.instance.pink,
                                          isSelected: c.genderSelections,
                                          onPressed: (index) {
                                            if (index == 0) {
                                              if (c.genderSelections[0] == true) {
                                                c.genderSelections[0] = false;
                                              } else {
                                                c.genderSelections[0] = true;
                                              }
                                              c.update();
                                            }
                                            if (index == 1) {
                                              if (c.genderSelections[1] == true) {
                                                c.genderSelections[1] = false;
                                              } else {
                                                c.genderSelections[1] = true;
                                              }
                                              c.update();
                                            }
                                          },
                                          children: [
                                            Text(
                                              "Kadın",
                                              style: TextStyle(
                                                color: c.genderSelections[0] == true ? ColorManager.instance.white : ColorManager.instance.pink,
                                              ),
                                            ),
                                            Text(
                                              "Erkek",
                                              style: TextStyle(
                                                color: c.genderSelections[1] == true ? ColorManager.instance.white : ColorManager.instance.pink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: Utility.dynamicWidthPixel(35),
                                        bottom: Utility.dynamicWidthPixel(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          KButton(
                                            color: ColorManager.instance.white,
                                            onTap: () {
                                              c.selectedCity = null;
                                              c.genderSelections = [false, false];
                                              c.currentRangeValue = const RangeValues(18, 100);
                                              c.onlyValidatedUsers = false;
                                              c.minAge = 18;
                                              c.maxAge = 100;
                                              c.selectedOnlyValidatedUsers = false;
                                              c.pageSize = 8;
                                              c.update();
                                            },
                                            title: "Temizle",
                                            borderColor: ColorManager.instance.border_color,
                                            textColor: ColorManager.instance.gridGray,
                                          ),
                                          KButton(
                                            color: ColorManager.instance.pink,
                                            onTap: () async {
                                              Navigator.pop(context);
                                              c.minAge = c.currentRangeValue.start.floor();
                                              c.maxAge = c.currentRangeValue.end.floor();
                                              c.selectedGenderSelections = c.genderSelections;
                                              c.selectedOnlyValidatedUsers = c.onlyValidatedUsers;
                                              c.pageSize = 100;
                                              await c.getUsers();
                                            },
                                            title: "Filtrele",
                                            borderColor: ColorManager.instance.pink,
                                            textColor: ColorManager.instance.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: (Get.width / 2) - 100),
                  child: Image.asset(
                    "assets/images/lindo.png",
                    width: 79,
                    height: 54,
                  ),
                ),
              ],
            ),
            actions: const [
              ShopWidget(),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                c.boostedUsers.isEmpty
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Öne Çıkanlar",
                              style: TextStyle(
                                color: ColorManager.instance.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: "Rubik-Medium",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 160,
                            width: Get.width,
                            child: ListView.builder(
                              itemCount: c.boostedUsers.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 160,
                                  width: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: () {
                                        addNotification(
                                          c.boostedUsers[index]["uid"],
                                          "Keşfette profilinizi görüntüledi.",
                                        );
                                        StoryController controller = StoryController();

                                        List<StoryItem> storyItems = [];
                                        if (c.boostedUsers[index]["images"] != null) {
                                          List items = c.boostedUsers[index]["images"];
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
                                            child: GetBuilder<UserController>(
                                              builder: (userController) {
                                                return Column(
                                                  children: [
                                                    storyItems.isNotEmpty
                                                        ? userController.isPremium
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
                                                            : InkWell(
                                                                onTap: () {
                                                                  Get.to(() => const MarketPage());
                                                                },
                                                                child: const Text("Kullanıcı görsellerini sadece premium kullanıcılar görüntüleyebilir. Premium olmak için tıkla."),
                                                              )
                                                        : const SizedBox(),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            c.boostedUsers[index]["name"] ?? "",
                                                            style: TextStyle(
                                                              color: ColorManager.instance.black,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${c.boostedUsers[index]["birthTimestamp"] == null ? "" : (DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(c.boostedUsers[index]["birthTimestamp"]).year)}",
                                                            style: TextStyle(
                                                              color: ColorManager.instance.black,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    c.boostedUsers[index]["location"] != null
                                                        ? Text(
                                                            c.boostedUsers[index]["location"],
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
                                                            () => ChatPage(uid: c.boostedUsers[index]["uid"]),
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
                                                      controller: TextEditingController()..text = "${c.boostedUsers[index]["bio"] ?? ""}",
                                                      maxLines: 5,
                                                      minLines: 1,
                                                    ),
                                                    c.boostedUsers[index]["tags"] != null
                                                        ? Wrap(
                                                            spacing: 10,
                                                            runSpacing: 10,
                                                            children: c.boostedUsers[index]["tags"].map(
                                                              (e) {
                                                                return Chip(
                                                                  label: Text("#$e"),
                                                                );
                                                              },
                                                            ).toList(),
                                                          )
                                                        : const SizedBox(),
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
                                                              desc: c.boostedUsers[index]["height"] == null ? "" : "${c.boostedUsers[index]["height"]} cm",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/weight.png",
                                                              title: "Ağırlık",
                                                              desc: c.boostedUsers[index]["weight"] == null ? "" : "${c.boostedUsers[index]["weight"]} kg",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/smoking.png",
                                                              title: "Sigara",
                                                              desc: c.boostedUsers[index]["smoking"] == null ? "" : "${c.boostedUsers[index]["smoking"]}",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/wine-bottle.png",
                                                              title: "Alkol",
                                                              desc: c.boostedUsers[index]["wine-bottle"] == null ? "" : "${c.boostedUsers[index]["wine-bottle"]}",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/heart.png",
                                                              title: "İlişki Beklentim",
                                                              desc: c.boostedUsers[index]["hearth"] == null ? "" : "${c.boostedUsers[index]["hearth"]}",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/gender.png",
                                                              title: "Cinsellik",
                                                              desc: c.boostedUsers[index]["sex"] == null ? "" : "${c.boostedUsers[index]["sex"]}",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/personality.png",
                                                              title: "Kişilik",
                                                              desc: c.boostedUsers[index]["personality"] == null ? "" : "${c.boostedUsers[index]["personality"]}",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/money.png",
                                                              title: "İlgi Alanları",
                                                              desc: c.boostedUsers[index]["money"] == null ? "" : "${c.boostedUsers[index]["money"]}",
                                                              onTap: () {},
                                                            ),
                                                            Info(
                                                              img: "assets/images/insta.png",
                                                              title: "Instagram",
                                                              desc: c.boostedUsers[index]["instagram"] == null
                                                                  ? ""
                                                                  : userController.isPremium == false
                                                                      ? "@*********"
                                                                      : "${c.boostedUsers[index]["instagram"]}",
                                                              onTap: () {
                                                                if (userController.isPremium == false) {
                                                                  Get.to(() => const MarketPage());
                                                                }
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
                                                                                    "Şikayetinizden ${c.boostedUsers[index]["name"]} kullanıcısının haberi olmayacak.",
                                                                                    style: TextStyle(color: ColorManager.instance.secondary),
                                                                                  ),
                                                                                ),
                                                                                KButton(
                                                                                  color: ColorManager.instance.pink,
                                                                                  onTap: () async {
                                                                                    if (con.text.isNotEmpty) {
                                                                                      UserController userController = Get.find();
                                                                                      await userController.report(
                                                                                        "${c.boostedUsers[index]["uid"]}",
                                                                                        con.text,
                                                                                      );
                                                                                    }

                                                                                    Get.back();
                                                                                    Get.back();
                                                                                    Get.snackbar(
                                                                                      "Şikayetiniz alınmıştır.",
                                                                                      "${c.boostedUsers[index]["name"]} kullanıcısı bundan haberdar olmayacak.",
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
                                                                              await userController.addBlock("${c.boostedUsers[index]["uid"]}");
                                                                              Get.back();
                                                                              Get.back();
                                                                              Get.snackbar(
                                                                                !userController.blockedUsers.contains("${c.boostedUsers[index]["uid"]}") ? "Engellendi" : "Engel kaldırıldı",
                                                                                !userController.blockedUsers.contains("${c.boostedUsers[index]["uid"]}") ? "${c.boostedUsers[index]["name"]} kullanıcısı engellendi." : "${c.boostedUsers[index]["name"]} kullanıcısının engeli kaldırıldı.",
                                                                                backgroundColor: ColorManager.instance.white,
                                                                                duration: const Duration(seconds: 5),
                                                                              );
                                                                            },
                                                                            title: userController.blockedUsers.contains("${c.boostedUsers[index]["uid"]}") ? "Engeli Kaldır" : "Engelle",
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
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: GetBuilder<UserController>(
                                        builder: (userController) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorManager.instance.pink,
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                              color: ColorManager.instance.gridGray,
                                            ),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: c.boostedUsers[index]["images"] == null
                                                      ? Image.asset(
                                                          "assets/images/camera-slash.png",
                                                          height: 40,
                                                          width: 40,
                                                        )
                                                      : userController.isPremium == false
                                                          ? Center(
                                                              child: ClipRRect(
                                                                clipBehavior: Clip.hardEdge,
                                                                borderRadius: BorderRadius.circular(20),
                                                                child: Stack(
                                                                  children: [
                                                                    CachedNetworkImage(
                                                                      imageUrl: c.boostedUsers[index]["images"].first,
                                                                      height: 202,
                                                                      width: Get.width,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    BackdropFilter(
                                                                      filter: ImageFilter.blur(
                                                                        sigmaX: 8.0,
                                                                        sigmaY: 8.0,
                                                                      ),
                                                                      child: Container(
                                                                        color: Colors.transparent,
                                                                        width: Get.width,
                                                                        height: 202,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(20),
                                                              child: CachedNetworkImage(
                                                                imageUrl: c.boostedUsers[index]["images"].first,
                                                                height: 202,
                                                                width: Get.width,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              c.boostedUsers[index]["name"] ?? "",
                                                              style: TextStyle(
                                                                color: ColorManager.instance.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${c.boostedUsers[index]["birthTimestamp"] == null ? "" : (DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(c.boostedUsers[index]["birthTimestamp"]).year)}",
                                                            style: TextStyle(
                                                              color: ColorManager.instance.white,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      c.boostedUsers[index]["location"] != null
                                                          ? Text(
                                                              c.boostedUsers[index]["location"],
                                                              style: TextStyle(
                                                                color: ColorManager.instance.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                Expanded(
                  child: GridView.builder(
                    controller: c.scrollController,
                    itemCount: c.usersList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      mainAxisExtent: 202,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            addNotification(
                              c.usersList[index]["uid"],
                              "Keşfette profilinizi görüntüledi.",
                            );
                            StoryController controller = StoryController();

                            List<StoryItem> storyItems = [];
                            if (c.usersList[index]["images"] != null) {
                              List items = c.usersList[index]["images"];
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
                                child: GetBuilder<UserController>(
                                  builder: (userController) {
                                    return Column(
                                      children: [
                                        storyItems.isNotEmpty
                                            ? userController.isPremium
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
                                                : InkWell(
                                                    onTap: () {
                                                      Get.to(() => const MarketPage());
                                                    },
                                                    child: const Text("Kullanıcı görsellerini sadece premium kullanıcılar görüntüleyebilir. Premium olmak için tıkla."),
                                                  )
                                            : const SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                c.usersList[index]["name"] ?? "",
                                                style: TextStyle(
                                                  color: ColorManager.instance.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "${c.usersList[index]["birthTimestamp"] == null ? "" : (DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(c.usersList[index]["birthTimestamp"]).year)}",
                                                style: TextStyle(
                                                  color: ColorManager.instance.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        c.usersList[index]["location"] != null
                                            ? Text(
                                                c.usersList[index]["location"],
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
                                                () => ChatPage(uid: c.usersList[index]["uid"]),
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
                                          controller: TextEditingController()..text = "${c.usersList[index]["bio"] ?? ""}",
                                          maxLines: 5,
                                          minLines: 1,
                                        ),
                                        c.usersList[index]["tags"] != null
                                            ? Wrap(
                                                spacing: 10,
                                                runSpacing: 10,
                                                children: c.usersList[index]["tags"].map(
                                                  (e) {
                                                    return Chip(
                                                      label: Text("#$e"),
                                                    );
                                                  },
                                                ).toList(),
                                              )
                                            : const SizedBox(),
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
                                                  desc: c.usersList[index]["height"] == null ? "" : "${c.usersList[index]["height"]} cm",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/weight.png",
                                                  title: "Ağırlık",
                                                  desc: c.usersList[index]["weight"] == null ? "" : "${c.usersList[index]["weight"]} kg",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/smoking.png",
                                                  title: "Sigara",
                                                  desc: c.usersList[index]["smoking"] == null ? "" : "${c.usersList[index]["smoking"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/wine-bottle.png",
                                                  title: "Alkol",
                                                  desc: c.usersList[index]["wine-bottle"] == null ? "" : "${c.usersList[index]["wine-bottle"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/heart.png",
                                                  title: "İlişki Beklentim",
                                                  desc: c.usersList[index]["hearth"] == null ? "" : "${c.usersList[index]["hearth"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/gender.png",
                                                  title: "Cinsellik",
                                                  desc: c.usersList[index]["sex"] == null ? "" : "${c.usersList[index]["sex"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/personality.png",
                                                  title: "Kişilik",
                                                  desc: c.usersList[index]["personality"] == null ? "" : "${c.usersList[index]["personality"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/money.png",
                                                  title: "İlgi Alanları",
                                                  desc: c.usersList[index]["money"] == null ? "" : "${c.usersList[index]["money"]}",
                                                  onTap: () {},
                                                ),
                                                Info(
                                                  img: "assets/images/insta.png",
                                                  title: "Instagram",
                                                  desc: c.usersList[index]["instagram"] == null
                                                      ? ""
                                                      : userController.isPremium == false
                                                          ? "@*********"
                                                          : "${c.usersList[index]["instagram"]}",
                                                  onTap: () {
                                                    if (userController.isPremium == false) {
                                                      Get.to(() => const MarketPage());
                                                    }
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
                                                                        "Şikayetinizden ${c.usersList[index]["name"]} kullanıcısının haberi olmayacak.",
                                                                        style: TextStyle(color: ColorManager.instance.secondary),
                                                                      ),
                                                                    ),
                                                                    KButton(
                                                                      color: ColorManager.instance.pink,
                                                                      onTap: () async {
                                                                        if (con.text.isNotEmpty) {
                                                                          UserController userController = Get.find();
                                                                          await userController.report(
                                                                            "${c.usersList[index]["uid"]}",
                                                                            con.text,
                                                                          );
                                                                        }

                                                                        Get.back();
                                                                        Get.back();
                                                                        Get.snackbar(
                                                                          "Şikayetiniz alınmıştır.",
                                                                          "${c.usersList[index]["name"]} kullanıcısı bundan haberdar olmayacak.",
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
                                                                  await userController.addBlock("${c.usersList[index]["uid"]}");
                                                                  Get.back();
                                                                  Get.back();
                                                                  Get.snackbar(
                                                                    !userController.blockedUsers.contains("${c.usersList[index]["uid"]}") ? "Engellendi" : "Engel kaldırıldı",
                                                                    !userController.blockedUsers.contains("${c.usersList[index]["uid"]}") ? "${c.usersList[index]["name"]} kullanıcısı engellendi." : "${c.usersList[index]["name"]} kullanıcısının engeli kaldırıldı.",
                                                                    backgroundColor: ColorManager.instance.white,
                                                                    duration: const Duration(seconds: 5),
                                                                  );
                                                                },
                                                                title: userController.blockedUsers.contains("${c.usersList[index]["uid"]}") ? "Engeli Kaldır" : "Engelle",
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
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          child: GetBuilder<UserController>(builder: (userController) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: kElevationToShadow[2],
                                color: ColorManager.instance.gridGray,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: c.usersList[index]["images"] == null
                                        ? Image.asset(
                                            "assets/images/camera-slash.png",
                                            height: 40,
                                            width: 40,
                                          )
                                        : userController.isPremium == false
                                            ? Center(
                                                child: ClipRRect(
                                                  clipBehavior: Clip.hardEdge,
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Stack(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: c.usersList[index]["images"].first,
                                                        height: 202,
                                                        width: Get.width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      BackdropFilter(
                                                        filter: ImageFilter.blur(
                                                          sigmaX: 8.0,
                                                          sigmaY: 8.0,
                                                        ),
                                                        child: Container(
                                                          color: Colors.transparent,
                                                          width: Get.width,
                                                          height: 202,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: c.usersList[index]["images"].first,
                                                  height: 202,
                                                  width: Get.width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                c.usersList[index]["name"] ?? "",
                                                style: TextStyle(
                                                  color: ColorManager.instance.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Text(
                                              "${c.usersList[index]["birthTimestamp"] == null ? "" : (DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(c.usersList[index]["birthTimestamp"]).year)}",
                                              style: TextStyle(
                                                color: ColorManager.instance.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        c.usersList[index]["location"] != null
                                            ? Text(
                                                c.usersList[index]["location"],
                                                style: TextStyle(
                                                  color: ColorManager.instance.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShopWidget extends StatelessWidget {
  const ShopWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.to(() => const MarketPage());
      },
      icon: Image.asset(
        "assets/images/shop.png",
        height: 24,
        width: 24,
      ),
    );
  }
}
