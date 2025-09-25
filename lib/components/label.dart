// lib/components/label.dart
import 'package:flutter/material.dart';

class AppLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AppLabel(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    // Uses the labelLarge text style we defined in app_theme.dart
    final defaultStyle = Theme.of(context).textTheme.labelLarge;

    return Text(text, style: defaultStyle?.merge(style));
  }
}
