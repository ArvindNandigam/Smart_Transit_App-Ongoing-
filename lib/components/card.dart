// lib/components/card.dart
import 'package:flutter/material.dart';

/// The main container for all card content.
class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Mimics "bg-card border rounded-xl"
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12.0), // rounded-xl
      ),
      child: child,
    );
  }
}

/// A header section for a card. Typically contains a title, description, and an optional action widget.
class AppCardHeader extends StatelessWidget {
  final Widget title;
  final Widget? description;
  final Widget? action;
  final EdgeInsets padding;

  const AppCardHeader({
    super.key,
    required this.title,
    this.description,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (description != null) ...[
                  const SizedBox(height: 6),
                  description!,
                ],
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 16), action!],
        ],
      ),
    );
  }
}

/// The title for a card header.
class AppCardTitle extends StatelessWidget {
  final String text;

  const AppCardTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    // Use the theme's style for consistency
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}

/// The description for a card header.
class AppCardDescription extends StatelessWidget {
  final String text;

  const AppCardDescription(this.text, {super.key});

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

/// The main content section of a card.
class AppCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppCardContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

/// A footer section for a card. Typically contains action buttons.
class AppCardFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppCardFooter({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}
