import 'dart:ui';
import 'package:flutter/material.dart';

/// A data class for the items in our custom bottom navigation bar.
class NavItem {
  final String id;
  final IconData icon;
  final String label;

  NavItem({required this.id, required this.icon, required this.label});
}

/// The custom-styled bottom navigation bar with the glass morphism effect.
class AppBottomNavigation extends StatelessWidget {
  final List<NavItem> items;
  final int activeIndex;
  final ValueChanged<int> onTabChange;

  const AppBottomNavigation({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: (isDarkMode ? Colors.grey[900]! : Colors.white)
                .withOpacity(0.8),
            border: Border(
              top: BorderSide(
                color: (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!)
                    .withOpacity(0.5),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                return _buildNavItem(
                  context: context,
                  item: items[index],
                  isActive: activeIndex == index,
                  onTap: () => onTabChange(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavItem item,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = const Color(0xFF28A745);
    final Color inactiveColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon,
              size: 24, color: isActive ? activeColor : inactiveColor),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? activeColor : inactiveColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
