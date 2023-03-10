import 'package:afar_cabs_user/app_landing_page/view/app_landing_page.dart';
import 'package:afar_cabs_user/language_change_provider.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';
import 'home_page/view/home_page_view.dart';


int? initScreen;
bool? isLoggedIn;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');

  isLoggedIn = (prefs.getBool('isLoggedIn') == null)
      ? false
      : prefs.getBool('isLoggedIn');
  print('isLoggedIn $isLoggedIn');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    windowData = windowData.copyWith(
      textScaleFactor:
          windowData.textScaleFactor > 1.4 ? 1.4 : windowData.textScaleFactor,
    );

    return ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
        builder: (context) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // this code is used for multi language support
          locale: Provider.of<LanguageChangeProvider>(context, listen: true)
              .currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          // upto this. multi language support code
          title: 'Afar Cabs',
          initialRoute: initScreen == 0 || initScreen == null ? "onboard" : "/",
          routes: {
            "/": (context) => isLoggedIn == null || isLoggedIn == false
                ? SignInPage()
                : HomePage(),
            "onboard": (context) => const AppLandingPage(),
          },
        ),
      ),
    );
  }
}
