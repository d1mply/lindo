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
    clearChatRoomsData();
    //init();
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

  final int hour = 3600000;
  int count = 100;
  int removedDocCount = 0;
  clearChatRoomsData() async {
    await NetworkManager.instance.chatRooms.get().then(
      (DataSnapshot value) async {
        if (value.exists) {
          Object? vals = value.value;
          if (vals != null) {
            Map<dynamic, dynamic> values = value.value as Map<dynamic, dynamic>;
            DateTime now = DateTime.now();
            int interval = ((hour * 24) * 10);
            int intervalOneDay = ((hour * 24));

            values.forEach(
              (key, value) async {
                try {
                  bool senderIsFree = false;
                  bool receiverIsfree = false;
                  String docId = key;
                  List<String> uids = docId.split("-");

                  String? senderUid = uids.first;
                  String? receiverUid = uids.last;
                 // print("FIRST $senderUid");
                 // print("SECOND $receiverUid");
                  DataSnapshot senderDataSnapshot = await NetworkManager.instance.getUserDetailsWithId(senderUid);
                  final senderUser = senderDataSnapshot.value as Map?;

                  DataSnapshot? receiverDataSnapshot = await NetworkManager.instance.getUserDetailsWithId(receiverUid);
                  final receiverUser = receiverDataSnapshot.value as Map?;

                  int? senderPremiumEndDate = senderUser?["premiumEndDate"] as int?;
                  int? receiverPremiumEndDate = receiverUser?["premiumEndDate"] as int?;
                  
                  if (senderPremiumEndDate == null) {
                    senderIsFree = true;
                  } else {
                    if (senderPremiumEndDate < now.millisecondsSinceEpoch) {
                      senderIsFree = true;
                    } else {
                      senderIsFree = false;
                    }
                  }

                  if (receiverPremiumEndDate == null) {
                    receiverIsfree = true;
                  } else {
                    if (receiverPremiumEndDate < now.millisecondsSinceEpoch) {
                      receiverIsfree = true;
                    } else {
                      receiverIsfree = false;
                    }
                  }

                  // Map<dynamic, dynamic> values = value as Map<dynamic, dynamic>;
                  value.forEach(
                    (key, data) async {
                      try {
                        if (senderIsFree == false || receiverIsfree == false) {
                          if (data["timestamp"] + interval < now.millisecondsSinceEpoch) {
                            NetworkManager.instance.chatRooms.child(docId).remove();
                            removedDocCount = removedDocCount + 1;
                            //   print("REMOVED $docId");
                          }
                        } else {
                          if (data["timestamp"] + intervalOneDay < now.millisecondsSinceEpoch) {
                            NetworkManager.instance.chatRooms.child(docId).remove();
                            removedDocCount = removedDocCount + 1;
                            //print("REMOVED $docId");
                          }
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  );
                  print("REMOVED DOC COUNT $removedDocCount");
                } catch (e) {
                  debugPrint(e.toString());
                  print("ERROR VERDİ");
                }
              },
            );
          }
          update();
        }
      },
    );
    print("REMOVED DOC COUNT $removedDocCount");
  
  }
}
