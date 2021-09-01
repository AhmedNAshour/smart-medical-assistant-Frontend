import 'package:chatbot/screens/reportScreen.dart';
import 'package:chatbot/screens/reports.dart';
import 'package:chatbot/services/auth.dart';
import 'package:chatbot/wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('ar'),
        Locale('en'),
      ],
      startLocale: Locale('ar'),
      fallbackLocale: Locale('en'),
      path: 'assets/langs',
      child: MyApp(),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AuthUser>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        builder: EasyLoading.init(),
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => Wrapper(),
          // Report.id: (context) => Report(),
        },
      ),
    );
  }
}
