import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/init/theme/color_manager.dart';
import '../../../controllers/swipe_controller.dart';

class SwipePage extends GetView<SwipeController> {
  const SwipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwipeController>(
      init: SwipeController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: ColorManager.instance.background_gray,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/svg/undo.svg",
              ),
            ),
            elevation: 0,
            backgroundColor: ColorManager.instance.background_gray,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  "assets/images/shop.png",
                  height: 24,
                  width: 24,
                ),
              ),
            ],
            title: Image.asset(
              "assets/images/lindo.png",
              width: 79,
              height: 54,
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              height: 1.sh,
              width: 1.sw,
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
                      child: Text("fs"),
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
}
