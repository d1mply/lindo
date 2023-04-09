import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ValidatorManager {
  static var defaultEmptyCheckValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Bu alanın doldurulması zorunludur.';
    }
    return null;
  };

  static var passwordCheckValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Bu alanın doldurulması zorunludur.';
    }
    if (value.length < 8) {
      return "Lütfen en az 8 karakter giriniz.";
    }
    if (!value.toString().containsUppercase) {
      return "Lütfen en az 1 büyük karakter giriniz.";
    }
    if (!value.toString().containsLowercase) {
      return "Lütfen en az 1 küçük karakter giriniz.";
    }
    return null;
  };
} // ignore_for_file: unnecessary_this

extension StringLocalization on String {
  String? isValidPassword() {
    if (contains(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$'))) {
      return null;
    } else if (isEmpty) {
      return "Lütfen bu alanı doldurun.";
    } else {
      return 'Şifreniz en az 8, en fazla 16 karakterden oluşmalı ve en az 1 adet büyük harf, en az 1 adet küçük harf ile en az 1 adet rakam içermelidir.';
    }
  }

  String? roundedRating(value) {
    if (isEmpty) {
      return "";
    }
    if (value == "null" || value == null) {
      return "";
    } else {
      return toString().substring(0, 3).toString();
    }
  }

  String secondsFormatter(int time) {
    if (time == 0) {
      return "00:00";
    }
    int minutes = (time / 60).truncate();
    return "${(minutes % 60).toString().padLeft(2, '0')}:${time % 60 == 0 ? "0" : time % 60}";
  }

  bool get containsUppercase => contains(RegExp(r'[A-Z]'));
  bool get containsLowercase => contains(RegExp(r'[a-z]'));
  String get showBeautifulDateWithSlash => split('-').reversed.join('/');

  String toTL() {
    if (this.isEmpty) {
      return "";
    }
    return NumberFormat.currency(
      locale: "eu_EU",
      symbol: "TL",
      decimalDigits: 2,
    ).format(
      double.parse(this.replaceAll(",", ".").toString()),
    );
  }
}

extension FormatDate on DateTime {
  String get toDateFormat {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
