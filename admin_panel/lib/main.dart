import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'providers/auth_provider.dart' as auth;
import 'providers/admin_provider.dart';
import 'utils/create_admin.dart';
import 'auth_wrapper.dart';
import 'temp_admin_creator.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Check and create admin user if it doesn't exist
  await _ensureAdminUserExists();
  
  runApp(const AdminPanelApp());
}

Future<void> _ensureAdminUserExists() async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('Hj11wZ1FlANccDf5xoi9ujdZiFM2')
        .get();
    
    if (!doc.exists) {
      await AdminCreator.createAdminUser();
    }
  } catch (e) {
    print('Error checking/creating admin user: $e');
  }
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'Gizmo Store Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
        // home: const TempAdminCreator(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData) {
          // Check if user is admin
          return FutureBuilder<bool>(
            future: _checkAdminStatus(snapshot.data!.uid),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (adminSnapshot.data == true) {
                return const DashboardScreen();
              } else {
                return const LoginScreen(
                  errorMessage: 'Access denied. Admin privileges required.',
                );
              }
            },
          );
        }
        
        return const LoginScreen();
      },
    );
  }

  Future<bool> _checkAdminStatus(String uid) async {
    try {
      // Check if user has admin role in Firestore
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        return data?['role'] == 'admin' || data?['isAdmin'] == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
