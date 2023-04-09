// ignore_for_file: prefer_conditional_assignment, non_constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';

class ColorManager {
  static final ColorManager _instace = ColorManager._init();
  static ColorManager get instance {
    return _instace;
  }

  ColorManager._init();
  Color get softBlack => const Color(0xFF727272);
  Color get white => const Color(0xffffffff);
  Color get gray => const Color(0xffa5a6ae);
  Color get darkGray => const Color(0xff383838);
  Color get black => const Color(0xff020306);
  Color get secondary => const Color(0xFF7A869A);
  Color get transparent => const Color(0x00000000);
  Color get pink => const Color(0xffFC466B);
  Color get lightPink => const Color(0xFFFBE9ED);
  Color get very_light_pink => const Color(0xFFd8d8d8);
  Color get light_text => const Color(0xffb9b9b9);
  Color get chip_text => const Color(0xff919191);
  Color get green => const Color(0xff22a53c);
  Color get lightGreen => const Color(0xFFEBFFF6);
  Color get yellow => const Color(0xfffff5db);
  Color get red => const Color(0xffd62e1f);
  Color get lightRed => const Color(0xFFFFF4F4);
  Color get boldRed => const Color(0xffFFACA5);
  Color get lightRedText => const Color(0xff9A0000);
  Color get inactive => const Color(0xffcbcbcb);
  Color get border_gray => const Color(0xFFd3d3d3);
  Color get spacer_gray => const Color(0xffececec);
  Color get redColor => const Color(0XFFb00020);
  Color get home_spacer => const Color(0x0c000000);
  Color get soft_gray => const Color(0xff212121).withOpacity(0.6);
  Color get background_gray => const Color(0xFFf7f7f7);
  Color get menu_gray => const Color(0xff555555);
  Color get filter_color => const Color(0xfff8f8f8);
  Color get soft_text => const Color(0xffa7a7a7);
  Color get gray_text => const Color(0xffb4b4b4);
  Color get gray_spacer => const Color(0xfff2f2f2);
  Color get orange => const Color(0xFFff8b2f);
  Color get light_orange => const Color(0xFFFFF8F2);
  Color get blue => const Color(0xff0091ff);
  Color get light_blue => const Color(0xFFF5FBFF);
  Color get product_title => const Color(0xff2b2b2b);
  Color get border_ligth => const Color(0xffe6e6e6);
  Color get soft_gray_text => const Color(0xff7b7b7b);
  Color get ice_blue => const Color(0xfff8fcfb);
  Color get dark_green_blue => const Color(0xFF255f4e);
  Color get spacer2 => const Color(0xffd0d0d0);
  Color get duck_egg_blue => const Color(0xFFf1f8fc);
  Color get pale_grey => const Color(0xfff8fbfc);
  Color get dark_grey_blue => const Color(0xFF26555e);
  Color get brown_grey => const Color(0xff838383);
  Color get greyPassiveText => const Color(0xFF706D6E);
  Color get filled_gray => const Color(0xfffafafa);
  Color get info_yellow => const Color(0xfffff7e0);
  Color get info_yellow_text => const Color(0xFF995100);
  Color get soft_blue => const Color(0xffe3f5fb);
  Color get dark_blue => const Color(0xff00899b);
  Color get yellow_star => const Color(0xfff7b500);
  Color get discount_text_color => const Color(0xff6d7278);
  Color get unselected_button_color => const Color(0xffbbbbbb);
  Color get border_color => const Color(0xffdddddd);
  Color get textField_input_color => const Color(0xff444444);
  Color get warm_grey_four => const Color(0xff8e8e8e);
  Color get scaffold_background_color => const Color(0xfff0f0f0);
  Color get unselected_color => const Color(0xffd6d6d6);
  Color get close_button_color => const Color(0xfff3f3f3);
  Color get master_class_text_color => const Color(0xff856200);
  Color get money_blue => const Color(0xff56b2f8);
  Color get dateShow => const Color(0xff5c5c5c);
  Color get money_green => const Color(0xff73ba81);
  Color get money_red => const Color(0xffe63946);
  Color get background_container => const Color(0xfff1f1f1);
  Color get bottom_sheet_text_color => const Color(0xff898989);
  Color get resume_text => const Color(0xff727272);
  Color get resume_text_underline_button => const Color(0xff939393);
  Color get sms_color_grey => const Color(0xff8c8c8c);
  Color get basket_register_yellow => const Color(0xfffff9d1);
  Color get date_popup_list_text_color => const Color(0xff292929);
  Color get date_popup_text_button_color => const Color(0xff007aff);
  Color get date_popup_area_color => const Color(0xfffafaf8);
  Color get border_grey => const Color(0xffe5e5e5);
  Color get evaluation_result_text_green => const Color(0xff4e9154);
  Color get degree_color => const Color(0xff9b9b9b);
  Color get rating_background => const Color(0xfff6f6f6);
  Color get easy_refund => const Color(0xFFD67200).withAlpha(1);
  Color get button_red_color => const Color(0xffed2024);
  Color get soft_blue2 => const Color(0xffe0f2ff);
  Color get dark_blue2 => const Color(0xff007ad6);
  Color get dialog_grey => const Color(0xff636363);
  Color get green_text_color => const Color(0xff00b463);
  Color get background => const Color(0xfff0fff8);
  Color get bottom_sheet_grey_color => const Color(0xff707070);
  Color get green_button => const Color(0xffabc579);
  Color get discount_dark => const Color(0xff333333);
  Color get throught_line => const Color(0xff9f9f9f);
  Color get soft_orange_background => const Color(0xfff9e9d6);
  Color get bright_orange => const Color(0xfffa6400);
  Color get box_shadow_black => const Color(0x19000000);
  Color get border_black => const Color(0xff1c1c1c);
  Color get link_box_yellow => const Color(0xffffbf2f);
  Color get soft_yellow => const Color(0x0affd12e);
  Color get dark_red => const Color(0xffa42e30);
  Color get red_text => const Color(0xffa42e2f);
  Color get open_gray => const Color(0xffeeeeee);
  Color get basket_gray => const Color(0xff848484);
  Color get shadow => const Color(0x29000000);
  Color get live_channel_text => const Color(0xFF4AC356);
  Color get dot_color => const Color(0x80ffffff).withOpacity(0.5);
  Color get coupon_green => const Color(0xFF14AE5C);
  Color get border_color2 => const Color(0xFFDFDFDF);
  Color get gray75 => const Color(0xFF757575);
  Color get orangeDark => const Color(0xFFFF7142);
  Color get bottom_nav_bar_color => const Color(0xe6ffffff).withOpacity(0.9);
  Color get dark_green => const Color(0xFF0E9576);
  Color get navy_blue => const Color(0xff004970);
  Color get amber => const Color(0xffffc107);
  Color get indigo => const Color(0xff3f51b5);
  Color get grey => const Color(0xff9e9e9e);
  Color get cyan => const Color(0xff00bcd4);
  Color get grey300 => const Color(0xffe0e0e0);
  Color get cupertino_grey => const Color(0xFF8E8E93);
  Color get red50 => const Color(0xffffebee);
  Color get discount_green => const Color(0xff3c862d);
  Color get discount_red => const Color(0xfff22222);
  Color get box_yellow => const Color(0xfffbf8e3);
  Color get container_brown => const Color(0xff8b703e);
  Color get border_yellow => const Color(0xffe5db99);
  Color get box_blue => const Color(0xffceedf1);
  Color get text_gray => const Color(0xff767676);
  Color get background_blue_gray => const Color(0xffF4F7FC);
  Color get gradient1 => const Color(0xffFF8801);
  Color get gradient2 => const Color(0xff4996D7);
  Color get gradient3 => const Color(0xffFF89AA);
  Color get gradient4 => const Color(0xff804401);
  Color get force_update_blue => const Color(0xff262F5F);
  Color get dusk => const Color(0xFF4C4F77);
  Color get gradient1Color => const Color(0xffE0BAD3);
  Color get gradient2Color => const Color(0xff4CA5F2);
  Color get softBlueColor => const Color(0xff68A3D8);
  Color get gradient3Color => const Color(0xff283048);
  Color get gradient4Color => const Color(0xff859398);

  MaterialColor get materialGray => const MaterialColor(
        0xff000000,
        <int, Color>{
          50: Colors.black,
          100: Colors.black,
          200: Colors.black,
          300: Colors.black,
          400: Colors.black,
          500: Colors.black,
          600: Colors.black,
          700: Colors.black,
          800: Colors.black,
          900: Colors.black,
        },
      );
}
