import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:smart_transit/navigation/bottom_navigation.dart';
import 'package:smart_transit/screens/home_screen.dart';
import 'package:smart_transit/screens/profile_screen.dart';
import 'package:smart_transit/screens/routes_screen.dart';
import 'package:smart_transit/screens/wallet_screen.dart';

/// The main shell of the application.
/// It holds the bottom navigation bar and manages the currently displayed screen.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _activeIndex = 0;

  // The list of screens to be displayed in the body
  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    RoutesScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  // The list of navigation items for the bottom bar
  final List<NavItem> _navItems = [
    NavItem(id: 'home', icon: LucideIcons.house, label: 'Home'),
    NavItem(id: 'routes', icon: LucideIcons.route, label: 'Routes'),
    NavItem(id: 'wallet', icon: LucideIcons.wallet, label: 'Wallet'),
    NavItem(id: 'profile', icon: LucideIcons.user, label: 'Profile'),
  ];

  void _onTabChange(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use extendBody to allow the body content to go behind the transparent nav bar
      extendBody: true,
      body: IndexedStack(
        index: _activeIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavigation(
        items: _navItems,
        activeIndex: _activeIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
