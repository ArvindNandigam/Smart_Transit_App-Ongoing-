// lib/components/sheet.dart
import 'package:flutter/material.dart';

// --- Composable Widgets for the Sheet's Content ---

/// The main content wrapper for a sheet. Includes the close button.
class AppSheetContent extends StatelessWidget {
  final Widget child;

  const AppSheetContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The user-provided content
        Padding(padding: const EdgeInsets.all(24.0), child: child),
        // --- Close Button ---
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

/// A header section for a sheet.
class AppSheetHeader extends StatelessWidget {
  final Widget title;
  final Widget? description;

  const AppSheetHeader({super.key, required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        if (description != null) ...[const SizedBox(height: 8), description!],
        const SizedBox(height: 16), // Spacing after the header
      ],
    );
  }
}

/// A footer section for a sheet, typically for buttons.
class AppSheetFooter extends StatelessWidget {
  final Widget child;

  const AppSheetFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 24.0), child: child);
  }
}

/// The title for a sheet header.
class AppSheetTitle extends StatelessWidget {
  final String text;

  const AppSheetTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headlineSmall);
  }
}

/// The description for a sheet header.
class AppSheetDescription extends StatelessWidget {
  final String text;

  const AppSheetDescription(this.text, {super.key});

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
