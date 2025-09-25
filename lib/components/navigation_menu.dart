// lib/components/navigation_menu.dart
import 'package:flutter/material.dart';
import 'package:smart_transit/theme/app_colors.dart';

/// Data class for a top-level item in the navigation menu.
class AppNavigationMenuItem {
  final String title;
  final Widget content;

  AppNavigationMenuItem({required this.title, required this.content});
}

/// The main navigation menu container.
class AppNavigationMenu extends StatefulWidget {
  final List<AppNavigationMenuItem> items;

  const AppNavigationMenu({super.key, required this.items});

  @override
  State<AppNavigationMenu> createState() => _AppNavigationMenuState();
}

class _AppNavigationMenuState extends State<AppNavigationMenu> {
  int? _activeIndex;
  final GlobalKey _menuBarKey = GlobalKey();

  void _toggleMenu(int index) {
    setState(() {
      _activeIndex = (_activeIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use a Stack to allow the content panel to be overlaid
    return Stack(
      clipBehavior: Clip.none, // Allow content to overflow
      children: [
        // --- The bar with the trigger buttons ---
        Container(
          key: _menuBarKey,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.items.length, (index) {
              return _NavigationMenuTrigger(
                title: widget.items[index].title,
                isActive: _activeIndex == index,
                onTap: () => _toggleMenu(index),
              );
            }),
          ),
        ),

        // --- The Viewport/Content Panel ---
        if (_activeIndex != null)
          Positioned(
            top: 50, // Position it below the menu bar
            left: 0,
            right: 0,
            child: _NavigationMenuContent(
              child: widget.items[_activeIndex!].content,
            ),
          ),
      ],
    );
  }
}

/// The trigger button for a top-level menu item.
class _NavigationMenuTrigger extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavigationMenuTrigger({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavigationMenuTrigger> createState() => _NavigationMenuTriggerState();
}

class _NavigationMenuTriggerState extends State<_NavigationMenuTrigger> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDarkMode
        ? AppColorsDark.accent
        : AppColorsLight.accent;
    final accentTextColor = isDarkMode
        ? AppColorsDark.accentForeground
        : AppColorsLight.accentForeground;

    final bool isHighlighted = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isHighlighted
                ? accentColor.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isHighlighted ? accentTextColor : null,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: widget.isActive ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.expand_more, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The container for the content revealed by a trigger.
class _NavigationMenuContent extends StatelessWidget {
  final Widget child;
  const _NavigationMenuContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A styled link for use inside a navigation menu's content panel.
class AppNavigationMenuLink extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const AppNavigationMenuLink({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
