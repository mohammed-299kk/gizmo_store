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
  bool _forceShowApp = false;

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
    
    // Force show app after 15 seconds to prevent infinite loading
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          _forceShowApp = true;
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
        // Force show app if loading takes too long
        if (_forceShowApp && authProvider.isLoading) {
          return HomeScreen();
        }
        
        // Show loading screen with timeout protection
        if (authProvider.isLoading && !_forceShowApp) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A1A),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFB71C1C)),
                  SizedBox(height: 16),
                  Text(
                    'جاري التحميل...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }

        // Show error message if there's an error
        if (authProvider.errorMessage != null) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFB71C1C),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ: ${authProvider.errorMessage}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Try to continue without authentication
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: const Text('المتابعة'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check if user is authenticated
        if (authProvider.isAuthenticated) {
          // Check if the authenticated user is admin based on role/permissions
          if (authProvider.isAdmin) {
            // Redirect admin to admin panel
            return const AdminPanel();
          } else {
            // Redirect regular users to home screen
            return HomeScreen();
          }
        } else {
          // Show auth screen for unauthenticated users
          return const AuthScreen();
        }
      },
    );
  }
}
