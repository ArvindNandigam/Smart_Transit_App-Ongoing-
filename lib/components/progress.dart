// lib/components/progress.dart
import 'package:flutter/material.dart';

class AppProgress extends StatelessWidget {
  /// The progress value, from 0.0 (empty) to 1.0 (full).
  final double value;
  final double height;

  const AppProgress({
    super.key,
    required this.value,
    this.height = 8.0, // h-2 from CSS
  });

  @override
  Widget build(BuildContext context) {
    // Use ClipRRect to give the progress bar rounded corners
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        // The active color of the progress bar
        color: Theme.of(context).colorScheme.primary,
        // The background color of the track
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
    );
  }
}
