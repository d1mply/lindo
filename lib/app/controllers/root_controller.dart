import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lindo/app/ui/pages/explore_page/explore_page.dart';
import 'package:lindo/app/ui/pages/like_page/like_page.dart';
import 'package:lindo/app/ui/pages/messages_page/messages_page.dart';
import 'package:lindo/app/ui/pages/profile_page/profile_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../ui/pages/swipe_page/swipe_page.dart';

class RootController extends GetxController {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  int previousIndex = 0;
  PersistentTabController get controller => _controller;
  int selectedIndex = 0;
  List<Widget> buildScreens = [
    const ExplorePage(),
    const LikePage(),
    const SwipePage(),
    const MessagesPage(),
    const ProfilePage(),
  ];
}
