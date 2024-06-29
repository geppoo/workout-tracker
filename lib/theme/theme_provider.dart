import 'package:flutter/material.dart';
import 'package:workout_tracker/theme/themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = CustomThemes().lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == CustomThemes().lightMode) {
      themeData = CustomThemes().darkMode;
    } else {
      themeData = CustomThemes().lightMode;
    }
  }
}
