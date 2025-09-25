// lib/components/popover.dart
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppPopover extends StatelessWidget {
  final Widget trigger;
  final Widget content;
  final double width;
  final double height;

  const AppPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.width = 280, // w-72 from the CSS
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final popoverColor = isDarkMode
        ? AppColorsDark.popover
        : AppColorsLight.popover;

    return GestureDetector(
      // The popover is shown on a simple tap
      onTap: () {
        showPopover(
          context: context,
          width: width,
          height: height,
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
