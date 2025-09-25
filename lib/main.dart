import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_transit/auth/auth_provider.dart';
import 'package:smart_transit/navigation/app_shell.dart';
import 'package:smart_transit/screens/login_screen.dart';
import 'package:smart_transit/theme/app_theme.dart';
import 'package:smart_transit/theme/theme_provider.dart';

void main() {
  runApp(
    // Use MultiProvider to provide both Auth and Theme state to the app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Smart Transit',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          // --- THIS IS THE AUTHENTICATION GATE ---
          // Use a Consumer to listen to the AuthProvider state
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              // If the user is authenticated, show the main app.
              // Otherwise, show the login screen.
              return authProvider.isAuthenticated
                  ? const AppShell()
                  : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
