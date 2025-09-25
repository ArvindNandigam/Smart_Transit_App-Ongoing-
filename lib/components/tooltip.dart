// lib/components/tooltip.dart
import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final Duration waitDuration;

  const AppTooltip({
    super.key,
    required this.child,
    required this.message,
    // Corresponds to the delayDuration in the TSX
    this.waitDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      // --- Styling to match the .tsx component ---
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(6.0), // rounded-md
      ),
      textStyle: TextStyle(
        color: onPrimaryColor,
        fontSize: 12, // text-xs
      ),
      child: child,
    );
  }
}
