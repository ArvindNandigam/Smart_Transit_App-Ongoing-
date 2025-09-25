// lib/components/context_menu.dart
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

/// Data class for a single item in the context menu.
class ContextMenuItem {
  final String title;
  final IconData? icon;
  final VoidCallback onSelected;
  final bool isDestructive;

  ContextMenuItem({
    required this.title,
    this.icon,
    required this.onSelected,
    this.isDestructive = false,
  });
}

/// A widget that provides a context menu (on long press) for its child.
class AppContextMenu extends StatefulWidget {
  final Widget child;
  final List<ContextMenuItem> menuItems;

  const AppContextMenu({
    super.key,
    required this.child,
    required this.menuItems,
  });

  @override
  State<AppContextMenu> createState() => _AppContextMenuState();
}

class _AppContextMenuState extends State<AppContextMenu> {
  // A GlobalKey must be stored in a State object to persist across rebuilds.
  final GlobalKey _menuKey = GlobalKey();

  void _showMenu() {
    // FIXED: Replaced undeclared custom colors with standard Theme colors.
    final popoverColor = Theme.of(context).cardColor;
    final destructiveColor = Theme.of(context).colorScheme.error;

    PopupMenu(
      context: context,
      config: MenuConfig(
        backgroundColor:
            popoverColor, // FIXED: Use MenuConfig with backgroundColor
        lineColor: Theme.of(context)
            .dividerColor
            .withOpacity(0.5), // FIXED: Use MenuConfig with lineColor
      ),
      items: widget.menuItems.map((item) {
        final itemColor = item.isDestructive
            ? destructiveColor
            : Theme.of(context).colorScheme.onSurface;

        return MenuItem(
          title: item.title,
          textStyle: TextStyle(color: itemColor, fontSize: 14),
          image: item.icon != null
              ? Icon(item.icon, color: itemColor.withOpacity(0.8), size: 20)
              : null,
        );
      }).toList(),
      onClickMenu: (menuItem) {
        // FIXED: Using a try-catch block to handle the click without new imports.
        // This finds the item by title and executes its callback.
        try {
          final selectedItem = widget.menuItems.firstWhere(
            (item) => item.title == menuItem.menuTitle,
          );
          selectedItem.onSelected();
        } catch (e) {
          // This catch block handles the error if no item with the matching title is found.
          // You can add logging here if needed.
          debugPrint(
              "Context menu item with title '${menuItem.menuTitle}' not found.");
        }
      },
    ).show(widgetKey: _menuKey);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _menuKey,
      onLongPress: _showMenu,
      child: widget.child,
    );
  }
}
