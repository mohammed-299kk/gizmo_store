import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/screens/main_screen.dart';
import 'package:gizmo_store/screens/auth/auth_screen.dart';
import 'package:gizmo_store/screens/splash_screen.dart';
import 'package:gizmo_store/screens/admin/admin_panel.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Show Splash Screen for 3 seconds only at app startup
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    return Consumer<auth.AuthProvider>(
      builder: (context, authProvider, child) {
        debugPrint(
            '🔄 AuthGate rebuild - isAuthenticated: ${authProvider.isAuthenticated}, isAdmin: ${authProvider.isAdmin}, user: ${authProvider.user?.uid}');

        // Check if user is authenticated
        if (authProvider.isAuthenticated) {
          debugPrint('✅ User is authenticated, navigating to app...');
          // Check if the authenticated user is admin based on role/permissions
          if (authProvider.isAdmin) {
            debugPrint('👑 User is admin, showing AdminPanel');
            // Redirect admin to admin panel
            return const AdminPanel();
          } else {
            debugPrint('👤 User is regular user, showing MainScreen');
            // Redirect regular users to main screen (with bottom navigation)
            return const MainScreen();
          }
        } else {
          debugPrint('❌ User not authenticated, showing AuthScreen');
          // Show auth screen for unauthenticated users
          return const AuthScreen();
        }
      },
    );
  }
}
