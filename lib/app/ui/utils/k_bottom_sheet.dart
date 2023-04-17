import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../core/base/state.dart';
import '../../../core/init/theme/color_manager.dart';

class KBottomSheet {
  static Future show({
    required Widget content,
    Color? bottomSheetColor,
    String? title,
    required BuildContext context,
    bool? withoutHeader,
    bool showCloseButton = false,
    bool useRootNavigator = false,
    isDismissible,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible ?? true,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
      constraints: BoxConstraints(
        maxHeight: Utility.dynamicHeight(0.9),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: bottomSheetColor ?? ColorManager.instance.white,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Utility.dynamicWidthPixel(16),
                  right: Utility.dynamicWidthPixel(16),
                  top: Utility.dynamicWidthPixel(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    withoutHeader != true
                        ? Padding(
                            padding: EdgeInsets.only(
                              bottom: Utility.dynamicWidthPixel(16),
                            ),
                            child: SizedBox(
                              height: Utility.dynamicWidthPixel(36),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      title ?? "",
                                      style: TextStyle(
                                        fontFamily: "Rubik-Medium",
                                        fontSize: Utility.dynamicTextSize(18),
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.instance.darkGray,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Flexible(child: content),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
