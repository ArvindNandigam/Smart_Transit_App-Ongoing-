// lib/components/drawer.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// Shows a styled modal bottom sheet (drawer).
Future<T?> showAppDrawer<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled:
        true, // Allows the sheet to be taller than half the screen
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      );
    },
  );
}

/// The main content wrapper for a drawer. Includes the drag handle.
class AppDrawerContent extends StatelessWidget {
  final Widget child;

  const AppDrawerContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final handleColor = isDarkMode ? AppColorsDark.muted : AppColorsLight.muted;

    return Column(
      mainAxisSize:
          MainAxisSize.min, // Make the sheet only as tall as its content
      children: [
        // --- Drag Handle ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ),
        // The rest of the drawer content
        child,
      ],
    );
  }
}

/// A header section for a drawer.
class AppDrawerHeader extends StatelessWidget {
  final Widget title;
  final Widget? description;

  const AppDrawerHeader({super.key, required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          if (description != null) ...[const SizedBox(height: 4), description!],
        ],
      ),
    );
  }
}

/// A footer section for a drawer, typically for action buttons.
class AppDrawerFooter extends StatelessWidget {
  final Widget child;

  const AppDrawerFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: child,
    );
  }
}

/// The title for a drawer header.
class AppDrawerTitle extends StatelessWidget {
  final String text;

  const AppDrawerTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headlineSmall);
  }
}

/// The description for a drawer header.
class AppDrawerDescription extends StatelessWidget {
  final String text;

  const AppDrawerDescription(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }
}
