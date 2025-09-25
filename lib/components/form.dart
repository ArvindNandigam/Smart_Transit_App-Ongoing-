// lib/components/form.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// A composable form item that wraps a form field with a label and error message.
/// This is the equivalent of FormItem, FormLabel, FormControl, and FormMessage combined.
class AppFormItem extends StatelessWidget {
  final String name;
  final String label;
  final Widget field;
  final String? description;

  const AppFormItem({
    super.key,
    required this.name,
    required this.label,
    required this.field,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final destructiveColor = isDarkMode
        ? AppColorsDark.destructive
        : AppColorsLight.destructive;

    return FormBuilderField(
      name: name,
      builder: (FormFieldState<dynamic> fieldState) {
        final hasError = fieldState.hasError;
        final errorText = fieldState.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FormLabel ---
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: hasError ? destructiveColor : null,
              ),
            ),
            const SizedBox(height: 8),

            // --- FormControl (the actual input field) ---
            field,

            // --- FormDescription or FormMessage ---
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                hasError ? errorText! : description ?? '',
                style: TextStyle(
                  color: hasError
                      ? destructiveColor
                      : Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
      // Removed unsupported 'child' parameter from FormBuilderField
    );
  }
}

/// A custom styled TextField for use with flutter_form_builder.
class AppFormTextField extends StatelessWidget {
  final String name;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;

  const AppFormTextField({
    super.key,
    required this.name,
    this.hintText,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        // Using the InputDecorationTheme we defined in app_theme.dart
      ),
      validator: validator,
    );
  }
}
