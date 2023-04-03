// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/base/state.dart';
import '../../../core/init/theme/color_manager.dart';

class KTextFormField {
  static final KTextFormField _instance = KTextFormField._init();
  static KTextFormField get instance => _instance;
  KTextFormField._init();

  TextFormField widget({
    FocusNode? focusNode,
    required BuildContext context,
    bool? autoFocus,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? mask,
    String? Function(String?)? validation,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
    ValueChanged<String>? onFieldSubmitted,
    TextEditingController? controller,
    TextInputType? keyboardType,
    int? minLines,
    InputBorder? errorBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? border,
    InputBorder? disabledBorder,
    InputDecoration? decoration,
    TextStyle? style,
    TextStyle? labelStyle,
    BoxConstraints? boxConstraints,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    String? hintText,
    String? labelText,
    String? helperText,
    Widget? leadingIcon,
    Widget? suffixIcon,
    bool? obscureText,
    int? maxLength,
    int? maxLines,
    bool? enabled,
    bool? readOnly,
    bool allBorder = false,
    Color? cursorColor,
    AutovalidateMode? validateMode,
    double? fontSize,
    Color? borderColor,
    Color? fillColor,
    FloatingLabelBehavior? floatingLabelBehavior,
  }) {
    return TextFormField(
      autofocus: autoFocus == null ? false : true,
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      cursorColor: cursorColor ?? ColorManager.instance.darkGray,
      textInputAction: textInputAction,
      style: style != null
          ? style
          : TextStyle(
              color: ColorManager.instance.darkGray,
              fontSize: fontSize ?? Utility.dynamicTextSize(16),
            ),
      scrollPadding: EdgeInsets.only(bottom: Utility.dynamicWidthPixel(100)),
      inputFormatters: mask != null ? mask : [],
      textAlignVertical: TextAlignVertical.center,
      obscureText: obscureText ?? false,
      controller: controller,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: validateMode != null ? validateMode : AutovalidateMode.disabled,
      keyboardType: keyboardType ?? TextInputType.text,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      minLines: minLines ?? 1,
      decoration: decoration ??
          InputDecoration(
            counter: const Offstage(),
            prefixIcon: leadingIcon,
            suffixIcon: suffixIcon,
            constraints: boxConstraints,
            filled: fillColor != null ? true : false,
            fillColor: fillColor ?? ColorManager.instance.white,
            contentPadding: allBorder == true ? EdgeInsets.only(left: Utility.dynamicWidthPixel(16), bottom: Utility.dynamicWidthPixel(16)) : null,
            disabledBorder: disabledBorder ??
                UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor ?? ColorManager.instance.border_grey,
                    width: 1,
                  ),
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: ColorManager.instance.border_grey,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: ColorManager.instance.pink,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: ColorManager.instance.border_grey,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: ColorManager.instance.border_grey,
                width: 1,
              ),
            ),
            helperText: helperText,
            helperStyle: helperStyle,
            alignLabelWithHint: true,
            floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            labelText: labelText ?? "",
            hintText: hintText ?? "",
            hintStyle: hintStyle != null
                ? hintStyle.copyWith(
                    color: ColorManager.instance.secondary,
                  )
                : TextStyle(
                    fontSize: Utility.dynamicTextSize(16),
                    color: ColorManager.instance.secondary,
                  ),
            labelStyle: labelStyle ??
                TextStyle(
                  fontSize: Utility.dynamicTextSize(16),
                  color: ColorManager.instance.secondary,
                ),
          ),
      validator: validation,
      onTap: onTap,
    );
  }
}
