// lib/components/separator.dart
import 'package:flutter/material.dart';

class AppSeparator extends StatelessWidget {
  final Axis orientation;
  final double thickness;
  final double? length; // Height for vertical, width for horizontal
  final EdgeInsets padding;

  const AppSeparator({
    super.key,
    this.orientation = Axis.horizontal,
    this.thickness = 1.0,
    this.length,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    // For a horizontal separator
    if (orientation == Axis.horizontal) {
      return Padding(
        padding: padding,
        child: SizedBox(
          width: length ?? double.infinity,
          child: Divider(
            height: thickness,
            thickness: thickness,
            color: Theme.of(context).dividerColor,
          ),
        ),
      );
    }
    // For a vertical separator
    else {
      return Padding(
        padding: padding.copyWith(
          top: 0,
          bottom: 0,
        ), // Vertical padding is handled by height
        child: SizedBox(
          height: length ?? 24, // Vertical dividers need a defined height
          child: VerticalDivider(
            width: thickness,
            thickness: thickness,
            color: Theme.of(context).dividerColor,
          ),
        ),
      );
    }
  }
}
