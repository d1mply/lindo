// ignore_for_file: prefer_if_null_operators, empty_catches, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindo/config.dart';
import 'package:lindo/core/base/state.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/usercontroller.dart';
import '../../global_widgets/indicator.dart';
import '../../utils/k_bottom_sheet.dart';
import '../../utils/k_button.dart';
import '../../utils/k_textformfield.dart';
import 'package:http/http.dart' as http;

import '../market_page/market_page.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.instance.background_gray,
      child: SafeArea(
        child: GetBuilder<UserController>(builder: (userController) {
          return GetBuilder<ProfileController>(
            init: ProfileController(),
            builder: (c) {
              return Scaffold(
                backgroundColor: ColorManager.instance.background_gray,
                appBar: AppBar(
                  backgroundColor: ColorManager.instance.background_gray,
                  title: SvgPicture.asset("assets/svg/l_lindo.svg"),
                  elevation: 0,
                  /*
                    actions: [
                      IconButton(
                        icon: SvgPicture.asset("assets/svg/settings.svg"),
                        onPressed: () {},
                      ),
                    ],
                    */
                  centerTitle: false,
                ),
                body: c.userDetails != null
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              userController.boosted == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: ColorManager.instance.gridGray,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "assets/images/startup.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 12.0, right: 19),
                                              child: Text(
                                                'Öne Çıkart',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            CountdownTimer(
                                              endTime: c.user?["boostEndDate"],
                                              onEnd: () {
                                                userController.getCurrentUserData();
                                              },
                                              endWidget: const SizedBox(),
                                              widgetBuilder: (context, time) => Text(
                                                "${time?.hours ?? ""}:${time?.min ?? ""}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Utility.dynamicWidthPixel(20),
                                  bottom: Utility.dynamicWidthPixel(40),
                                ),
                                child: SizedBox(
                                  height: Utility.dynamicWidthPixel(166),
                                  width: Get.width,
                                  child: Builder(
                                    builder: (context) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: Utility.dynamicWidthPixel(166),
                                            width: Utility.dynamicWidthPixel(67),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: Utility.dynamicWidthPixel(24)),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                      String? downloadUrl = await c.uploadImage(image);
                                                      if (downloadUrl != null) {
                                                        c.images[1] = downloadUrl;
                                                        String uid = FirebaseAuth.instance.currentUser!.uid;
                                                        List<String> imgs = [];
                                                        for (var element in c.images) {
                                                          if (element != null) {
                                                            imgs.add(element);
                                                          }
                                                        }
                                                        await NetworkManager.instance.usersRef.child(uid).update(
                                                          {
                                                            "images": imgs,
                                                          },
                                                        );
                                                        c.getFirstData();
                                                      }
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: Utility.dynamicWidthPixel(44),
                                                      width: Utility.dynamicWidthPixel(44),
                                                      decoration: BoxDecoration(
                                                        color: ColorManager.instance.lightPink,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: c.images[1] == null
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SvgPicture.asset("assets/svg/step4.svg"),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(5000),
                                                              child: CachedNetworkImage(
                                                                imageUrl: c.images[1] ?? "",
                                                                fit: BoxFit.cover,
                                                                errorWidget: (context, url, error) {
                                                                  return Container(
                                                                    height: Utility.dynamicWidthPixel(44),
                                                                    width: Utility.dynamicWidthPixel(44),
                                                                    decoration: BoxDecoration(
                                                                      color: ColorManager.instance.lightPink,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Utility.dynamicWidthPixel(17),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final ImagePicker picker = ImagePicker();
                                                    XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                    String? downloadUrl = await c.uploadImage(image);
                                                    if (downloadUrl != null) {
                                                      c.images[2] = downloadUrl;
                                                      String uid = FirebaseAuth.instance.currentUser!.uid;
                                                      await NetworkManager.instance.usersRef.child(uid).update(
                                                        {
                                                          "images": c.images,
                                                        },
                                                      );
                                                      c.getFirstData();
                                                    }
                                                    c.update();
                                                  },
                                                  child: Container(
                                                    height: Utility.dynamicWidthPixel(44),
                                                    width: Utility.dynamicWidthPixel(44),
                                                    decoration: BoxDecoration(
                                                      color: ColorManager.instance.lightPink,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: c.images[2] == null
                                                        ? Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SvgPicture.asset("assets/svg/step4.svg"),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius: BorderRadius.circular(5000),
                                                            child: CachedNetworkImage(
                                                              imageUrl: c.images[2] ?? "",
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context, url, error) {
                                                                return Container(
                                                                  height: Utility.dynamicWidthPixel(44),
                                                                  width: Utility.dynamicWidthPixel(44),
                                                                  decoration: BoxDecoration(
                                                                    color: ColorManager.instance.lightPink,
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Utility.dynamicWidthPixel(17),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: Utility.dynamicWidthPixel(24)),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                      String? downloadUrl = await c.uploadImage(image);
                                                      if (downloadUrl != null) {
                                                        c.images[3] = downloadUrl;
                                                        String uid = FirebaseAuth.instance.currentUser!.uid;
                                                        List<String> imgs = [];
                                                        for (var element in c.images) {
                                                          if (element != null) {
                                                            imgs.add(element);
                                                          }
                                                        }
                                                        await NetworkManager.instance.usersRef.child(uid).update(
                                                          {
                                                            "images": imgs,
                                                          },
                                                        );
                                                        c.getFirstData();
                                                      }
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: Utility.dynamicWidthPixel(44),
                                                      width: Utility.dynamicWidthPixel(44),
                                                      decoration: BoxDecoration(
                                                        color: ColorManager.instance.lightPink,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: c.images[3] == null
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SvgPicture.asset("assets/svg/step4.svg"),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(5000),
                                                              child: CachedNetworkImage(
                                                                imageUrl: c.images[3] ?? "",
                                                                fit: BoxFit.cover,
                                                                errorWidget: (context, url, error) {
                                                                  return Container(
                                                                    height: Utility.dynamicWidthPixel(44),
                                                                    width: Utility.dynamicWidthPixel(44),
                                                                    decoration: BoxDecoration(
                                                                      color: ColorManager.instance.lightPink,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: Utility.dynamicWidthPixel(12)),
                                            child: InkWell(
                                              onTap: () async {
                                                final ImagePicker picker = ImagePicker();
                                                XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                String? downloadUrl = await c.uploadImage(image);
                                                if (downloadUrl != null) {
                                                  c.images[0] = downloadUrl;
                                                  String uid = FirebaseAuth.instance.currentUser!.uid;
                                                  await NetworkManager.instance.usersRef.child(uid).update(
                                                    {
                                                      "images": c.images,
                                                    },
                                                  );
                                                  c.getFirstData();
                                                }
                                                c.update();
                                              },
                                              child: Container(
                                                width: Utility.dynamicWidthPixel(166),
                                                height: Utility.dynamicWidthPixel(166),
                                                decoration: BoxDecoration(
                                                  color: ColorManager.instance.lightPink,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    c.images[0] == null
                                                        ? Padding(
                                                            padding: const EdgeInsets.all(24.0),
                                                            child: SvgPicture.asset("assets/svg/step4.svg"),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius: BorderRadius.circular(5000),
                                                            child: CachedNetworkImage(
                                                              imageUrl: c.images[0] ?? "",
                                                              width: Utility.dynamicWidthPixel(166),
                                                              height: Utility.dynamicWidthPixel(166),
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context, url, error) {
                                                                return Container(
                                                                  height: Utility.dynamicWidthPixel(166),
                                                                  width: Utility.dynamicWidthPixel(166),
                                                                  decoration: BoxDecoration(
                                                                    color: ColorManager.instance.lightPink,
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20),
                                                                    child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                    if (userController.isPremium)
                                                      Positioned(
                                                        left: 0,
                                                        top: 0,
                                                        child: Image.asset(
                                                          "assets/images/premium.png",
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                      ),
                                                    if (c.user?["validate"] == true)
                                                      Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: SvgPicture.asset("assets/svg/tik.svg", width: 27, height: 27, color: const Color(0xFF2F8BFF)),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Utility.dynamicWidthPixel(166),
                                            width: Utility.dynamicWidthPixel(67),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right: Utility.dynamicWidthPixel(24)),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                      String? downloadUrl = await c.uploadImage(image);
                                                      if (downloadUrl != null) {
                                                        c.images[4] = downloadUrl;
                                                        String uid = FirebaseAuth.instance.currentUser!.uid;
                                                        List<String> imgs = [];
                                                        for (var element in c.images) {
                                                          if (element != null) {
                                                            imgs.add(element);
                                                          }
                                                        }
                                                        await NetworkManager.instance.usersRef.child(uid).update(
                                                          {
                                                            "images": imgs,
                                                          },
                                                        );
                                                        c.getFirstData();
                                                      }
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: Utility.dynamicWidthPixel(44),
                                                      width: Utility.dynamicWidthPixel(44),
                                                      decoration: BoxDecoration(
                                                        color: ColorManager.instance.lightPink,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: c.images[4] == null
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SvgPicture.asset("assets/svg/step4.svg"),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(5000),
                                                              child: CachedNetworkImage(
                                                                imageUrl: c.images[4] ?? "",
                                                                fit: BoxFit.cover,
                                                                errorWidget: (context, url, error) {
                                                                  return Container(
                                                                    height: Utility.dynamicWidthPixel(44),
                                                                    width: Utility.dynamicWidthPixel(44),
                                                                    decoration: BoxDecoration(
                                                                      color: ColorManager.instance.lightPink,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Utility.dynamicWidthPixel(17),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final ImagePicker picker = ImagePicker();
                                                    XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                    String? downloadUrl = await c.uploadImage(image);
                                                    if (downloadUrl != null) {
                                                      c.images[5] = downloadUrl;
                                                      String uid = FirebaseAuth.instance.currentUser!.uid;
                                                      await NetworkManager.instance.usersRef.child(uid).update(
                                                        {
                                                          "images": c.images,
                                                        },
                                                      );
                                                      c.getFirstData();
                                                    }
                                                    c.update();
                                                  },
                                                  child: Container(
                                                    height: Utility.dynamicWidthPixel(44),
                                                    width: Utility.dynamicWidthPixel(44),
                                                    decoration: BoxDecoration(
                                                      color: ColorManager.instance.lightPink,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: c.images[5] == null
                                                        ? Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SvgPicture.asset("assets/svg/step4.svg"),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius: BorderRadius.circular(5000),
                                                            child: CachedNetworkImage(
                                                              imageUrl: c.images[5] ?? "",
                                                              fit: BoxFit.cover,
                                                              errorWidget: (context, url, error) {
                                                                return Container(
                                                                  height: Utility.dynamicWidthPixel(44),
                                                                  width: Utility.dynamicWidthPixel(44),
                                                                  decoration: BoxDecoration(
                                                                    color: ColorManager.instance.lightPink,
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Utility.dynamicWidthPixel(17),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: Utility.dynamicWidthPixel(24)),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxHeight: 1000, maxWidth: 1000);
                                                      String? downloadUrl = await c.uploadImage(image);
                                                      if (downloadUrl != null) {
                                                        c.images[6] = downloadUrl;
                                                        String uid = FirebaseAuth.instance.currentUser!.uid;
                                                        List<String> imgs = [];
                                                        for (var element in c.images) {
                                                          if (element != null) {
                                                            imgs.add(element);
                                                          }
                                                        }
                                                        await NetworkManager.instance.usersRef.child(uid).update(
                                                          {
                                                            "images": imgs,
                                                          },
                                                        );
                                                        c.getFirstData();
                                                      }
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: Utility.dynamicWidthPixel(44),
                                                      width: Utility.dynamicWidthPixel(44),
                                                      decoration: BoxDecoration(
                                                        color: ColorManager.instance.lightPink,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: c.images[6] == null
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SvgPicture.asset("assets/svg/step4.svg"),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(5000),
                                                              child: CachedNetworkImage(
                                                                imageUrl: c.images[6] ?? "",
                                                                fit: BoxFit.cover,
                                                                errorWidget: (context, url, error) {
                                                                  return Container(
                                                                    height: Utility.dynamicWidthPixel(44),
                                                                    width: Utility.dynamicWidthPixel(44),
                                                                    decoration: BoxDecoration(
                                                                      color: ColorManager.instance.lightPink,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: SvgPicture.asset("assets/svg/step4.svg"),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (c.premiumDetails.isNotEmpty)
                                userController.isPremium == false
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => const MarketPage(type: 2));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 8),
                                          child: Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFF3A8),
                                                  Color(0xFFAF9700),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset("assets/images/premium.png", height: 50, width: 50),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 12.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Premium Edinin",
                                                            style: TextStyle(
                                                              color: ColorManager.instance.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: CarouselSlider(
                                                              options: CarouselOptions(
                                                                autoPlay: true,
                                                                viewportFraction: 1,
                                                                autoPlayInterval: const Duration(seconds: 6),
                                                                height: 58,
                                                              ),
                                                              items: c.premiumDetails
                                                                  .asMap()
                                                                  .entries
                                                                  .map(
                                                                    (e) => Column(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                            e.value,
                                                                            style: TextStyle(
                                                                              color: ColorManager.instance.white,
                                                                              fontSize: 14,
                                                                              fontFamily: 'Rubik',
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                            maxLines: 2,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 8),
                                                                        Row(
                                                                            children: c.premiumDetails.asMap().entries.map(
                                                                          (i) {
                                                                            return Indicator(isActive: e.key == i.key);
                                                                          },
                                                                        ).toList()),
                                                                      ],
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              if (c.boostDetails.isNotEmpty)
                                userController.boosted == false
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => const MarketPage(type: 1));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8, left: 30, right: 30),
                                          child: Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFC8B9FF),
                                                  Color(0xFFC8C9CC),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset("assets/images/startup.png", height: 50, width: 50),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 12.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Hesabını Öne Çıkart",
                                                            style: TextStyle(
                                                              color: ColorManager.instance.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: CarouselSlider(
                                                              options: CarouselOptions(
                                                                autoPlay: true,
                                                                viewportFraction: 1,
                                                                autoPlayInterval: const Duration(seconds: 6),
                                                                height: 60,
                                                              ),
                                                              items: c.boostDetails
                                                                  .asMap()
                                                                  .entries
                                                                  .map(
                                                                    (e) => Column(
                                                                      children: [
                                                                        Text(
                                                                          e.value,
                                                                          style: TextStyle(
                                                                            color: ColorManager.instance.white,
                                                                            fontSize: 14,
                                                                            fontFamily: 'Rubik',
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 8),
                                                                        Row(
                                                                            children: c.boostDetails.asMap().entries.map(
                                                                          (i) {
                                                                            return Indicator(isActive: e.key == i.key);
                                                                          },
                                                                        ).toList()),
                                                                      ],
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                                child: InkWell(
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: ColorManager.instance.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset("assets/svg/location.svg"),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Konum",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            c.user?["location"] == null ? "Konumunu ekleyerek daha çok görüntülenme al." : c.user?["location"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: ColorManager.instance.softBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (await Permission.location.request().isGranted) {
                                      try {
                                        c.permissionGranted = true;
                                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
                                        if (placemarks.isNotEmpty) {
                                          Placemark placemark = placemarks.first;
                                          String? cityCode = placemark.administrativeArea;
                                          if (cityCode != null) {
                                            await NetworkManager.instance.currentUserRef().update(
                                              {
                                                "location": cityCode,
                                              },
                                            );
                                            c.getFirstData();
                                          }
                                        }
                                        c.update();
                                      } catch (e) {}
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30),
                                child: InkWell(
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: ColorManager.instance.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Biyografi",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  c.user?["bio"] == null ? "Biraz kendinden bahset" : c.user?["bio"],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorManager.instance.softBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    TextEditingController textEditingController = TextEditingController();
                                    KBottomSheet.show(
                                      context: context,
                                      title: "Biyografi",
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            KTextFormField.instance.widget(
                                              context: context,
                                              controller: textEditingController..text = c.user?["bio"] == null ? "" : c.user?["bio"],
                                              maxLines: 5,
                                              minLines: 1,
                                            ),
                                            KButton(
                                              color: ColorManager.instance.pink,
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                await NetworkManager.instance.currentUserRef().update(
                                                  {
                                                    "bio": textEditingController.text,
                                                  },
                                                );
                                                c.getFirstData();
                                              },
                                              title: "Kaydet",
                                              textColor: ColorManager.instance.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 16),
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
                                          desc: c.user?["height"] == null ? "" : "${c.user?["height"]} cm",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.height != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "height": c.height,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(240, (i) => Text("$i cm")).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.height = value.toString();
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
                                        ),
                                        Info(
                                          img: "assets/images/weight.png",
                                          title: "Ağırlık",
                                          desc: c.user?["weight"] == null ? "" : "${c.user?["weight"]} kg",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.height != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "weight": c.weight,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(200, (i) => Text("$i kg")).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.weight = value.toString();
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
                                        ),
                                        Info(
                                          img: "assets/images/smoking.png",
                                          title: "Sigara",
                                          desc: c.user?["smoking"] == null ? "" : "${c.user?["smoking"]}",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.smoking != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "smoking": c.smoking,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(c.sigara.length, (i) => Text(c.sigara[i])).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.smoking = c.sigara[value];
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
                                        ),
                                        Info(
                                          img: "assets/images/wine-bottle.png",
                                          title: "Alkol",
                                          desc: c.user?["wine-bottle"] == null ? "" : "${c.user?["wine-bottle"]}",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.wineBottle != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "wine-bottle": c.wineBottle,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(c.alkol.length, (i) => Text(c.alkol[i])).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.wineBottle = c.alkol[value];
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
                                        ),
                                        Info(
                                          img: "assets/images/heart.png",
                                          title: "İlişki Beklentim",
                                          desc: c.user?["hearth"] == null ? "" : "${c.user?["hearth"]}",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.hearth != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "hearth": c.hearth,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(c.iliski.length, (i) => Text(c.iliski[i])).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.hearth = c.iliski[value];
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
                                        ),
                                        Info(
                                          img: "assets/images/gender.png",
                                          title: "Cinsellik",
                                          desc: c.user?["sex"] == null ? "" : "${c.user?["sex"]}",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.sex != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "sex": c.sex,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(c.cinsellik.length, (i) => Text(c.cinsellik[i])).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.sex = c.cinsellik[value];
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
                                        ),
                                        Info(
                                          img: "assets/images/personality.png",
                                          title: "Kişilik",
                                          desc: c.user?["personality"] == null ? "" : "${c.user?["personality"]}",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.personality != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "personality": c.personality,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(c.kisilik.length, (i) => Text(c.kisilik[i])).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.personality = c.kisilik[value];
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
                                        ),
                                        Info(
                                          img: "assets/images/money.png",
                                          title: "İlgi Alanları",
                                          desc: c.user?["money"] == null ? "" : "${c.user?["money"]}",
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
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                    },
                                                                    child: Text(
                                                                      'Vazgeç',
                                                                      style: TextStyle(
                                                                        fontSize: Utility.dynamicTextSize(14),
                                                                        color: ColorManager.instance.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                      if (c.money != null) {
                                                                        await NetworkManager.instance.currentUserRef().update(
                                                                          {
                                                                            "money": c.money,
                                                                          },
                                                                        );
                                                                        c.getFirstData();
                                                                      }
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
                                                              itemExtent: 40,
                                                              scrollController: FixedExtentScrollController(initialItem: 4),
                                                              children: List.generate(c.ilgiAlanlari.length, (i) => Text(c.ilgiAlanlari[i])).toList(),
                                                              onSelectedItemChanged: (value) {
                                                                c.money = c.ilgiAlanlari[value];
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 12,
                                ),
                                child: InkWell(
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: ColorManager.instance.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/images/insta.png", height: 32, width: 32),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Instagram",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  c.user?["instagram"] == null ? "" : c.user?["instagram"],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorManager.instance.softBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    TextEditingController textEditingController = TextEditingController();
                                    KBottomSheet.show(
                                      context: context,
                                      title: "Instagram Kullanıcı Adı",
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            KTextFormField.instance.widget(
                                              context: context,
                                              controller: textEditingController..text = c.user?["instagram"] == null ? "" : c.user?["instagram"],
                                            ),
                                            KButton(
                                              color: ColorManager.instance.pink,
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                await NetworkManager.instance.currentUserRef().update(
                                                  {
                                                    "instagram": textEditingController.text,
                                                  },
                                                );
                                                c.getFirstData();
                                              },
                                              title: "Kaydet",
                                              textColor: ColorManager.instance.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              c.user?["validate"] != true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 12,
                                      ),
                                      child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: ColorManager.instance.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Onaylı Kullanıcı Ol",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Telefon numaranı doğrulayarak onaylı kullanıcı olabilirsin.",
                                                style: TextStyle(color: ColorManager.instance.softBlack),
                                              ),
                                              const SizedBox(height: 12),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                                child: KButton(
                                                  color: ColorManager.instance.pink,
                                                  textColor: ColorManager.instance.white,
                                                  onTap: () {
                                                    final formKey1 = GlobalKey<FormState>();

                                                    KBottomSheet.show(
                                                      context: context,
                                                      title: "Telefon numarası",
                                                      content: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Form(
                                                              key: formKey1,
                                                              child: KTextFormField.instance.widget(
                                                                context: context,
                                                                maxLength: 10,
                                                                keyboardType: TextInputType.phone,
                                                                labelText: "532XXXXXXX",
                                                                validation: (value) {
                                                                  if (value == null) {
                                                                    return "Telefon numarası boş bırakılamaz.";
                                                                  }

                                                                  if (value.length != 10) {
                                                                    return "Telefon numarası 10 haneli girilmelidir.";
                                                                  }
                                                                  return null;
                                                                },
                                                                controller: c.textEditingController,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            KButton(
                                                              color: ColorManager.instance.pink,
                                                              onTap: () async {
                                                                if (formKey1.currentState!.validate()) {
                                                                  Random random = Random();
                                                                  int number = 1000 + random.nextInt(9000);
                                                                  c.number = number;
                                                                  final headers = {
                                                                    'Content-Type': 'application/json',
                                                                    'Authorization': 'Bearer $smsToBearerKey',
                                                                  };

                                                                  final url = Uri.parse('https://api.sms.to/sms/send');

                                                                  final res = await http.post(url,
                                                                      headers: headers,
                                                                      body: jsonEncode({
                                                                        "message": "Lindo Arkadaşlık Uygulaması'na hoş geldiniz! Doğrulama kodunuz: $number Bu doğrulama kodunu kimseyle paylaşmayın. İyi günler dileriz!",
                                                                        "to": "+90${c.textEditingController.text}",
                                                                      }));
                                                                  final status = res.statusCode;
                                                                  final defaultPinTheme = PinTheme(
                                                                    width: 56,
                                                                    height: 56,
                                                                    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                  );

                                                                  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
                                                                    border: Border.all(color: ColorManager.instance.darkGray),
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  );

                                                                  final submittedPinTheme = defaultPinTheme.copyWith(
                                                                    decoration: defaultPinTheme.decoration?.copyWith(
                                                                      color: const Color.fromRGBO(234, 239, 243, 1),
                                                                    ),
                                                                  );
                                                                  Navigator.of(context).pop();
                                                                  if (status == 200) {
                                                                    KBottomSheet.show(
                                                                      context: context,
                                                                      title: "Doğrulama kodu",
                                                                      content: Padding(
                                                                        padding: const EdgeInsets.all(16),
                                                                        child: Pinput(
                                                                          defaultPinTheme: defaultPinTheme,
                                                                          focusedPinTheme: focusedPinTheme,
                                                                          submittedPinTheme: submittedPinTheme,
                                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                          length: 4,
                                                                          validator: (s) {
                                                                            return s == '${c.number}' ? null : 'Doğrulama Kodu Yanlış';
                                                                          },
                                                                          pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                                                                          keyboardType: TextInputType.number,
                                                                          onCompleted: (value) async {
                                                                            if (c.retryNumber > 3) {
                                                                              Navigator.of(context).pop();
                                                                            } else {
                                                                              if (value != '${c.number}') {
                                                                                c.retryNumber += 1;
                                                                              } else {
                                                                                await NetworkManager.instance.currentUserRef().update(
                                                                                  {
                                                                                    "validate": true,
                                                                                    "phone": c.textEditingController.text,
                                                                                  },
                                                                                );
                                                                                c.getFirstData();
                                                                                Navigator.of(context).pop();
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                              title: "Kaydet",
                                                              textColor: ColorManager.instance.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  title: "Telefon numarası ekle",
                                                  icon: Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: SvgPicture.asset("assets/svg/call.svg"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 12,
                                      ),
                                      child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: ColorManager.instance.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/svg/call.svg", height: 32, width: 32, color: ColorManager.instance.pink),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Telefon numaranız onaylandı.",
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      c.user?["phone"] == null ? "" : c.user?["phone"],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                        color: ColorManager.instance.softBlack,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32),
                                child: KButton(
                                  color: ColorManager.instance.pink,
                                  textColor: ColorManager.instance.white,
                                  onTap: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  title: "Çıkış Yap",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              );
            },
          );
        }),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.img,
    required this.title,
    required this.desc,
    required this.onTap,
  });
  final String img;
  final String title;
  final String desc;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      img,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorManager.instance.softBlack,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
            )
          ],
        ),
      ),
    );
  }
}
