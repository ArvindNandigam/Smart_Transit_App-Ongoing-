// lib/components/select.dart
import 'package:flutter/material.dart';

/// Data class to hold the value and label for a single option in the select dropdown.
class SelectItem<T> {
  final T value;
  final String label;

  const SelectItem({required this.value, required this.label});
}

class AppSelect<T> extends StatelessWidget {
  final T? initialValue;
  final List<SelectItem<T>> items;
  final String placeholder;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  const AppSelect({
    super.key,
    this.initialValue,
    required this.items,
    this.placeholder = 'Select an option',
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      // The styling for the dropdown button itself (the trigger)
      decoration: InputDecoration(
        // The main styling comes from the InputDecorationTheme in your app_theme.dart
        hintText: placeholder,
        // Override the icon to be the chevron down
        suffixIcon: const Icon(Icons.expand_more, size: 20),
      ),
      // Styling for the dropdown menu that appears
      dropdownColor: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      // --- Builds the list of items in the dropdown ---
      items: items.map((item) {
        return DropdownMenuItem<T>(value: item.value, child: Text(item.label));
      }).toList(),
    );
  }
}
