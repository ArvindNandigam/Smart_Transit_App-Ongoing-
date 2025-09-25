// lib/components/slider.dart
import 'package:flutter/material.dart';

class AppSlider extends StatefulWidget {
  // Use RangeValues for a range slider, or a double for a single slider
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;
  final double min;
  final double max;

  const AppSlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
  });

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  late dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // --- Apply custom theme to match the TSX styles ---
    final sliderTheme = SliderTheme.of(context).copyWith(
      trackHeight: 8.0,
      activeTrackColor: Theme.of(context).primaryColor,
      inactiveTrackColor: Theme.of(
        context,
      ).colorScheme.primary.withOpacity(0.2),
      thumbColor: Theme.of(context).cardColor,
      overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
    );

    // --- Conditionally build a RangeSlider or a normal Slider ---
    return SliderTheme(
      data: sliderTheme,
      child: (_currentValue is RangeValues)
          // --- Range Slider ---
          ? RangeSlider(
              values: _currentValue,
              min: widget.min,
              max: widget.max,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentValue = values;
                });
                widget.onChanged(values);
              },
            )
          // --- Single Value Slider ---
          : Slider(
              value: _currentValue,
              min: widget.min,
              max: widget.max,
              onChanged: (double value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onChanged(value);
              },
            ),
    );
  }
}
