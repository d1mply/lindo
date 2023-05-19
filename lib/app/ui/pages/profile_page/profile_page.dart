// ignore_for_file: prefer_if_null_operators

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindo/core/base/state.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../controllers/profile_controller.dart';
import '../../utils/k_bottom_sheet.dart';
import '../../utils/k_button.dart';
import '../../utils/k_textformfield.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.instance.background_gray,
      child: SafeArea(
        child: GetBuilder<ProfileController>(
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
                                                    XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                                  XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                                    XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50000),
                                            child: InkWell(
                                              onTap: () async {
                                                final ImagePicker picker = ImagePicker();
                                                XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                                child: c.images[0] == null
                                                    ? Padding(
                                                        padding: const EdgeInsets.all(24.0),
                                                        child: SvgPicture.asset("assets/svg/step4.svg"),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius: BorderRadius.circular(5000),
                                                        child: CachedNetworkImage(
                                                          imageUrl: c.images[0] ?? "",
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
                                                    XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                                  XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                                    XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
                                          "Konumunu ekleyerek daha çok görüntülenme al.",
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
                                    c.permissionGranted = true;
                                    c.update();
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
                                onTap: () {},
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
        ),
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
