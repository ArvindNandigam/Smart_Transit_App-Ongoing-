// lib/components/switch.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// A styled switch component that matches the app's design system.
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Switch(
      value: value,
      onChanged: onChanged,
      // --- Style the track (the background) ---
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Theme.of(context).primaryColor; // Color when ON
        }
        return isDarkMode
            ? AppColorsDark.inputBackground.withOpacity(0.8)
            : AppColorsLight.switchBackground; // Color when OFF
      }),
      // --- Style the thumb (the moving circle) ---
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        // In dark mode, the thumb color changes based on state
        if (isDarkMode) {
          return states.contains(WidgetState.selected)
              ? AppColorsDark.primaryForeground
              : AppColorsDark.cardForeground;
        }
        // In light mode, it's always the card color
        return AppColorsLight.card;
      }),
      // Add a border to the track when not selected
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (!states.contains(WidgetState.selected)) {
          return Theme.of(context).dividerColor;
        }
        return null; // No border when selected
      }),
    );
  }
}

/// A switch combined with a label in a list tile format.
class AppSwitchListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String title;
  final String? subtitle;

  const AppSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // We use a custom builder to avoid the default SwitchListTile styling
    // and ensure our AppSwitch is used.
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            AppSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
