// ignore_for_file: prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/core/init/theme/color_manager.dart';

import '../../../core/base/state.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({super.key, required this.imgUrl});
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.vertical,
      isFullScreen: true,
      child: Container(
        color: ColorManager.instance.transparent,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorManager.instance.black,
            body: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: CachedNetworkImage(imageUrl: imgUrl),
                ),
                Positioned(left: Utility.dynamicWidthPixel(12), top: Utility.dynamicWidthPixel(12), child: const CircleBackButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleBackButton extends StatelessWidget {
  const CircleBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: Utility.dynamicWidthPixel(36),
        height: Utility.dynamicWidthPixel(36),
        decoration: BoxDecoration(
          color: ColorManager.instance.gray_spacer.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(
          Utility.dynamicWidthPixel(4),
        ),
        child: const Center(
          child: Icon(CupertinoIcons.chevron_left),
        ),
      ),
    );
  }
}
