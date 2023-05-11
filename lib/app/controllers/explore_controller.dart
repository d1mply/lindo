import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';

import '../../core/init/network/network_manager.dart';

class ExploreController extends GetxController {
  TextEditingController searchController = TextEditingController();
  int pageSize = 10;
  bool onlyValidatedUsers = false;
  List<Map<dynamic, dynamic>> usersList = [];
  RangeValues currentRangeValue = const RangeValues(18, 100);
  String? selectedCity;
  List<bool> genderSelections = List.generate(2, (i) => false);

  getUsers({String? start}) async {
    await NetworkManager.instance.usersRef.orderByChild("uid").limitToFirst(pageSize).startAt(start).once().then(
      (DatabaseEvent snapshot) {
        usersList = [];
        Object? vals = snapshot.snapshot.value;

        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          UserController userController = Get.find();
          values.forEach(
            (key, value) {
              if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                usersList.add(value);
              }
            },
          );
        }
      },
    );
    update();
  }

  int searchPageSize = 10;

  getMoreUsers() {
    debugPrint("refreshed");
    if (searchController.text.isEmpty) {
      getUsers(start: usersList.last["uid"]);
    } else {
      searchPageSize += searchPageSize + 10;
      searchUsers();
    }
  }

  searchUsers() async {
    if (searchController.text.isEmpty) {
      getUsers();
    } else {
      List<Map<dynamic, dynamic>> x = [];
      await NetworkManager.instance.usersRef.orderByChild('username').startAt(searchController.text).endAt("${searchController.text}\uf8ff").limitToFirst(searchPageSize).once().then(
        (snapshot) {
          Object? vals = snapshot.snapshot.value;
          if (vals != null) {
            Map<dynamic, dynamic>? values = snapshot.snapshot.value as Map<dynamic, dynamic>;
            UserController userController = Get.find();

            values.forEach(
              (key, value) {
                if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                  x.add(value);
                }
              },
            );
          }
        },
      );

      await NetworkManager.instance.usersRef.orderByChild('userInfo').startAt(searchController.text).endAt("${searchController.text}\uf8ff").limitToFirst(searchPageSize).once().then(
        (DatabaseEvent snapshot) {
          Object? vals = snapshot.snapshot.value;
          if (vals != null) {
            Map<dynamic, dynamic>? values = snapshot.snapshot.value as Map<dynamic, dynamic>;
            UserController userController = Get.find();
            values.forEach(
              (key, value) {
                if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                  x.add(value);
                }
              },
            );
          }
        },
      );
      usersList = x.reversed.toList();
    }

    update();
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  List<String> cities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Amasya',
    'Ankara',
    'Antalya',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Isparta',
    'Mersin',
    'İstanbul',
    'İzmir',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Kahramanmaraş',
    'Mardin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Şanlıurfa',
    'Uşak',
    'Van',
    'Yozgat',
    'Zonguldak',
    'Aksaray',
    'Bayburt',
    'Karaman',
    'Kırıkkale',
    'Batman',
    'Şırnak',
    'Bartın',
    'Ardahan',
    'Iğdır',
    'Yalova',
    'Karabük',
    'Kilis',
    'Osmaniye',
    'Düzce'
  ];
}
