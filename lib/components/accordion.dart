// lib/components/accordion.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart'; // Import your app colors

class Accordion extends StatefulWidget {
  final String title;
  final Widget content;
  final EdgeInsets padding;
  final Color? titleColor;

  const Accordion({
    super.key,
    required this.title,
    required this.content,
    this.padding = const EdgeInsets.all(16.0),
    this.titleColor,
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use theme colors for consistent styling
    final borderColor = Theme.of(context).dividerColor;
    final defaultTitleColor = isDarkMode
        ? AppColorsDark.foreground
        : AppColorsLight.foreground;

    return Container(
      // Mimics the "border-b" class from your CSS
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // This is the AccordionTrigger
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: widget.padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: widget.titleColor ?? defaultTitleColor,
                      ),
                    ),
                  ),
                  // Rotates the chevron icon on state change, just like the CSS
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons
                          .expand_more, // Flutter's equivalent of ChevronDownIcon
                      color: isDarkMode
                          ? AppColorsDark.mutedForeground
                          : AppColorsLight.mutedForeground,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // This is the AccordionContent
          AnimatedCrossFade(
            firstChild: Container(), // Empty container when collapsed
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(
                widget.padding.left,
                0,
                widget.padding.right,
                widget.padding.bottom,
              ),
              child: widget.content, // Your content widget
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
