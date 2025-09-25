// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Common text theme used by both light and dark themes
  static const _textTheme = TextTheme(
    // h1
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500),
    // h2
    headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
    // h3
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
    // h4
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
    // p, input
    bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    // label, button
    labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorsLight.background,
    primaryColor: AppColorsLight.primary,
    fontFamily: 'YourFontFamily', // <-- TODO: Add your font family name
    cardColor: AppColorsLight.card,
    dividerColor: AppColorsLight.border,
    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.primary,
      onPrimary: AppColorsLight.primaryForeground,
      secondary: AppColorsLight.secondary,
      onSecondary: AppColorsLight.secondaryForeground,
      surface: AppColorsLight.card,
      onSurface: AppColorsLight.cardForeground,
      error: AppColorsLight.destructive,
      onError: AppColorsLight.destructiveForeground,
    ),
    textTheme: _textTheme.apply(
      bodyColor: AppColorsLight.foreground,
      displayColor: AppColorsLight.foreground,
    ),
    // You can also style specific widgets here
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // --radius: 0.625rem
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsDark.background,
    primaryColor: AppColorsDark.primary,
    fontFamily: 'YourFontFamily', // <-- TODO: Add your font family name
    cardColor: AppColorsDark.card,
    dividerColor: AppColorsDark.border,
    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.primaryForeground,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.secondaryForeground,
      surface: AppColorsDark.card,
      onSurface: AppColorsDark.cardForeground,
      error: AppColorsDark.destructive,
      onError: AppColorsDark.destructiveForeground,
    ),
    textTheme: _textTheme.apply(
      bodyColor: AppColorsDark.foreground,
      displayColor: AppColorsDark.foreground,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // --radius: 0.625rem
        borderSide: BorderSide.none,
      ),
    ),
  );
}
