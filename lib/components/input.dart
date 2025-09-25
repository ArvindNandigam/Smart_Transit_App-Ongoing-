// lib/components/input.dart
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppInput({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      // The core of the styling comes from the InputDecorationTheme in your app_theme.dart
      // This ensures all text fields in your app look consistent.
      decoration: InputDecoration(
        hintText: hintText,
        // You can override specific theme properties here if needed.
        // For example, to add an icon:
        // prefixIcon: Icon(Icons.person),
      ),
    );
  }
}
