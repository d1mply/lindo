import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RegisterController extends GetxController {
  int currentStep = 1;
  int selectedGender = 0;
  bool showPassword = false;
  DateTime? selectedDateTime;
  PageController pageController = PageController(initialPage: 0);
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  XFile? image1, image2, image3, image4;
  final formKey1 = GlobalKey<FormState>();

  final formKey2 = GlobalKey<FormState>();
  next() {
    pageController.jumpToPage(currentStep);
    currentStep = currentStep + 1;
    update();
  }

  prev() {
    int currentS = pageController.page?.round() ?? 0;
    if (currentS == 0) {
      Get.back();
    } else {
      currentStep = currentS;
      pageController.previousPage(curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
      update();
    }
  }

  List<String> images = [];
  
  uploadImage(XFile? image) async {
    if (image != null) {
      String downloadUrl = "";
      var uuid = const Uuid();
      String filename = uuid.v1();
      Reference ref = FirebaseStorage.instance.ref().child(filename);
      await ref.putFile(File(image.path));
      downloadUrl = await FirebaseStorage.instance.ref(filename).getDownloadURL();
      if (downloadUrl != "") {
        images.add(downloadUrl);
      }
    }
  }

  Future<bool> uploadImages() async {
    await uploadImage(image1);
    await uploadImage(image2);
    await uploadImage(image3);
    await uploadImage(image4);
    return true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

      if (user.user != null) {
        if (user.user?.email != null) {
          try {
            return user;
          } catch (e) {
            return null;
          }
        }
      }
      return null;
    } else {
      return null;
    }
  }
}
