import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get_storage/get_storage.dart';
import 'package:lindo/app/ui/pages/splash_page/splash_page.dart';

import 'app/controllers/usercontroller.dart';
import 'core/init/theme/app_theme_light.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  timeago.setLocaleMessages('tr', timeago.TrMessages());
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  if (!kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  /*

  NetworkManager.instance.forceUpdateRef.set(
    {},
  );
  */

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    debugPrint("Push Token: $fcmToken");
  }).onError((err) {
    debugPrint(err.toString());
  });
  Get.put(UserController(), permanent: true);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, context) => GetMaterialApp(
        enableLog: true,
        navigatorKey: Get.key,
        home: const SplashPage(),
        logWriterCallback: localLogWriter,
        useInheritedMediaQuery: true,
        title: "Lindo",
        theme: AppThemeLight.instance.theme,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        opaqueRoute: Get.isOpaqueRouteDefault,
        popGesture: Get.isPopGestureEnable,
        transitionDuration: Get.defaultTransitionDuration,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr'),
        ],
        locale: const Locale('tr'),
      ),
    );
  }

  void localLogWriter(String text, {bool isError = false}) {
    if (kDebugMode) {
      debugPrint(text);

      return;
    }
  }
}
