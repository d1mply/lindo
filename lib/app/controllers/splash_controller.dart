// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/pages/root_page/root_page.dart';
import 'package:lindo/app/ui/utils/custom_dialog.dart';
import 'package:lindo/app/ui/utils/k_button.dart';
import 'package:lindo/core/init/network/network_manager.dart';
import 'package:lindo/core/init/theme/color_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashController extends GetxController {
  SplashController({required this.context});

  @override
  void onInit() {
    init();
    super.onInit();
  }

  final BuildContext context;
  init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;
    DataSnapshot dataSnapshot = await NetworkManager.instance.forceUpdateRef.get();

    try {
      int version = (dataSnapshot.value as Map)["version"];
      if (int.parse(buildNumber) < version) {
        CustomDialog().showGeneralDialog(
          context,
          dismissible: false,
          body: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                "Uygulamanın yeni bir sürümü mevcut 👏\nGüncelleme gerekli.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32),
                child: KButton(
                  color: ColorManager.instance.pink,
                  textColor: ColorManager.instance.white,
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.lindo&hl=tr&gl=US",
                      ),
                    );
                  },
                  title: "Güncelle",
                ),
              ),
            ],
          ),
          title: "Uyarı",
        );
      } else {
        Get.offAll(() => const RootPage());
      }
    } finally {}
  }
}
