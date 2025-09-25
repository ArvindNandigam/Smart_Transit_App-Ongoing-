// lib/components/radio_group.dart
import 'package:flutter/material.dart';

/// Data class to hold the value and label for a single radio item.
class RadioItem<T> {
  final T value;
  final String label;

  const RadioItem({required this.value, required this.label});
}

class AppRadioGroup<T> extends StatefulWidget {
  final T initialValue;
  final List<RadioItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Axis direction; // To allow for horizontal or vertical layout

  const AppRadioGroup({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.direction = Axis.vertical,
  });

  @override
  State<AppRadioGroup<T>> createState() => _AppRadioGroupState<T>();
}

class _AppRadioGroupState<T> extends State<AppRadioGroup<T>> {
  late T? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // Generate a list of RadioListTile widgets from the items
    final radioTiles = widget.items.map((item) {
      return SizedBox(
        // Constrain width when in a horizontal layout
        width: widget.direction == Axis.horizontal ? 150 : null,
        child: RadioListTile<T>(
          title: Text(item.label),
          value: item.value,
          groupValue: _groupValue,
          onChanged: (T? value) {
            setState(() {
              _groupValue = value;
            });
            widget.onChanged(value);
          },
          // Style the radio button to match the theme
          activeColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.zero,
        ),
      );
    }).toList();

    // Use a Column for a vertical list or a Wrap for a horizontal one
    if (widget.direction == Axis.vertical) {
      return Column(mainAxisSize: MainAxisSize.min, children: radioTiles);
    } else {
      return Wrap(spacing: 12.0, runSpacing: 12.0, children: radioTiles);
    }
  }
}
