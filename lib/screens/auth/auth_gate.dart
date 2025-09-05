import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/screens/home/home_screen.dart';
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

    final authProvider = Provider.of<auth.AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFB71C1C)),
        ),
      );
    }

    // Check if user is authenticated
    if (authProvider.isAuthenticated) {
      // Check if the authenticated user is admin
      final user = authProvider.user;
      if (user != null && user.email == 'mohbe777@gmail.com') {
        // Redirect admin to admin panel
        return const AdminPanel();
      } else {
        // Redirect regular users to home screen
        return const HomeScreen();
      }
    } else {
      // Show auth screen for unauthenticated users
      return const AuthScreen();
    }
  }
}
