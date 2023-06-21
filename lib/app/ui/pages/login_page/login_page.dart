import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/pages/register_page/register_page.dart';
import 'package:lindo/core/base/state.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/login_controller.dart';
import '../../utils/k_button.dart';
import '../loginemail_page/loginemail_page.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.1.sw,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 0.06.sw,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                        child: KButton(
                          color: ColorManager.instance.pink,
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
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
                          /*
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
                      */
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(context, screen: const LoginemailPage(), withNavBar: false);
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.1.sw),
                  child: SvgPicture.asset("assets/svg/lindo_splash.svg"),
                ),
                Text(
                  "Hadi Başla’ya tıklayarak şartlarımızı kabul etmiş olursunuz. Veri işleme politikalarımız için",
                  style: TextStyle(
                    color: ColorManager.instance.softBlack,
                    fontSize: Utility.dynamicTextSize(13),
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Gizlilik Politikası",
                        style: TextStyle(
                          color: ColorManager.instance.pink,
                          fontSize: Utility.dynamicTextSize(13),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            try {
                              await launchUrl(
                                Uri.parse(
                                  "https://sites.google.com/view/lindo-chat-privacy-policy/ana-sayfa",
                                ),
                              );
                            } catch (e) {}
                          },
                        children: [
                          TextSpan(
                            text: " ve ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.instance.softBlack,
                            ),
                          ),
                          TextSpan(
                            text: "Çerez Politikası",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                try {
                                  await launchUrl(
                                    Uri.parse(
                                      "https://sites.google.com/view/lindo-cerez-politikasi/ana-sayfa",
                                    ),
                                  );
                                } catch (e) {}
                              },
                          ),
                          TextSpan(
                            text: "'nı inceleyebilirsiniz.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.instance.softBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
