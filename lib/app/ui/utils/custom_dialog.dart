import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/init/theme/color_manager.dart';
import '../../../core/base/state.dart';

class CustomDialog {
  showGeneralDialog(
    BuildContext context, {
    String? title,
    bool? dismissible,
    required Widget body,
    Widget? icon,
    bool? isExpanded,
  }) {
    return showModal(
      
      context: context,
      configuration: FadeScaleTransitionConfiguration(barrierDismissible: dismissible ?? true),
      // barrierDismissible: dismissible ?? true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), //this right here
          child: Padding(
            padding: EdgeInsets.all(Utility.dynamicWidthPixel(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    title != null
                        ? Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: ColorManager.instance.darkGray,
                                fontSize: Utility.dynamicTextSize(20),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: icon ??
                          Container(
                            width: Utility.dynamicWidthPixel(36),
                            height: Utility.dynamicWidthPixel(36),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorManager.instance.border_gray,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/svg/crossIcon.svg",
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
                isExpanded == true
                    ? Flexible(
                        child: body,
                      )
                    : body
              ],
            ),
          ),
        );
      },
    );
  }
}
