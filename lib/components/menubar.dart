// lib/components/menubar.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// The main menubar container, styled as a horizontal bar.
class AppMenubar extends StatelessWidget {
  final List<Widget> menus;

  const AppMenubar({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: menus),
    );
  }
}

/// A single top-level menu (e.g., "File", "Edit") in the menubar.
class AppMenubarMenu extends StatelessWidget {
  final String label;
  final List<PopupMenuEntry> items;
  final ValueChanged<dynamic>? onSelected;

  const AppMenubarMenu({
    super.key,
    required this.label,
    required this.items,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final popoverColor =
        isDarkMode ? AppColorsDark.popover : AppColorsLight.popover;

    return PopupMenuButton(
      onSelected: onSelected,
      color: popoverColor,
      surfaceTintColor: popoverColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      itemBuilder: (context) => items,
      // This child is the trigger button
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(label),
      ),
    );
  }
}

/// A standard, clickable item inside a menu.
class AppMenubarItem extends PopupMenuItem {
  AppMenubarItem({
    super.key,
    required String label,
    String? shortcut,
    bool isDestructive = false,
    super.onTap,
    super.value,
  }) : super(
          child: _MenuItemContent(
            label: label,
            shortcut: shortcut,
            isDestructive: isDestructive,
          ),
        );
}

/// A menu item with a checkbox.
class AppMenubarCheckboxItem extends CheckedPopupMenuItem<bool> {
  AppMenubarCheckboxItem({
    super.key,
    required String label,
    required super.checked,
    super.onTap,
  }) : super(
          child: _MenuItemContent(label: label),
        );
}

/// A non-interactive label for grouping items.
class AppMenubarLabel extends PopupMenuItem {
  AppMenubarLabel({super.key, required String label})
      : super(
          enabled: false,
          height: 24,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        );
}

/// A visual separator line.
class AppMenubarSeparator extends PopupMenuDivider {
  const AppMenubarSeparator({super.key, super.height = 1.0});
}

// --- Internal helper for consistent item styling ---
class _MenuItemContent extends StatelessWidget {
  final String label;
  final String? shortcut;
  final bool isDestructive;

  const _MenuItemContent({
    required this.label,
    this.shortcut,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final destructiveColor =
        isDarkMode ? AppColorsDark.destructive : AppColorsLight.destructive;
    final mutedColor = isDarkMode
        ? AppColorsDark.mutedForeground
        : AppColorsLight.mutedForeground;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: isDestructive ? destructiveColor : null),
          ),
        ),
        if (shortcut != null) ...[
          const SizedBox(width: 24),
          Text(shortcut!, style: TextStyle(color: mutedColor, fontSize: 13)),
        ],
      ],
    );
  }
}
