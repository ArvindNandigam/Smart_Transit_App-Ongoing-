// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

// Colors for Light Theme
class AppColorsLight {
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF252525);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF252525);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF252525);
  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFF1F1F8);
  static const Color secondaryForeground = Color(0xFF030213);
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color accent = Color(0xFFE9EBEF);
  static const Color accentForeground = Color(0xFF030213);
  static const Color destructive = Color(0xFFD4183D);
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  static const Color border = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color switchBackground = Color(0xFFCBCED4);
}

// Colors for Dark Theme
class AppColorsDark {
  static const Color background = Color(0xFF252525);
  static const Color foreground = Color(0xFFFAFAFA);
  static const Color card = Color(0xFF252525);
  static const Color cardForeground = Color(0xFFFAFAFA);
  static const Color popover = Color(0xFF252525);
  static const Color popoverForeground = Color(0xFFFAFAFA);
  static const Color primary = Color(0xFFFAFAFA);
  static const Color primaryForeground = Color(0xFF333333);
  static const Color secondary = Color(0xFF444444);
  static const Color secondaryForeground = Color(0xFFFAFAFA);
  static const Color muted = Color(0xFF444444);
  static const Color mutedForeground = Color(0xFFB4B4B4);
  static const Color accent = Color(0xFF444444);
  static const Color accentForeground = Color(0xFFFAFAFA);
  static const Color destructive = Color(0xFF7B2D26);
  static const Color destructiveForeground = Color(0xFFE2A9A2);
  static const Color border = Color(0xFF444444);
  static const Color inputBackground = Color(
    0xFF444444,
  ); // Assumed from --input
  static const Color switchBackground = Color(
    0xFF555555,
  ); // Assumed, not in dark css
}
