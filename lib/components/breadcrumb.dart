// lib/components/breadcrumb.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// Data class for a single item in the breadcrumb trail.
class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap; // If null, it's a "BreadcrumbPage" (not clickable)
  final bool isEllipsis; // If true, it's a "..." icon

  BreadcrumbItem({required this.label, this.onTap}) : isEllipsis = false;
  BreadcrumbItem.ellipsis() : label = '', onTap = null, isEllipsis = true;
}

class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final IconData separatorIcon;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.separatorIcon = Icons.chevron_right, // Flutter's ChevronRight
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDarkMode
        ? AppColorsDark.mutedForeground
        : AppColorsLight.mutedForeground;
    final foregroundColor = isDarkMode
        ? AppColorsDark.foreground
        : AppColorsLight.foreground;

    // Use a list to hold the generated widgets
    final List<Widget> children = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // --- Add the Breadcrumb Item (Link, Page, or Ellipsis) ---
      if (item.isEllipsis) {
        // BreadcrumbEllipsis
        children.add(Icon(Icons.more_horiz, color: mutedColor, size: 20));
      } else if (item.onTap != null) {
        // BreadcrumbLink (Clickable)
        children.add(
          InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              item.label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mutedColor),
            ),
          ),
        );
      } else {
        // BreadcrumbPage (Current Page, not clickable)
        children.add(
          Text(
            item.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
          ),
        );
      }

      // --- Add the BreadcrumbSeparator after each item except the last ---
      if (i < items.length - 1) {
        children.add(Icon(separatorIcon, color: mutedColor, size: 18));
      }
    }

    // Use Wrap for responsive layout, similar to "flex-wrap"
    return Wrap(
      spacing: 8.0, // Horizontal gap
      runSpacing: 4.0, // Vertical gap if it wraps
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
