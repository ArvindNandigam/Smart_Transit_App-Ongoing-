// lib/components/alert_dialog.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart'; // Correct import path

// A reusable function to show a styled alert dialog.
// It returns `true` if the confirm action is pressed, `false` otherwise.
Future<bool?> showAppAlertDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  // Destructive action color from your theme
  final destructiveColor = isDarkMode
      ? AppColorsDark.destructive
      : AppColorsLight.destructive;

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // Use colors from your theme
        backgroundColor: Theme.of(context).cardColor,
        // Mimics the "rounded-lg" and "border" styles
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ), // From --radius in your CSS
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        // AlertDialogTitle
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // AlertDialogDescription
        content: content,
        // AlertDialogFooter
        actions: <Widget>[
          // AlertDialogCancel
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when cancelled
            },
          ),
          // AlertDialogAction
          TextButton(
            style: TextButton.styleFrom(
              // Apply destructive color if needed
              foregroundColor: isDestructive
                  ? destructiveColor
                  : Theme.of(context).primaryColor,
            ),
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when confirmed
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.end,
      );
    },
  );
}
