import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfilePage'),
      ),
      body: SafeArea(
        child: InkWell(
          child: Text('Çıkış Yap'),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
    );
  }
}
