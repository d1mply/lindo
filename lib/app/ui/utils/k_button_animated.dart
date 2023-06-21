import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/state.dart';
import '../../../core/init/theme/color_manager.dart';

class KButtonAnimated extends StatefulWidget {
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

  const KButtonAnimated({
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
  State<KButtonAnimated> createState() => _KButtonAnimatedState();
}

class _KButtonAnimatedState extends State<KButtonAnimated> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          await widget.onTap();
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        height: Utility.dynamicWidthPixel(widget.height != null ? widget.height! : 48),
        width: Get.width,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 18),
          border: Border.all(
            width: 1.2,
            color: widget.borderColor ?? widget.color,
          ),
        ),
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: Utility.dynamicWidthPixel(16),
            ),
        child: isLoading == true
            ? CupertinoActivityIndicator(color: ColorManager.instance.white)
            : (widget.icon != null || widget.rightIcon != null)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.icon ?? const SizedBox(),
                      Text(
                        widget.title ?? "",
                        style: widget.style ??
                            TextStyle(
                              fontFamily: "Rubik-Medium",
                              color: widget.textColor ?? ColorManager.instance.darkGray,
                              fontSize: Utility.dynamicTextSize(widget.fontSize != null ? widget.fontSize! : 16),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                      widget.rightIcon ?? const SizedBox()
                    ],
                  )
                : Center(
                    child: Text(
                      widget.title ?? "",
                      style: widget.style ??
                          TextStyle(
                            fontFamily: "Rubik-Medium",
                            color: widget.textColor ?? ColorManager.instance.darkGray,
                            fontSize: Utility.dynamicTextSize(widget.fontSize != null ? widget.fontSize! : 16),
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
