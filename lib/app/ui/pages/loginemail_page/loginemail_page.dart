import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/pages/root_page/root_page.dart';
import 'package:lindo/app/ui/utils/k_textformfield.dart';
import 'package:translator/translator.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../utils/k_button.dart';

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
                            Get.offAll(() => const RootPage());
                          }
                        } on FirebaseAuthException catch (e) {
                          Get.closeAllSnackbars();
                          final translator = GoogleTranslator();
                          Translation translation = await translator.translate(e.message ?? "", to: 'tr');
                          Get.snackbar("Error", translation.text, backgroundColor: Colors.white);
                        }
                      },
                      title: "Giriş Yap",
                      textColor: ColorManager.instance.white,
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
