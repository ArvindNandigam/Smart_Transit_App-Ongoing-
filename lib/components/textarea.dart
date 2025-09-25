// lib/components/textarea.dart
import 'package:flutter/material.dart';

class AppTextarea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int minLines;
  final int? maxLines;
  final bool enabled;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppTextarea({
    super.key,
    this.controller,
    this.hintText,
    this.minLines = 3, // A good default for a "textarea"
    this.maxLines, // null allows for infinite expansion
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      // This tells the input to be multi-line
      keyboardType: TextInputType.multiline,
      // The styling comes from the InputDecorationTheme we defined in app_theme.dart
      decoration: InputDecoration(
        hintText: hintText,
        // Aligns the hint text to the top for a better textarea feel
        alignLabelWithHint: true,
      ),
    );
  }
}
