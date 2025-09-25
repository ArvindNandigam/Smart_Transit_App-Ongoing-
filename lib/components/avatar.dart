// lib/components/avatar.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String imageUrl;
  final String fallbackText;
  final double radius;

  const AppAvatar({
    super.key,
    required this.imageUrl,
    required this.fallbackText,
    this.radius = 20.0, // Default size, similar to "size-10" (40px diameter)
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fallbackBackgroundColor = isDarkMode
        ? AppColorsDark.muted
        : AppColorsLight.muted;
    final fallbackForegroundColor = isDarkMode
        ? AppColorsDark.mutedForeground
        : AppColorsLight.mutedForeground;

    return CircleAvatar(
      radius: radius,
      backgroundColor: fallbackBackgroundColor,
      // The backgroundImage will be shown. If it fails to load, the child (fallback) is shown automatically.
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: Text(
        fallbackText,
        style: TextStyle(
          color: fallbackForegroundColor,
          fontSize: radius * 0.8, // Make font size proportional to avatar size
        ),
      ),
    );
  }
}
