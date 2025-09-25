// lib/components/checkbox.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Widget? label;
  final bool isEnabled;

  const AppCheckbox({
    super.key,
    this.initialValue = false,
    required this.onChanged,
    this.label,
    this.isEnabled = true,
  });

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  // Ensures the checkbox updates if the parent widget rebuilds with a new initialValue
  @override
  void didUpdateWidget(covariant AppCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _isChecked = widget.initialValue;
    }
  }

  void _handleTap() {
    if (widget.isEnabled) {
      setState(() {
        _isChecked = !_isChecked;
      });
      widget.onChanged(_isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final onPrimaryColor = isDarkMode
        ? AppColorsDark.primaryForeground
        : AppColorsLight.primaryForeground;
    final inputBgColor = isDarkMode
        ? AppColorsDark.inputBackground
        : AppColorsLight.inputBackground;
    final borderColor = Theme.of(context).dividerColor;

    // Use an AnimatedContainer for a smooth transition between states
    Widget checkboxVisual = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: _isChecked ? primaryColor : inputBgColor,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: _isChecked ? primaryColor : borderColor),
      ),
      child: _isChecked
          ? Icon(
              Icons.check, // Flutter's equivalent of CheckIcon
              size: 14,
              color: onPrimaryColor,
            )
          : null,
    );

    // If a label is provided, wrap it in a clickable Row
    if (widget.label != null) {
      return Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.5,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                checkboxVisual,
                const SizedBox(width: 8),
                widget.label!,
              ],
            ),
          ),
        ),
      );
    }

    // If no label, just return the clickable checkbox
    return Opacity(
      opacity: widget.isEnabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(4),
        child: checkboxVisual,
      ),
    );
  }
}
