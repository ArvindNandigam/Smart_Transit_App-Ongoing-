// lib/components/dropdown_menu.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// Main dropdown menu widget that wraps PopupMenuButton.
class AppDropdownMenu extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry> items;
  final ValueChanged<dynamic>? onSelected;

  const AppDropdownMenu({
    super.key,
    required this.child,
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
      child: child,
    );
  }
}

/// A standard, clickable dropdown menu item.
class AppDropdownMenuItem extends PopupMenuItem {
  AppDropdownMenuItem({
    super.key,
    required String label,
    IconData? icon,
    String? shortcut,
    bool isDestructive = false,
    super.onTap,
    super.value,
  }) : super(
          child: _MenuItemContent(
            label: label,
            icon: icon,
            shortcut: shortcut,
            isDestructive: isDestructive,
          ),
        );
}

/// A dropdown menu item with a checkbox.
class AppDropdownMenuCheckboxItem extends CheckedPopupMenuItem<bool> {
  AppDropdownMenuCheckboxItem({
    super.key,
    required String label,
    required super.checked,
    IconData? icon,
    super.onTap,
  }) : super(
          child: _MenuItemContent(label: label, icon: icon),
        );
}

/// A dropdown menu item that is part of a radio button group.
class AppDropdownMenuRadioItem<T> extends PopupMenuItem<T> {
  AppDropdownMenuRadioItem({
    super.key,
    required String label,
    required T value,
    required T groupValue,
  }) : super(
          value: value,
          child: _MenuItemContent(
            label: label,
            // Shows a circle icon if this item is selected
            icon: groupValue == value ? Icons.circle : null,
            hasRadioPlaceholder: true,
          ),
        );
}

/// A non-interactive label for grouping items.
class AppDropdownMenuLabel extends PopupMenuItem {
  AppDropdownMenuLabel({super.key, required String label})
      : super(
          enabled: false, // Makes it non-clickable
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        );
}

/// A visual separator line.
class AppDropdownMenuSeparator extends PopupMenuDivider {
  const AppDropdownMenuSeparator({super.key, super.height = 1.0});
}

/// A dropdown item that opens a nested sub-menu.
class AppDropdownMenuSub extends PopupMenuEntry {
  final String label;
  final List<PopupMenuEntry> items;

  const AppDropdownMenuSub({
    super.key,
    required this.label,
    required this.items,
  });

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(value) => false;

  @override
  State<AppDropdownMenuSub> createState() => _AppDropdownMenuSubState();
}

class _AppDropdownMenuSubState extends State<AppDropdownMenuSub> {
  @override
  Widget build(BuildContext context) {
    return AppDropdownMenu(
      items: widget.items,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(child: Text(widget.label)),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }
}

// --- Internal helper widget for consistent item styling ---
class _MenuItemContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final bool isDestructive;
  final bool hasRadioPlaceholder;

  const _MenuItemContent({
    required this.label,
    this.icon,
    this.shortcut,
    this.isDestructive = false,
    this.hasRadioPlaceholder = false,
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
        // Placeholder for checkbox or radio icon
        if (hasRadioPlaceholder || icon != null)
          SizedBox(
            width: 24,
            child: icon != null
                ? Icon(
                    icon,
                    size: 16,
                    color: isDestructive ? destructiveColor : mutedColor,
                  )
                : null,
          )
        else
          const SizedBox(width: 8),

        // Label
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: isDestructive ? destructiveColor : null),
          ),
        ),

        // Shortcut
        if (shortcut != null)
          Text(shortcut!, style: TextStyle(color: mutedColor, fontSize: 12)),
      ],
    );
  }
}
