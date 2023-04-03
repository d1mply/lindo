import 'package:flutter/material.dart';

import '../../../core/base/state.dart';
import '../../../core/init/theme/color_manager.dart';

class KButton extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final Color? borderColor;
  final Color color;
  final Function onTap;
  final Color? textColor;
  final Widget? icon;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? rightIcon;

  const KButton({
    Key? key,
    this.title,
    this.style,
    this.borderColor,
    required this.color,
    required this.onTap,
    this.textColor,
    this.icon,
    this.height,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.rightIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: Utility.dynamicWidthPixel(height != null ? height! : 48),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 18),
          border: Border.all(
            width: 1.2,
            color: borderColor ?? color,
          ),
        ),
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: Utility.dynamicWidthPixel(16),
            ),
        child: (icon != null || rightIcon != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox(),
                  Text(
                    title ?? "",
                    style: style ??
                        TextStyle(
                          fontFamily: "Rubik-Medium",
                          color: textColor ?? ColorManager.instance.darkGray,
                          fontSize: Utility.dynamicTextSize(fontSize != null ? fontSize! : 16),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                  rightIcon ?? const SizedBox()
                ],
              )
            : Center(
                child: Text(
                  title ?? "",
                  style: style ??
                      TextStyle(
                        fontFamily: "Rubik-Medium",
                        color: textColor ?? ColorManager.instance.darkGray,
                        fontSize: Utility.dynamicTextSize(fontSize != null ? fontSize! : 16),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
