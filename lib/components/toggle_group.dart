// lib/components/toggle_group.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// A styled group of toggle buttons for selecting one or more options.
class AppToggleGroup extends StatelessWidget {
  final List<Widget> children;
  final List<bool> isSelected;
  final void Function(int index) onPressed;
  final bool allowMultipleSelection;

  const AppToggleGroup({
    super.key,
    required this.children,
    required this.isSelected,
    required this.onPressed,
    this.allowMultipleSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final onPrimaryColor = isDarkMode
        ? AppColorsDark.primaryForeground
        : AppColorsLight.primaryForeground;
    final mutedColor = isDarkMode ? AppColorsDark.muted : AppColorsLight.muted;

    return ToggleButtons(
      onPressed: (int index) {
        // If single selection is enforced, deselect all others first
        if (!allowMultipleSelection) {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        } else {
          // Otherwise, just toggle the selected button
          isSelected[index] = !isSelected[index];
        }
        onPressed(index);
      },
      isSelected: isSelected,

      // --- Styling to match the .tsx component ---
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      selectedColor: onPrimaryColor,
      fillColor: primaryColor,
      splashColor: primaryColor.withOpacity(0.2),
      borderColor: mutedColor,
      selectedBorderColor: primaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      children: children,
    );
  }
}
