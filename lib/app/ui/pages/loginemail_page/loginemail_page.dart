import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/utils/k_textformfield.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/loginemail_controller.dart';
import '../../utils/k_button.dart';

class LoginemailPage extends GetView<LoginemailController> {
  const LoginemailPage({super.key});

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
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          KTextFormField.instance.widget(
                            context: context,
                            labelText: "E-posta",
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
                            leadingIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset("assets/svg/lock.svg"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.05.sw),
                            child: KButton(
                              color: ColorManager.instance.pink,
                              onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
