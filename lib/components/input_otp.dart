import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppInputOTP extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final TextEditingController? controller;
  final String? errorText; // --- THIS IS THE FIX (Part 1) ---

  const AppInputOTP({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.controller,
    this.errorText, // --- THIS IS THE FIX (Part 1) ---
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inputBgColor = isDarkMode
        ? AppColorsDark.inputBackground
        : AppColorsLight.inputBackground;
    final borderColor = Theme.of(context).dividerColor;
    final primaryColor =
        isDarkMode ? AppColorsDark.primary : AppColorsLight.primary;
    final errorColor =
        isDarkMode ? AppColorsDark.destructive : AppColorsLight.destructive;

    // Define the style for a default (unfocused) PIN slot
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: inputBgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    // Define the style for the focused PIN slot
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor),
    );

    // --- THIS IS THE FIX (Part 2) ---
    // Define a new style for when there is a validation error.
    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: errorColor),
    );
    // ---

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pinput(
          length: length,
          controller: controller,
          onCompleted: onCompleted,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme, // Apply the error theme
          forceErrorState:
              errorText != null, // Show the error theme if errorText exists
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
        ),
        // --- THIS IS THE FIX (Part 3) ---
        // Conditionally show the error message below the input fields.
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
