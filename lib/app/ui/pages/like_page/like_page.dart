
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/like_controller.dart';


class LikePage extends GetView<LikeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LikePage'),
      ),
      body: SafeArea(
        child: Text('LikeController'),
      ),
    );
  }
}
  