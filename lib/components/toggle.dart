// lib/components/toggle.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

// Enums to define the toggle variants and sizes, mirroring the cva options
enum ToggleVariant { def, outline }

enum ToggleSize { sm, def, lg }

class AppToggle extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onPressed;
  final ToggleVariant variant;
  final ToggleSize size;

  const AppToggle({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onPressed,
    this.variant = ToggleVariant.def,
    this.size = ToggleSize.def,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor =
        isDarkMode ? AppColorsDark.accent : AppColorsLight.accent;
    final accentTextColor = isDarkMode
        ? AppColorsDark.accentForeground
        : AppColorsLight.accentForeground;
    final mutedColor = isDarkMode ? AppColorsDark.muted : AppColorsLight.muted;

    double height;
    double minWidth;
    EdgeInsets padding;

    switch (size) {
      case ToggleSize.sm:
        height = 32;
        minWidth = 32;
        padding = const EdgeInsets.symmetric(horizontal: 6);
        break;
      case ToggleSize.lg:
        height = 40;
        minWidth = 40;
        padding = const EdgeInsets.symmetric(horizontal: 10);
        break;
      case ToggleSize.def:
        height = 36;
        minWidth = 36;
        padding = const EdgeInsets.symmetric(horizontal: 8);
        break;
    }

    return IconButton(
      onPressed: onPressed,
      isSelected: isSelected,
      padding: padding,
      constraints: BoxConstraints(minHeight: height, minWidth: minWidth),
      // --- CORRECTED STYLING ---
      // Use ButtonStyle directly to handle different states (like selected)
      style: ButtonStyle(
        // Handle foreground (icon) color based on selection state
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return accentTextColor;
          }
          return Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
        }),
        // Handle background color based on selection state
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return Colors.transparent; // Default background
        }),
        // Handle hover/splash color
        overlayColor: WidgetStateProperty.all(mutedColor.withOpacity(0.5)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: variant == ToggleVariant.outline
                ? BorderSide(color: Theme.of(context).dividerColor)
                : BorderSide.none,
          ),
        ),
      ),
      icon: child,
    );
  }
}
