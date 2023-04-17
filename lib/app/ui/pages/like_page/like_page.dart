
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/like_controller.dart';


class LikePage extends GetView<LikeController> {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikePage'),
      ),
      body: const SafeArea(
        child: Text('LikeController'),
      ),
    );
  }
}
  