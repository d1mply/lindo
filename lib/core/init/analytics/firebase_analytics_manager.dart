// ignore_for_file: unused_field

import 'package:firebase_analytics/firebase_analytics.dart';

class LogManager {
  static LogManager? _instance;
  static LogManager get instance {
    _instance ??= LogManager._init();
    return _instance!;
  }

  FirebaseAnalytics? _firebaseAnalytics;

  LogManager._init() {
    _firebaseAnalytics = FirebaseAnalytics.instance;
  }
  
}
