// lib/components/scroll_area.dart
import 'package:flutter/material.dart';

class AppScrollArea extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;

  const AppScrollArea({
    super.key,
    required this.child,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    // We use ScrollbarTheme to style the scrollbar for this part of the widget tree.
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        // Makes the scrollbar thumb always visible, matching the Radix UI behavior
        thumbVisibility: const WidgetStatePropertyAll(true),
        // Style of the scrollbar thumb (the part you drag)
        thumbColor: WidgetStatePropertyAll(
          Theme.of(context).dividerColor.withOpacity(0.6),
        ),
        // Thickness of the scrollbar track
        thickness: const WidgetStatePropertyAll(10.0), // w-2.5 from CSS
        // Rounded corners for the thumb
        radius: const Radius.circular(5.0),
      ),
      child: Scrollbar(
        // The actual scrolling is handled by SingleChildScrollView
        child: SingleChildScrollView(
          scrollDirection: scrollDirection,
          child: child,
        ),
      ),
    );
  }
}
