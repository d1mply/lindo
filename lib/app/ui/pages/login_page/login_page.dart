import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/pages/register_page/register_page.dart';
import 'package:lindo/core/base/state.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../../controllers/login_controller.dart';
import '../../utils/k_button.dart';
import '../loginemail_page/loginemail_page.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.1.sw,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 0.06.sw,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                    child: KButton(
                      color: ColorManager.instance.pink,
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: const RegisterPage(),
                        );
                      },
                      title: "Hadi Başla",
                      textColor: ColorManager.instance.white,
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {},
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
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14),
                                            child: Text(
                                              "Google ile Giriş Yap",
                                              style: const TextStyle(
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
                              onTap: () async {},
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {},
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
                                            "assets/svg/apple.svg",
                                            height: 50,
                                            width: 24,
                                          ),
                                        ),
                                        const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 14),
                                            child: Text(
                                              "Apple ile Giriş Yap",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            pushNewScreen(context, screen: const LoginemailPage(), withNavBar: false);
                          },
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              color: ColorManager.instance.black,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.1.sw),
                    child: SvgPicture.asset("assets/svg/lindo_splash.svg"),
                  ),
                  Text(
                    "Hadi Başla’ya tıklayarak şartlarımızı kabul etmiş olursunuz.\nVeri işleme politikalarımız için",
                    style: TextStyle(
                      color: ColorManager.instance.softBlack,
                      fontSize: Utility.dynamicTextSize(13),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Gizlilik Politikası",
                      style: TextStyle(
                        color: ColorManager.instance.pink,
                        decoration: TextDecoration.underline,
                        fontSize: Utility.dynamicTextSize(13),
                      ),
                      children: [
                        TextSpan(
                          text: " ve ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorManager.instance.softBlack,
                          ),
                        ),
                        const TextSpan(
                          text: "Çerez Politikası",
                        ),
                        TextSpan(
                          text: "'nı inceleyebilirsiniz.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
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
      ),
    );
  }
}
