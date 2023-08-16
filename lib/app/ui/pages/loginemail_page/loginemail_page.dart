// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/pages/register_page/register_page_social.dart';
import 'package:lindo/app/ui/pages/root_page/root_page.dart';
import 'package:lindo/app/ui/utils/k_textformfield.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/usercontroller.dart';
import '../../utils/k_button.dart';
import '../register_page/register_social_controller.dart';

class LoginemailPage extends StatefulWidget {
  const LoginemailPage({super.key});

  @override
  State<LoginemailPage> createState() => _LoginemailPageState();
}

GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

TextEditingController emailControllerForLogin = TextEditingController();
TextEditingController passwordControllerForLogin = TextEditingController();

class _LoginemailPageState extends State<LoginemailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Form(
        key: loginFormKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.1.sw),
                    child: SvgPicture.asset("assets/svg/lindo_splash.svg"),
                  ),
                  KTextFormField.instance.widget(
                    context: context,
                    labelText: "E-posta",
                    controller: emailControllerForLogin,
                    leadingIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        "assets/svg/email.svg",
                      ),
                    ),
                  ),
                  KTextFormField.instance.widget(
                    context: context,
                    labelText: "Şifre",
                    obscureText: true,
                    controller: passwordControllerForLogin,
                    leadingIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset("assets/svg/lock.svg"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                    child: KButton(
                      color: ColorManager.instance.pink,
                      onTap: () async {
                        try {
                          if (loginFormKey.currentState!.validate()) {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailControllerForLogin.text,
                              password: passwordControllerForLogin.text,
                            );
                            UserController userController = Get.find();
                            userController.getCurrentUserData();
                            Get.offAll(() => const RootPage());
                          }
                        } on FirebaseAuthException catch (e) {
                          Get.closeAllSnackbars();
                          Get.snackbar("Hata", e.message ?? "Bir hata oluştu", backgroundColor: Colors.white);
                        }
                      },
                      title: "Giriş Yap",
                      textColor: ColorManager.instance.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            RegisterSocialController c = Get.put(RegisterSocialController());
                            await c.signInWithGoogle().then(
                              (credential) async {
                                if (credential != null) {
                                  if (credential.user?.uid != null) {
                                    DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();

                                    if (user.value == null) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const RegisterPageSocial(
                                          loginType: 0,
                                        ),
                                      );
                                    } else {
                                      Get.offAll(() => const RootPage());
                                    }
                                  }
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: CupertinoColors.systemGrey2.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: CupertinoColors.systemGrey6,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/google.svg",
                                        height: 50,
                                        width: 24,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 14),
                                        child: Text(
                                          "Google ile Giriş Yap",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            RegisterSocialController c = Get.put(RegisterSocialController());
                            await c.signInWithFacebook().then(
                              (credential) async {
                                if (credential != null) {
                                  if (credential.user?.uid != null) {
                                    DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();

                                    if (user.value == null) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const RegisterPageSocial(
                                          loginType: 0,
                                        ),
                                      );
                                    } else {
                                      Get.offAll(() => const RootPage());
                                    }
                                  }
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: CupertinoColors.systemGrey2.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: CupertinoColors.systemGrey6,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/facebook.svg",
                                        height: 50,
                                        width: 24,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 14),
                                        child: Text(
                                          "Facebook ile Giriş Yap",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                    ),
                                  ],
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
            ),
          ),
        ),
      ),
    );
  }
}
