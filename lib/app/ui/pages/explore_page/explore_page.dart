
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/explore_controller.dart';


class ExplorePage extends GetView<ExploreController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ExplorePage'),
      ),
      body: SafeArea(
        child: Text('ExploreController'),
      ),
    );
  }
}
  