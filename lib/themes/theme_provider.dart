import 'package:flutter/material.dart';
import 'package:x_clone/themes/dark_mode.dart';
import 'package:x_clone/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initialy, set it as light mode
  ThemeData _themeData = lightMode;

  // getters
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle between dark and light mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
