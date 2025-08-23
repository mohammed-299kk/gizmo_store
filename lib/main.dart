import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gizmo_store/providers/app_state.dart';
import 'package:gizmo_store/providers/auth_provider.dart';
import 'package:gizmo_store/providers/cart_provider.dart';
import 'package:gizmo_store/providers/coupon_provider.dart';
import 'package:gizmo_store/providers/notification_provider.dart';
import 'package:gizmo_store/providers/review_provider.dart';
import 'package:gizmo_store/providers/search_provider.dart';
import 'package:gizmo_store/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'constants/app_colors.dart';

/*************  ✨ Windsurf Command ⭐  *************/
/// The main entry point of the application. It initializes Firebase
/// asynchronously and then runs the app's widget tree. If Firebase
/// initialization fails, it prints an error message to the console.
/*******  0f3e244b-8940-403f-ab9b-f6eaef0e9a25  *******/ void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('⚠️ Firebase initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'Gizmo Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
