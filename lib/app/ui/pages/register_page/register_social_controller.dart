// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class RegisterSocialController extends GetxController {
  int currentStep = 1;
  int selectedGender = 0;
  DateTime? selectedDateTime;
  PageController pageController = PageController(initialPage: 0);
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  XFile? image1, image2, image3, image4;
  final formKey1 = GlobalKey<FormState>();

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

  Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      UserCredential user = await FirebaseAuth.instance.signInWithCredential(facebookCredential);

      return user;
    } else {
      return null;
    }
  }

  Future signInWithApple() async {
    try {
      UserCredential user = await appleSignIn();
      return user;
    } catch (e) {
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> appleSignIn() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
