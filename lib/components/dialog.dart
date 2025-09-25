// lib/components/dialog.dart
import 'package:flutter/material.dart';

/// Shows a styled, general-purpose dialog.
Future<void> showAppDialog({
  required BuildContext context,
  required Widget child,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      // Use Flutter's Dialog widget as the base
      return Dialog(
        backgroundColor: Colors.transparent, // We'll style the content instead
        insetPadding: const EdgeInsets.all(24),
        child: child,
      );
    },
  );
}

/// The main container for the dialog's content, including the close button.
class AppDialogContent extends StatelessWidget {
  final Widget child;

  const AppDialogContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Mimics "bg-background rounded-lg border shadow-lg"
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Stack(
        children: [
          // The user-provided content
          Padding(padding: const EdgeInsets.all(24.0), child: child),
          // --- Close Button ---
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close), // Flutter's XIcon
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Close',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// A header section for a dialog.
class AppDialogHeader extends StatelessWidget {
  final Widget title;
  final Widget? description;

  const AppDialogHeader({super.key, required this.title, this.description});

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

/// A footer section for a dialog, typically for buttons.
class AppDialogFooter extends StatelessWidget {
  final Widget child;

  const AppDialogFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0), // Spacing before the footer
      child: child,
    );
  }
}

/// The title for a dialog header.
class AppDialogTitle extends StatelessWidget {
  final String text;

  const AppDialogTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headlineSmall);
  }
}

/// The description for a dialog header.
class AppDialogDescription extends StatelessWidget {
  final String text;

  const AppDialogDescription(this.text, {super.key});

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
