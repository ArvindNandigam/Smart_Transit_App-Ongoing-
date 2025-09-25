// lib/components/hover_card.dart
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppHoverCard extends StatelessWidget {
  final Widget trigger;
  final Widget content;
  final double width;

  const AppHoverCard({
    super.key,
    required this.trigger,
    required this.content,
    this.width = 250,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final popoverColor = isDarkMode
        ? AppColorsDark.popover
        : AppColorsLight.popover;

    return GestureDetector(
      // On mobile, a long press is the equivalent of a hover
      onLongPress: () {
        showPopover(
          context: context,
          width: width,
          backgroundColor: popoverColor,
          radius: 12, // Corresponds to rounded-md
          shadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
          // The content to be shown in the popover
          bodyBuilder: (context) =>
              Padding(padding: const EdgeInsets.all(16.0), child: content),
        );
      },
      child: trigger,
    );
  }
}
