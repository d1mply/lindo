// ignore_for_file: no_leading_underscores_for_local_identifiers, empty_catches

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindo/core/init/network/network_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ProfileController extends GetxController {
  DataSnapshot? userDetails;
  Map<dynamic, dynamic>? user;
  List<String?> images = [null, null, null, null, null, null, null];
  String? height, weight, smoking, wineBottle, hearth, sex, personality, money, instagram;
  List<String> sigara = ["İçiyorum", "İçmiyorum", "Bazen İçiyorum"];
  List<String> alkol = ["İçiyorum", "İçmiyorum", "Bazen İçiyorum"];
  List<String> iliski = ["Flört", "Sevgili", "Evlilik", "Tanışma", "Arkadaş"];
  List<String> cinsellik = ["Olur", "Olmaz", "Belki"];
  List<String> kisilik = ["Açıklık", "Sorumlu", "Utangaç", "Uyumlu", "Duygusal", "Meraklı", "Araştırmacı", "Gezgin"];
  List<String> ilgiAlanlari = ["Bisiklet Sürmek", "Araba Sürmek", "Yürüş Yapmak", "Kitap Okumak", "Oyun Oynamak", "Gezmek", "Yemek Yapmak", "Yüzme", "Tenis", "Voleybol", "Futbol", "Diğer"];
  int number = 0;
  int retryNumber = 0;
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    getMarketDescriptionData();
    getFirstData();
    super.onInit();
  }

  bool permissionGranted = false;

  List<String> boostDetails = [];
  List<String> premiumDetails = [];

  getMarketDescriptionData() async {
    try {
      DataSnapshot snapshot = await NetworkManager.instance.boostRef.get();

      if (snapshot.exists) {
        for (var element in snapshot.children) {
          boostDetails.add(element.value as String);
        }
      }
    } catch (e) {}

    try {
      DataSnapshot snapshot2 = await NetworkManager.instance.premiumRef.get();

      if (snapshot2.exists) {
        for (var element in snapshot2.children) {
          premiumDetails.add(element.value as String);
        }
      }
    } catch (e) {}
  }

  getFirstData() async {
    permissionGranted = await Permission.location.isGranted;
    DataSnapshot _user = await NetworkManager.instance.getCurrentUserDetails();
    userDetails = _user;
    final data = userDetails?.value as Map<Object?, Object?>;
    images = [null, null, null, null, null, null, null];
    try {
      if (_user.exists) {
        Object? vals = _user.value;
        if (vals != null) {
          user = _user.value as Map<dynamic, dynamic>;
        }
        update();
      }
      for (int i = 0; i < 7; i++) {
        try {
          images[i] = (data["images"] as List<Object?>)[i].toString();
          if (images[i] == "") {
            images[i] = null;
          }
        } catch (e) {
          images[i] = null;
        }
      }
    } catch (e) {}
    debugPrint(images.toString());
    update();
  }

  Future<String?> uploadImage(XFile? image) async {
    if (image != null) {
      String downloadUrl = "";
      var uuid = const Uuid();
      String filename = uuid.v1();
      try {
        Reference ref = FirebaseStorage.instance.ref().child(filename);
        await ref.putFile(File(image.path));
        downloadUrl = await FirebaseStorage.instance.ref(filename).getDownloadURL();
      } catch (e) {
        debugPrint(e.toString());
      }
      return downloadUrl;
    }
    return null;
  }
}

Future<String?> uploadImage(XFile? image) async {
  if (image != null) {
    String downloadUrl = "";
    var uuid = const Uuid();
    String filename = uuid.v1();
    try {
      Reference ref = FirebaseStorage.instance.ref().child(filename);
      await ref.putFile(File(image.path));
      downloadUrl = await FirebaseStorage.instance.ref(filename).getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
    }
    return downloadUrl;
  }
  return null;
}
