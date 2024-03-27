import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        // Define other theme properties for light mode
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        // Define other theme properties for dark mode
      );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
