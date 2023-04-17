import 'dart:io';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindo/app/ui/pages/root_page/root_page.dart';
import 'package:lindo/app/ui/utils/k_textformfield.dart';
import 'package:lindo/app/ui/utils/validation_manager.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:translator/translator.dart';
import '../../../../core/base/state.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../controllers/register_controller.dart';
import '../../utils/k_button.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_left,
          ),
          onPressed: () {
            Get.back();
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
                      GetBuilder<RegisterController>(
                        init: RegisterController(),
                        builder: (c) {
                          return Column(
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
                                    buildStep("Step 4", "assets/svg/step3.svg", 4),
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
                                    //page 4
                                    Form(
                                      key: c.formKey2,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "E-posta adresiniz nedir?",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          KTextFormField.instance.widget(
                                            context: context,
                                            labelText: "E-posta",
                                            controller: c.emailController,
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
                                              "Şifre Oluşturun",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          KTextFormField.instance.widget(
                                            context: context,
                                            labelText: "Şifre",
                                            controller: c.passwordController,
                                            obscureText: true,
                                            validation: ValidatorManager.defaultEmptyCheckValidator,
                                            leadingIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset("assets/svg/lock.svg"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.05.sw, horizontal: 16),
                                child: KButton(
                                  color: ColorManager.instance.pink,
                                  onTap: () async {
                                    if (c.currentStep != 4) {
                                      if (c.currentStep == 3) {
                                        c.uploadImages();
                                        c.next();
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
                                        }
                                      }
                                    } else {
                                      if (c.formKey2.currentState!.validate()) {
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                            email: c.emailController.text,
                                            password: c.passwordController.text,
                                          )
                                              .then(
                                            (credential) async {
                                              if (credential.user?.uid != null) {
                                                await NetworkManager.instance.usersRef.child(credential.user!.uid).set(
                                                  {
                                                    "email": credential.user?.email,
                                                    "name": c.nameController.text,
                                                    "registerDate": DateTime.now().toString(),
                                                    "registerTimestamp": DateTime.now().millisecondsSinceEpoch,
                                                    "birthTimestamp": c.selectedDateTime?.millisecondsSinceEpoch,
                                                    "birth": c.selectedDateTime.toString(),
                                                    "images": c.images,
                                                    "birthYear": c.selectedDateTime?.year,
                                                    "gender": c.selectedGender,
                                                    "uid": credential.user?.uid,
                                                  },
                                                );
                                                Get.offAll(() => const RootPage());
                                              }
                                            },
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          Get.closeAllSnackbars();
                                          final translator = GoogleTranslator();
                                          Translation translation = await translator.translate(e.message ?? "", to: 'tr');
                                          Get.snackbar("Hata", translation.text, backgroundColor: Colors.white);
                                        } catch (e) {
                                          print("hata");
                                        }
                                      }
                                    }
                                  },
                                  title: "İlerle",
                                  textColor: ColorManager.instance.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStep(String title, String iconPath, int stepNumber) {
    RegisterController controller = Get.find();
    bool isActive = stepNumber == controller.currentStep;
    return GetBuilder<RegisterController>(
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
                      )
                    : SvgPicture.asset(
                        iconPath,
                        height: 24.w,
                        width: 24.w,
                        color: ColorManager.instance.pink,
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
              );
      },
    );
  }
}
