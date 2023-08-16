// ignore_for_file: empty_catches

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/usercontroller.dart';
import 'package:lindo/config.dart';
import 'package:lindo/core/init/cache/cache_manager.dart';

import '../../core/init/network/network_manager.dart';
import '../../core/init/theme/color_manager.dart';
import '../ui/pages/market_page/market_page.dart';
import '../ui/utils/k_bottom_sheet.dart';
import '../ui/utils/k_button.dart';

class ExploreController extends GetxController {
  TextEditingController searchController = TextEditingController();
  int pageSize = 300;
  int searchPageSize = 300;
  ScrollController scrollController = ScrollController();
  bool onlyValidatedUsers = false;
  bool selectedOnlyValidatedUsers = false;
  List<Map<dynamic, dynamic>> usersList = [];
  List<Map<dynamic, dynamic>> boostedUsers = [];

  RangeValues currentRangeValue = const RangeValues(18, 100);
  String? selectedCity;
  List<bool> genderSelections = List.generate(2, (i) => false);
  int minAge = 18;
  int maxAge = 100;
  List<bool> selectedGenderSelections = [false, false];

  getUsers({String? start}) async {
    isLoading = true;
    await NetworkManager.instance.usersRef.orderByChild("uid").limitToFirst(pageSize).once().then(
      (DatabaseEvent snapshot) {
        usersList = [];
        Object? vals = snapshot.snapshot.value;
        List<Map<dynamic, dynamic>> temp = [];

        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          UserController userController = Get.find();

          values.forEach(
            (key, value) {
              if (FirebaseAuth.instance.currentUser != null) {
                if (value != null) {
                  if (value["uid"] != null) {
                    if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                      temp.add(value);
                    }
                  }
                }
              }
            },
          );

          Set<Map<dynamic, dynamic>> uniqueSet = {};
          for (var element in temp) {
            uniqueSet.add(element);
          }

          List<Map<dynamic, dynamic>> uniqueList = uniqueSet.toList();
          usersList = uniqueList;
        }
      },
    );
    filterUsers();
    update();
    isLoading = false;
  }

  Future getBoostedUsers() async {
    await NetworkManager.instance.usersRef.once().then(
      (DatabaseEvent snapshot) {
        boostedUsers = [];
        Object? vals = snapshot.snapshot.value;

        if (vals != null) {
          Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
          UserController userController = Get.find();
          values.forEach(
            (key, value) {
              if (FirebaseAuth.instance.currentUser != null) {
                if (value != null) {
                  if (value["uid"] != null) {
                    if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                      if (value["boostEndDate"] != null) {
                        int boostEndDate = value["boostEndDate"] as int;
                        if (DateTime.now().millisecondsSinceEpoch < boostEndDate) {
                          boostedUsers.add(value);
                        }
                      }
                    }
                  }
                }
              }
            },
          );
        }
      },
    );

    update();
  }

  filterUsers() {
    bool genderSelection = false;
    if (selectedGenderSelections.first == true || selectedGenderSelections.last == true) {
      genderSelection = true;
    }
    if (genderSelection == true || currentRangeValue.start != 18 || currentRangeValue.end != 100 || selectedOnlyValidatedUsers == true || selectedCity != null) {
      List<int> indexes = [];
      List<Map<dynamic, dynamic>> temps = [];

      for (int i = 0; i < usersList.length; i++) {
        if (usersList[i]["year"] != null) {
          if (usersList[i]["year"] >= minAge && usersList[i]["year"] <= maxAge) {
          } else {
            indexes.add(i);
          }
        }
        if (genderSelection == true) {
          if (selectedGenderSelections.first == true && selectedGenderSelections.last == true) {
          } else {
            if (usersList[i]["gender"] == 1) {
              if (selectedGenderSelections.first == true) {
              } else {
                indexes.add(i);
              }
            } else if (usersList[i]["gender"] == 2) {
              if (selectedGenderSelections.last == true) {
              } else {
                indexes.add(i);
              }
            }
          }
        }
        if (selectedOnlyValidatedUsers == true) {
          if (usersList[i]["validate"] != null) {
            if (usersList[i]["validate"] == false) {
              indexes.add(i);
            }
          } else {
            indexes.add(i);
          }
        }
        if (usersList[i]["location"] != null) {
          if (selectedCity != null) {
            if (selectedCity != usersList[i]["location"]) {
              indexes.add(i);
            } else {
              temps.add(usersList[i]);
            }
          }
        }
      }
      indexes = removeDuplicates(indexes);
      indexes.sort((b, a) => a.compareTo(b));

      try {
        for (int i = 0; i < indexes.length; i++) {
          usersList.removeAt(indexes[i]);
        }
      } catch (e) {}

      if (indexes.isEmpty && selectedCity != null) {
        usersList = temps;
      }
      update();
    }
    update();
  }

  List<int> removeDuplicates(List<int> list) {
    Set<int> uniqueElements = Set<int>.from(list);
    List<int> result = uniqueElements.toList();
    return result;
  }

  bool isLoading = false;

  Object? lastvals;
  Future getMoreUsers() async {
    isLoading = true;
    debugPrint("refreshed");
    if (searchController.text.isEmpty) {
      String? start = usersList.last["uid"];
      if (start != null) {
        List<Map<dynamic, dynamic>> temp = usersList;
        pageSize = pageSize * 2;
        await NetworkManager.instance.usersRef.orderByChild("uid").limitToFirst(pageSize).once().then(
          (DatabaseEvent snapshot) {
            Object? vals = snapshot.snapshot.value;
            lastvals = vals;
            if (vals != lastvals) {
              if (vals != null) {
                Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
                UserController userController = Get.find();
                values.forEach(
                  (key, value) {
                    if (value["uid"] != FirebaseAuth.instance.currentUser!.uid && !userController.blockedUsers.contains(value["uid"])) {
                      temp.add(value);
                    }
                  },
                );
              }
            }
          },
        );
        Set<Map<dynamic, dynamic>> uniqueSet = {};
        for (var element in temp) {
          uniqueSet.add(element);
        }

        List<Map<dynamic, dynamic>> uniqueList = uniqueSet.toList();
        usersList = uniqueList;
        await filterUsers();
      }
    } else {
      searchPageSize += searchPageSize + 20;
      await searchUsers();
    }
    isLoading = false;
  }

  searchUsers() async {
    if (searchController.text.isEmpty) {
      pageSize = pageSize * 2;
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
    getBoostedUsers();
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          getMoreUsers();
        }
      },
    );
    super.onInit();
  }

  List<String> cities = ['Tümü', 'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara', 'Antalya', 'Artvin', 'Aydın', 'Balıkesir', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay', 'Isparta', 'Mersin', 'İstanbul', 'İzmir', 'Kars', 'Kastamonu', 'Kayseri', 'Kırklareli', 'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Kahramanmaraş', 'Mardin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli', 'Şanlıurfa', 'Uşak', 'Van', 'Yozgat', 'Zonguldak', 'Aksaray', 'Bayburt', 'Karaman', 'Kırıkkale', 'Batman', 'Şırnak', 'Bartın', 'Ardahan', 'Iğdır', 'Yalova', 'Karabük', 'Kilis', 'Osmaniye', 'Düzce'];
}

addNotification(String? uid, String message) async {
  try {
    DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();
    final data = user.value as Map<Object?, Object?>;

    if (uid == FirebaseAuth.instance.currentUser!.uid) {
      return;
    }
    String? image;
    if (data["images"] != null) {
      image = (data["images"] as List).first;
    }
    NetworkManager.instance.notificationRef.push().set(
      {
        "uid": uid,
        "image": image,
        "senderUid": FirebaseAuth.instance.currentUser!.uid,
        "sender": data["name"],
        "message": message,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "isRead": false,
      },
    );
    if (uid != null) {
      Map<dynamic, dynamic>? sendUser = await getUser(uid);
      if (sendUser?["token"] != null) {
        Dio dio = Dio();
        dio.post(
          "https://fcm.googleapis.com/fcm/send",
          options: Options(
            headers: {
              "Authorization": "key=$firebasePushServerKey",
              "Content-Type": "application/json",
            },
          ),
          data: {
            "to": sendUser?["token"],
            "notification": {
              "body": message,
              "priority": "high",
              "title": data["name"],
            }
          },
        );
      }
    }
  } finally {}
}

addNotification2(String? uid, String message, String title) async {
  try {
    DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();
    final data = user.value as Map<Object?, Object?>;

    if (uid == FirebaseAuth.instance.currentUser!.uid) {
      return;
    }
    String? image;
    if (data["images"] != null) {
      image = (data["images"] as List).first;
    }
    NetworkManager.instance.notificationRef.push().set(
      {
        "uid": uid,
        "image": image,
        "senderUid": FirebaseAuth.instance.currentUser!.uid,
        "sender": data["name"],
        "message": message,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "isRead": false,
      },
    );
    if (uid != null) {
      Map<dynamic, dynamic>? sendUser = await getUser(uid);
      if (sendUser?["token"] != null) {
        Dio dio = Dio();
        dio.post(
          "https://fcm.googleapis.com/fcm/send",
          options: Options(
            headers: {
              "Authorization": "key=$firebasePushServerKey",
              "Content-Type": "application/json",
            },
          ),
          data: {
            "to": sendUser?["token"],
            "notification": {
              "body": message,
              "priority": "high",
              "title": title,
            }
          },
        );
      }
    }
  } finally {}
}

Future<Map<dynamic, dynamic>?> getUser(String uid) async {
  Map<dynamic, dynamic>? user;

  DataSnapshot user0 = await NetworkManager.instance.getUserDetailsWithId(uid);
  if (user0.exists) {
    Object? vals = user0.value;
    if (vals != null) {
      user = user0.value as Map<dynamic, dynamic>;
    }
  }
  return user;
}

bool swipaAble = true;

swipeRight(
  String? uid,
  context,
) async {
  String key = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  int? cacheKey = CacheManager.instance.getValue(key);
  if (cacheKey != null) {
    swipaAble = true;
    CacheManager.instance.setValue(key, (cacheKey + 1));
    if (cacheKey + 1 <= 6) {
      DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();
      final data = user.value as Map<Object?, Object?>;

      if (uid == FirebaseAuth.instance.currentUser!.uid) {
        return;
      }

      addNotification2(
        uid,
        "Biri Seni Beğendi 😍🥰",
        "🎉🥳 Yeni Beğenii! 🥳🎉",
      );
      NetworkManager.instance.swipe.push().set(
        {
          "uid": uid,
          "image": (data["images"] as List).first ?? "",
          "senderUid": FirebaseAuth.instance.currentUser!.uid,
          "sender": data["name"],
          "location": data["location"],
          "birth": "${DateTime.now().year - int.parse(data["birth"].toString().split("-").first.toString())}",
          "timestamp": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      UserController userController = Get.find();
      if (!userController.isPremium) {
        swipaAble = false;
        KBottomSheet.show(
          context: context,
          title: "Kaydırma",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Premium olmayan kullanıcılar günde sadece 6 tane sağa kaydırma yapabilir. Daha fazla kaydırma yapabilmek için premium olmalısınız.",
                ),
              ),
              KButton(
                color: ColorManager.instance.pink,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    () => const MarketPage(
                      type: 2,
                    ),
                  );
                },
                title: "Premium Ol",
                borderColor: ColorManager.instance.pink,
                textColor: ColorManager.instance.white,
              ),
            ],
          ),
        );
      } else {
        swipaAble = true;
        DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();
        final data = user.value as Map<Object?, Object?>;

        if (uid == FirebaseAuth.instance.currentUser!.uid) {
          return;
        }
        addNotification2(
          uid,
          "Biri Seni Beğendi 😍🥰",
          "🎉🥳 Yeni Beğenii! 🥳🎉",
        );
        NetworkManager.instance.swipe.push().set(
          {
            "uid": uid,
            "image": (data["images"] as List).first ?? "",
            "senderUid": FirebaseAuth.instance.currentUser!.uid,
            "sender": data["name"],
            "location": data["location"],
            "birth": "${DateTime.now().year - int.parse(data["birth"].toString().split("-").first.toString())}",
            "timestamp": DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
    }
  } else {
    CacheManager.instance.setValue(key, 1);
    DataSnapshot user = await NetworkManager.instance.getCurrentUserDetails();
    final data = user.value as Map<Object?, Object?>;

    if (uid == FirebaseAuth.instance.currentUser!.uid) {
      return;
    }

    NetworkManager.instance.swipe.push().set(
      {
        "uid": uid,
        "image": (data["images"] as List).first ?? "",
        "senderUid": FirebaseAuth.instance.currentUser!.uid,
        "sender": data["name"],
        "location": data["location"],
        "birth": "${DateTime.now().year - int.parse(data["birth"].toString().split("-").first.toString())}",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
