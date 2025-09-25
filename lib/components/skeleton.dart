// lib/components/skeleton.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

class AppSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final double borderRadius;

  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16.0,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 8.0,
  });

  const AppSkeleton.circular({super.key, required double size})
    : width = size,
      height = size,
      shape = BoxShape.circle,
      borderRadius = size / 2;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // This creates the back-and-forth pulse effect

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColorsDark.accent : AppColorsLight.accent;

    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.rectangle
              ? BorderRadius.circular(widget.borderRadius)
              : null,
        ),
      ),
    );
  }
}
