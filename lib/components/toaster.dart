// lib/services/toaster.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppToaster {
  static void show(BuildContext context, {required String message}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isDarkMode
          ? AppColorsDark.popover
          : AppColorsLight.popover,
      textColor: isDarkMode
          ? AppColorsDark.popoverForeground
          : AppColorsLight.popoverForeground,
      fontSize: 16.0,
    );
  }

  static void showSuccess(BuildContext context, {required String message}) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green.shade700,
      textColor: Colors.white,
    );
  }

  static void showError(BuildContext context, {required String message}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDarkMode
        ? AppColorsDark.destructive
        : AppColorsLight.destructive;

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: errorColor,
      textColor: Colors.white,
    );
  }
}
