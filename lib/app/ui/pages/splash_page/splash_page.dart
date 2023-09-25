import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(context: context),
      builder: (c) {
        return Scaffold(
          body: Center(
            child: SvgPicture.asset(
              "assets/svg/l_lindo.svg",
              width: Get.width - 50,
            ),
          ),
        );
      },
    );
  }
}
