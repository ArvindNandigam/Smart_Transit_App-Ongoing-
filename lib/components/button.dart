// lib/components/button.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

// Enums to define the button variants and sizes, mirroring the cva options
enum ButtonVariant { def, destructive, outline, secondary, ghost, link }

enum ButtonSize { def, sm, lg, icon }

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading; // To show a loading indicator

  const AppButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.variant = ButtonVariant.def,
    this.size = ButtonSize.def,
    this.isLoading = false,
  }) : assert(
         label != null || icon != null,
         'Button must have a label or an icon.',
       );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // --- Style determination based on variant and size ---
    Color? backgroundColor, foregroundColor, overlayColor;
    BorderSide? borderSide;
    double verticalPadding, horizontalPadding, height, iconSize, fontSize, gap;

    // Size properties
    switch (size) {
      case ButtonSize.sm:
        height = 32;
        fontSize = 14;
        iconSize = 16;
        gap = 6;
        horizontalPadding = (icon != null && label != null) ? 10 : 12;
        break;
      case ButtonSize.lg:
        height = 40;
        fontSize = 16;
        iconSize = 20;
        gap = 8;
        horizontalPadding = (icon != null && label != null) ? 16 : 24;
        break;
      case ButtonSize.icon:
        height = 36;
        fontSize = 14;
        iconSize = 20;
        gap = 0;
        horizontalPadding = 8;
        break;
      case ButtonSize.def:
        height = 36;
        fontSize = 14;
        iconSize = 18;
        gap = 8;
        horizontalPadding = (icon != null && label != null) ? 12 : 16;
        break;
    }
    verticalPadding = 8;

    // Variant properties
    switch (variant) {
      case ButtonVariant.destructive:
        backgroundColor = isDarkMode
            ? AppColorsDark.destructive.withOpacity(0.6)
            : AppColorsLight.destructive;
        foregroundColor = Colors.white;
        overlayColor = isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1);
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDarkMode
            ? AppColorsDark.foreground
            : AppColorsLight.foreground;
        overlayColor = isDarkMode
            ? AppColorsDark.accent.withOpacity(0.5)
            : AppColorsLight.accent;
        borderSide = BorderSide(
          color: isDarkMode ? AppColorsDark.border : AppColorsLight.border,
        );
        break;
      case ButtonVariant.secondary:
        backgroundColor = isDarkMode
            ? AppColorsDark.secondary
            : AppColorsLight.secondary;
        foregroundColor = isDarkMode
            ? AppColorsDark.secondaryForeground
            : AppColorsLight.secondaryForeground;
        overlayColor = isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1);
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDarkMode
            ? AppColorsDark.foreground
            : AppColorsLight.foreground;
        overlayColor = isDarkMode
            ? AppColorsDark.accent.withOpacity(0.5)
            : AppColorsLight.accent;
        break;
      case ButtonVariant.link:
        backgroundColor = Colors.transparent;
        foregroundColor = isDarkMode
            ? AppColorsDark.primary
            : AppColorsLight.primary;
        break;
      case ButtonVariant.def:
        backgroundColor = isDarkMode
            ? AppColorsDark.primary
            : AppColorsLight.primary;
        foregroundColor = isDarkMode
            ? AppColorsDark.primaryForeground
            : AppColorsLight.primaryForeground;
        overlayColor = isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1);
        break;
    }

    final buttonStyle =
        ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          surfaceTintColor: Colors.transparent, // Disables the M3 tint
          splashFactory: variant == ButtonVariant.link
              ? NoSplash.splashFactory
              : InkRipple.splashFactory,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ), // rounded-md
          side: borderSide,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          minimumSize: Size(0, height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ), // font-medium
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return overlayColor;
            }
            return null;
          }),
        );

    // The actual content of the button (icon, text, or both)
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon, size: iconSize),
        if (icon != null && label != null) SizedBox(width: gap),
        if (label != null) Text(label!),
      ],
    );

    if (size == ButtonSize.icon) {
      buttonContent = Icon(icon, size: iconSize);
    }

    return ElevatedButton(
      style: buttonStyle,
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: iconSize,
              height: iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            )
          : buttonContent,
    );
  }
}
