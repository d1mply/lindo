import 'dart:io';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/app/ui/pages/register_page/register_social_controller.dart';
import 'package:lindo/app/ui/pages/root_page/root_page.dart';
import 'package:lindo/app/ui/utils/k_button_animated.dart';
import 'package:lindo/app/ui/utils/k_textformfield.dart';
import 'package:lindo/app/ui/utils/validation_manager.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import '../../../../core/base/state.dart';
import '../../../../core/init/network/network_manager.dart';

class RegisterPageSocial extends GetView<RegisterSocialController> {
  const RegisterPageSocial({required this.loginType, super.key});
  final int loginType; //0 google, 1 facebook, 2 apple
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterSocialController>(
      init: RegisterSocialController(),
      builder: (c) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_left,
              ),
              onPressed: () {
                c.prev();
              },
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: 1.sw,
              height: 1.sh,
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStep("Step 1", "assets/svg/step1.svg", 1),
                                    buildStep("Step 2", "assets/images/bigender.png", 2),
                                    buildStep("Step 3", "assets/svg/step4.svg", 3),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  Utility.dynamicWidthPixel(18),
                                ),
                                child: ExpandablePageView(
                                  controller: c.pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    //page 1
                                    Form(
                                      key: c.formKey1,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "İsmin Nedir?",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          KTextFormField.instance.widget(
                                            context: context,
                                            labelText: "İsim Soyisim",
                                            controller: c.nameController,
                                            validation: ValidatorManager.defaultEmptyCheckValidator,
                                            leadingIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                "assets/svg/email.svg",
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Doğum Tarihin Nedir?",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height: 300.0,
                                                    color: Colors.white,
                                                    child: CupertinoDatePicker(
                                                      mode: CupertinoDatePickerMode.date,
                                                      minimumYear: DateTime.now().year - 100,
                                                      maximumYear: DateTime.now().year - 18,
                                                      initialDateTime: DateTime.now().subtract(const Duration(days: 18 * 365)),
                                                      onDateTimeChanged: (DateTime newDate) {
                                                        c.selectedDateTime = newDate;
                                                        c.dateController.text = "${c.selectedDateTime?.day}/${c.selectedDateTime?.month}/${c.selectedDateTime?.year}";
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: IgnorePointer(
                                              ignoring: true,
                                              child: KTextFormField.instance.widget(
                                                context: context,
                                                readOnly: true,
                                                controller: c.dateController,
                                                validation: ValidatorManager.defaultEmptyCheckValidator,
                                                labelText: "Doğum Tarihi",
                                                suffixIcon: Padding(
                                                  padding: const EdgeInsets.all(12),
                                                  child: SvgPicture.asset("assets/svg/date.svg"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //page 2
                                    Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Cinsiyetin Nedir?",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  c.selectedGender = 1;
                                                  c.update();
                                                },
                                                child: c.selectedGender == 1
                                                    ? Image.asset(
                                                        "assets/images/female.png",
                                                        height: Get.height / 2,
                                                      )
                                                    : ColorFiltered(
                                                        colorFilter: const ColorFilter.matrix(<double>[0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
                                                        child: Image.asset(
                                                          "assets/images/female.png",
                                                          height: Get.height / 2,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  c.selectedGender = 2;
                                                  c.update();
                                                },
                                                child: c.selectedGender == 2
                                                    ? Image.asset(
                                                        "assets/images/male.png",
                                                        height: Get.height / 2,
                                                      )
                                                    : ColorFiltered(
                                                        colorFilter: const ColorFilter.matrix(<double>[0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
                                                        child: Image.asset(
                                                          "assets/images/male.png",
                                                          height: Get.height / 2,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //page 3
                                    Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 16.0),
                                          child: Text(
                                            "Fotoğraflarınızı Yükleyin",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final ImagePicker picker = ImagePicker();
                                            c.image1 = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
                                            c.update();
                                          },
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ColorManager.instance.lightPink,
                                            ),
                                            child: c.image1 != null
                                                ? Image.file(
                                                    File(
                                                      c.image1!.path,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child: SvgPicture.asset(
                                                      "assets/svg/step4.svg",
                                                      color: ColorManager.instance.pink,
                                                      width: 42,
                                                      height: 42,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      c.image2 = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: ColorManager.instance.lightPink,
                                                      ),
                                                      child: c.image2 != null
                                                          ? Image.file(
                                                              File(
                                                                c.image2!.path,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Center(
                                                              child: SvgPicture.asset(
                                                                "assets/svg/step4.svg",
                                                                color: ColorManager.instance.pink,
                                                                width: 42,
                                                                height: 42,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      c.image3 = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: ColorManager.instance.lightPink,
                                                      ),
                                                      child: c.image3 != null
                                                          ? Image.file(
                                                              File(
                                                                c.image3!.path,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Center(
                                                              child: SvgPicture.asset(
                                                                "assets/svg/step4.svg",
                                                                color: ColorManager.instance.pink,
                                                                width: 42,
                                                                height: 42,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final ImagePicker picker = ImagePicker();
                                                      c.image4 = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
                                                      c.update();
                                                    },
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: ColorManager.instance.lightPink,
                                                      ),
                                                      child: c.image4 != null
                                                          ? Image.file(
                                                              File(
                                                                c.image4!.path,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Center(
                                                              child: SvgPicture.asset(
                                                                "assets/svg/step4.svg",
                                                                color: ColorManager.instance.pink,
                                                                width: 42,
                                                                height: 42,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.05.sw, horizontal: 16),
                                child: KButtonAnimated(
                                  color: ColorManager.instance.pink,
                                  onTap: () async {
                                    if (c.currentStep == 3) {
                                      await c.uploadImages();
                                      if (c.images.isEmpty) {
                                        Get.closeAllSnackbars();
                                        Get.snackbar("Uyarı", "Lütfen en az 1 profil fotoğrafı yükleyiniz.");
                                      } else {
                                        try {
                                          if (loginType == 0) {
                                            await c.signInWithGoogle().then(
                                              (credential) async {
                                                if (credential != null) {
                                                  if (credential.user?.uid != null) {
                                                    //TODO burada user uid si varsa setleme işlemi yapma! facebook ve google için
                                                    await NetworkManager.instance.usersRef.child(credential.user!.uid).set(
                                                      {
                                                        "email": credential.user?.email,
                                                        "name": c.nameController.text,
                                                        "registerDate": DateTime.now().toString(),
                                                        "registerTimestamp": DateTime.now().millisecondsSinceEpoch,
                                                        "birthTimestamp": c.selectedDateTime?.millisecondsSinceEpoch,
                                                        "birth": c.selectedDateTime.toString(),
                                                        "year": DateTime.now().year - c.selectedDateTime!.year,
                                                        "images": c.images,
                                                        "birthYear": c.selectedDateTime?.year,
                                                        "gender": c.selectedGender,
                                                        "uid": credential.user?.uid,
                                                        "account_verify": false,
                                                        "coin": 100,
                                                      },
                                                    ).then(
                                                      (value) {
                                                        Get.offAll(() => const RootPage());
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            );
                                          }
                                          if (loginType == 1) {
                                            await c.signInWithFacebook().then(
                                              (credential) async {
                                                if (credential != null) {
                                                  if (credential.user?.uid != null) {
                                                    await NetworkManager.instance.usersRef.child(credential.user!.uid).set(
                                                      {
                                                        "email": credential.user?.email,
                                                        "name": c.nameController.text,
                                                        "registerDate": DateTime.now().toString(),
                                                        "registerTimestamp": DateTime.now().millisecondsSinceEpoch,
                                                        "birthTimestamp": c.selectedDateTime?.millisecondsSinceEpoch,
                                                        "birth": c.selectedDateTime.toString(),
                                                        "year": DateTime.now().year - c.selectedDateTime!.year,
                                                        "images": c.images,
                                                        "birthYear": c.selectedDateTime?.year,
                                                        "gender": c.selectedGender,
                                                        "uid": credential.user?.uid,
                                                        "account_verify": false,
                                                        "coin": 100,
                                                      },
                                                    ).then(
                                                      (value) {
                                                        Get.offAll(() => const RootPage());
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            );
                                          }
                                          if (loginType == 2) {
                                            await c.signInWithApple().then(
                                              (credential) async {
                                                if (credential != null) {
                                                  if (credential.user?.uid != null) {
                                                    await NetworkManager.instance.usersRef.child(credential.user!.uid).set(
                                                      {
                                                        "email": credential.user?.email,
                                                        "name": c.nameController.text,
                                                        "registerDate": DateTime.now().toString(),
                                                        "registerTimestamp": DateTime.now().millisecondsSinceEpoch,
                                                        "birthTimestamp": c.selectedDateTime?.millisecondsSinceEpoch,
                                                        "birth": c.selectedDateTime.toString(),
                                                        "year": DateTime.now().year - c.selectedDateTime!.year,
                                                        "images": c.images,
                                                        "birthYear": c.selectedDateTime?.year,
                                                        "gender": c.selectedGender,
                                                        "uid": credential.user?.uid,
                                                        "account_verify": false,
                                                        "coin": 100,
                                                      },
                                                    ).then(
                                                      (value) {
                                                        Get.offAll(() => const RootPage());
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            );
                                          }
                                          UserController userController = Get.find();
                                          userController.getCurrentUserData();
                                        } on FirebaseAuthException catch (e) {
                                          Get.closeAllSnackbars();
                                          Get.snackbar("Hata", e.message ?? "Bir hata oluştu", backgroundColor: Colors.white);
                                        } catch (e) {
                                          debugPrint("hata");
                                        }
                                      }
                                    }
                                    if (c.currentStep == 2) {
                                      if (c.selectedGender == 0) {
                                        Get.rawSnackbar(title: "Uyarı", message: "Lütfen seçim yapınız.");
                                      } else {
                                        c.next();
                                      }
                                    }
                                    if (c.currentStep == 1) {
                                      if (c.formKey1.currentState!.validate()) {
                                        c.next();
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      }
                                    }
                                  },
                                  title: "İlerle",
                                  textColor: ColorManager.instance.white,
                                ),
                              ),
                            ],
                          )
                        ],
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

  Widget buildStep(String title, String iconPath, int stepNumber) {
    RegisterSocialController controller = Get.find();
    bool isActive = stepNumber == controller.currentStep;
    return GetBuilder<RegisterSocialController>(
      builder: (c) {
        return isActive == true
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFAEBF3),
                ),
                child: stepNumber == 2
                    ? Image.asset(
                        iconPath,
                        height: 24.w,
                        width: 24.w,
                        color: ColorManager.instance.pink,
                      ).animate().fadeIn(
                          delay: const Duration(milliseconds: 300),
                        )
                    : SvgPicture.asset(
                        iconPath,
                        height: 24.w,
                        width: 24.w,
                        color: ColorManager.instance.pink,
                      ).animate().fadeIn(
                          delay: const Duration(milliseconds: 300),
                        ),
              )
            : Container(
                padding: const EdgeInsets.all(12),
                height: 11,
                width: 65,
                decoration: BoxDecoration(
                  color: ColorManager.instance.pink,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
              ).animate().fadeIn(
                  delay: const Duration(milliseconds: 300),
                );
      },
    );
  }
}
