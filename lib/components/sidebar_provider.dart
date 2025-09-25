// lib/components/sidebar_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarProvider with ChangeNotifier {
  static const String _sidebarStateKey = 'sidebar_is_collapsed';
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  SidebarProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isCollapsed = prefs.getBool(_sidebarStateKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveState(bool isCollapsed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sidebarStateKey, isCollapsed);
  }

  void toggleSidebar() {
    _isCollapsed = !_isCollapsed;
    _saveState(_isCollapsed);
    notifyListeners();
  }
}
