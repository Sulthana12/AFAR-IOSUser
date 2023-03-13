import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider with ChangeNotifier {
  Locale _currentLocale = const Locale("en");

  Locale get currentLocale => _currentLocale;

  intialize() async {
    final prefs = await SharedPreferences.getInstance();
    final String? language = prefs.getString('lang');
    if (language != null) {
      _currentLocale = Locale(prefs.getString('lang') ?? 'en');
      Get.updateLocale(_currentLocale);
    }
    notifyListeners();
  }

  Future<void> changeLocale(String locale) async {
    _currentLocale = Locale(locale);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', locale);
    Get.updateLocale(_currentLocale);
    notifyListeners();
  }
}
