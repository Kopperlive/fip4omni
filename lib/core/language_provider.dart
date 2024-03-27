import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale _locale;

  LanguageProvider() {
    // Initialize the locale to a default value, e.g., English
    _locale = Locale('ru');
  }

  Locale get locale => _locale;

  void updateLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
