import 'package:flutter/material.dart';

/// A provider class to manage the application's theme state.
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode =
      ThemeMode.dark; // Start with dark mode as per the design

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners(); // This is the crucial part that tells the UI to rebuild
  }
}
