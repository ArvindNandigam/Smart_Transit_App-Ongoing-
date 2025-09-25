// lib/components/badge.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

// Enum to define the badge variants, mirroring the cva variants
enum BadgeVariant {
  def, // 'default' is a reserved keyword in Dart
  secondary,
  destructive,
  outline,
}

class AppBadge extends StatelessWidget {
  final String text;
  final BadgeVariant variant;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.text,
    this.variant = BadgeVariant.def,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // --- Determine Colors based on Variant and Theme ---
    Color backgroundColor;
    Color foregroundColor;
    Border? border;

    switch (variant) {
      case BadgeVariant.secondary:
        backgroundColor = isDarkMode
            ? AppColorsDark.secondary
            : AppColorsLight.secondary;
        foregroundColor = isDarkMode
            ? AppColorsDark.secondaryForeground
            : AppColorsLight.secondaryForeground;
        break;
      case BadgeVariant.destructive:
        backgroundColor = isDarkMode
            ? AppColorsDark.destructive.withOpacity(0.6)
            : AppColorsLight.destructive;
        foregroundColor = isDarkMode
            ? Colors.white.withOpacity(0.9)
            : Colors.white;
        break;
      case BadgeVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDarkMode
            ? AppColorsDark.foreground
            : AppColorsLight.foreground;
        border = Border.all(color: Theme.of(context).dividerColor);
        break;
      // Correct version
      case BadgeVariant.def:
        backgroundColor = isDarkMode
            ? AppColorsDark.primary
            : AppColorsLight.primary;
        foregroundColor = isDarkMode
            ? AppColorsDark.primaryForeground
            : AppColorsLight.primaryForeground;
        break;
    }

    return Container(
      // Mimics "inline-flex items-center rounded-md border px-2 py-0.5"
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0), // rounded-md
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Mimics "w-fit"
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(icon, size: 12, color: foregroundColor),
            ),
          Text(
            text,
            // Mimics "text-xs font-medium"
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
