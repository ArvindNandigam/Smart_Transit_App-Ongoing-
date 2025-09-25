// lib/components/alert.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

// Enum to define the alert variants, similar to the cva variants
enum AlertVariant {
  def, // 'default' is a reserved keyword in Dart
  destructive,
}

class AppAlert extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget description;
  final AlertVariant variant;

  const AppAlert({
    super.key,
    this.icon,
    required this.title,
    required this.description,
    this.variant = AlertVariant.def,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // --- Determine Colors based on Variant ---
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (variant) {
      case AlertVariant.destructive:
        backgroundColor = isDarkMode ? AppColorsDark.card : AppColorsLight.card;
        foregroundColor = isDarkMode
            ? AppColorsDark.destructive
            : AppColorsLight.destructive;
        borderColor = isDarkMode
            ? AppColorsDark.destructive
            : AppColorsLight.destructive.withOpacity(0.5);
        break;
      // Correct version
      case AlertVariant.def:
        backgroundColor = isDarkMode ? AppColorsDark.card : AppColorsLight.card;
        foregroundColor = isDarkMode
            ? AppColorsDark.foreground
            : AppColorsLight.foreground;
        borderColor = Theme.of(context).dividerColor;
        break;
    }
    return Container(
      width: double.infinity,
      // Mimics "rounded-lg border px-4 py-3"
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0), // --radius
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon, if provided
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 2.0),
              child: Icon(icon, size: 20, color: foregroundColor),
            ),
          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AlertTitle
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w500, // font-medium
                  ),
                ),
                const SizedBox(height: 4),
                // AlertDescription
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: variant == AlertVariant.destructive
                        ? foregroundColor.withOpacity(0.9)
                        : isDarkMode
                        ? AppColorsDark.mutedForeground
                        : AppColorsLight.mutedForeground,
                  ),
                  child: description,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
