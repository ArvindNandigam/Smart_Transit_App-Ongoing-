// lib/components/sidebar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_transit/components/sidebar_provider.dart';
import 'package:smart_transit/theme/app_colors.dart';

const double _sidebarWidth = 256.0;
const double _sidebarCollapsedWidth = 64.0;

/// The main sidebar widget. It's responsive and collapsible.
class AppSidebar extends StatelessWidget {
  final Widget child;
  const AppSidebar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final sidebarProvider = context.watch<SidebarProvider>();

    // On mobile, the sidebar is a standard Drawer
    if (isMobile) {
      return Drawer(child: child);
    }

    // On desktop, it's a persistent, animated panel
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarProvider.isCollapsed
          ? _sidebarCollapsedWidth
          : _sidebarWidth,
      decoration: BoxDecoration(
        color: isDarkMode(context) ? AppColorsDark.card : AppColorsLight.card,
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: child,
    );
  }
}

/// A menu item for the sidebar. Shows a tooltip when collapsed.
class AppSidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const AppSidebarMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCollapsed = context.watch<SidebarProvider>().isCollapsed;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDarkMode
        ? AppColorsDark.accent
        : AppColorsLight.accent;

    return Tooltip(
      message: label,
      // Only show the tooltip when the sidebar is collapsed
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 20 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isActive ? accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20),
              if (!isCollapsed) ...[
                const SizedBox(width: 16),
                Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A button (usually in the AppBar) to toggle the sidebar's state.
class AppSidebarTrigger extends StatelessWidget {
  const AppSidebarTrigger({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        if (isMobile) {
          Scaffold.of(context).openDrawer();
        } else {
          context.read<SidebarProvider>().toggleSidebar();
        }
      },
    );
  }
}

// Helper function
bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;
