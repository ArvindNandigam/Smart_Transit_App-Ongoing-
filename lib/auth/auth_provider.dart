import 'package:flutter/material.dart';

/// A simple provider to manage the user's authentication state.
class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// In a real app, this would make an API call.
  Future<void> login(String email, String password) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock login success
    _isAuthenticated = true;
    notifyListeners(); // Notify widgets that the state has changed
  }

  /// Logs the user out.
  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}
