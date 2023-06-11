import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lindo/app/controllers/root_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../../core/base/state.dart';
import '../../../../core/init/theme/color_manager.dart';

import '../login_page/login_page.dart';

class RootPage extends GetView<RootController> {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.instance.transparent,
      resizeToAvoidBottomInset: false,
      // drawer: const CustomDrawer(),
      drawerEnableOpenDragGesture: false,

      body: GetBuilder<RootController>(
        init: RootController(),
        builder: (c) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final isSignedIn = snapshot.data != null;
              if (!isSignedIn) {
                return const LoginPage();
              } else {
                return PersistentTabView(
                  context,
                  controller: c.controller,
                  screens: c.buildScreens,
                  onItemSelected: (index) {
                    c.selectedIndex = index;
                    c.update();
                  },
                  backgroundColor: ColorManager.instance.bottom_nav_bar_color,
                  navBarHeight: 52,
                  items: [
                    PersistentBottomNavBarItem(
                        activeColorSecondary: ColorManager.instance.pink,
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: Utility.dynamicWidthPixel(4)),
                          child: SvgPicture.asset(
                            "assets/svg/nav1.svg",
                            color: c.selectedIndex == 0 ? ColorManager.instance.pink : null,
                          ),
                        ),
                        textStyle: TextStyle(
                          color: ColorManager.instance.menu_gray,
                          fontSize: Utility.dynamicTextSize(10),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                        activeColorPrimary: ColorManager.instance.darkGray,
                        inactiveColorPrimary: ColorManager.instance.cupertino_grey),
                    PersistentBottomNavBarItem(
                      activeColorSecondary: ColorManager.instance.pink,
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: Utility.dynamicWidthPixel(4)),
                        child: SvgPicture.asset(
                          "assets/svg/nav2.svg",
                          color: c.selectedIndex == 1 ? ColorManager.instance.pink : null,
                        ),
                      ),
                      textStyle: TextStyle(
                        color: ColorManager.instance.menu_gray,
                        fontSize: Utility.dynamicTextSize(10),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                      activeColorPrimary: ColorManager.instance.darkGray,
                      inactiveColorPrimary: ColorManager.instance.cupertino_grey,
                    ),
                    PersistentBottomNavBarItem(
                      activeColorSecondary: ColorManager.instance.pink,
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: Utility.dynamicWidthPixel(4)),
                        child: SvgPicture.asset(
                          "assets/svg/nav3.svg",
                          color: c.selectedIndex == 2 ? ColorManager.instance.pink : null,
                        ),
                      ),
                      textStyle: TextStyle(
                        color: ColorManager.instance.menu_gray,
                        fontSize: Utility.dynamicTextSize(10),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                      activeColorPrimary: ColorManager.instance.darkGray,
                      inactiveColorPrimary: ColorManager.instance.cupertino_grey,
                    ),
                    PersistentBottomNavBarItem(
                      activeColorSecondary: ColorManager.instance.pink,
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: Utility.dynamicWidthPixel(4)),
                        child: SvgPicture.asset(
                          c.selectedIndex == 3 ? "assets/svg/nav4.svg" : "assets/svg/nav4_off.svg",
                        ),
                      ),
                      textStyle: TextStyle(
                        color: ColorManager.instance.menu_gray,
                        fontSize: Utility.dynamicTextSize(10),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                      activeColorPrimary: ColorManager.instance.darkGray,
                      inactiveColorPrimary: ColorManager.instance.cupertino_grey,
                    ),
                    PersistentBottomNavBarItem(
                      activeColorSecondary: ColorManager.instance.pink,
                      icon: SvgPicture.asset(
                        "assets/svg/nav5.svg",
                        color: c.selectedIndex == 4 ? ColorManager.instance.pink : null,
                      ),
                      textStyle: TextStyle(
                        color: ColorManager.instance.menu_gray,
                        fontSize: Utility.dynamicTextSize(10),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                      activeColorPrimary: ColorManager.instance.darkGray,
                      inactiveColorPrimary: ColorManager.instance.cupertino_grey,
                    ),
                  ],
                  confineInSafeArea: true,
                  resizeToAvoidBottomInset: false,
                  stateManagement: true,
                  hideNavigationBarWhenKeyboardShows: true,
                  decoration: NavBarDecoration(
                    colorBehindNavBar: ColorManager.instance.white,
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: const ItemAnimationProperties(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle.style13,
                );
              }
            },
          );
        },
      ),
    );
  }
}
