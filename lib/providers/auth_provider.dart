import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/services/firebase_auth_service.dart';
import 'package:gizmo_store/services/user_preferences_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAdmin = false;
  String _userRole = 'user';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _isAdmin;
  String get userRole => _userRole;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserPreferencesService _preferencesService = UserPreferencesService();

  AuthProvider() {
    // تحميل المستخدم الحالي فورًا
    _user = _auth.currentUser;

    // الاستماع إلى تغييرات حالة المصادقة
    _auth.authStateChanges().listen((User? user) {
      final previousUser = _user;
      _user = user;

      // Set safe defaults immediately
      _isAdmin = false;
      _userRole = 'user';
      _isLoading = false;

      // Notify listeners immediately so UI updates
      notifyListeners();

      // Try to check user role in background (don't await)
      if (user != null) {
        _checkUserRole(user.uid).catchError((e) {
          debugPrint('Error checking user role (non-blocking): $e');
        });

        // Handle preference syncing in background
        if (previousUser == null) {
          _syncPreferencesOnLogin().catchError((e) {
            debugPrint('Error syncing preferences (non-blocking): $e');
          });
        }
      } else if (previousUser != null) {
        // User just logged out - reset to defaults in background
        _resetPreferencesOnLogout().catchError((e) {
          debugPrint('Error resetting preferences (non-blocking): $e');
        });
      }
    });
  }

  // تسجيل الدخول
  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      debugPrint('🔐 Attempting to sign in with email: $email');

      // Clear previous session before signing in
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      debugPrint('✅ Sign in successful! User: ${userCredential.user?.uid}');

      // Update user immediately and notify
      _user = userCredential.user;
      _isLoading = false;

      // Force immediate UI update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
        debugPrint('🔔 Notified listeners after sign in');
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Sign in failed: ${e.code}');
      _errorMessage = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // تسجيل جديد
  Future<void> signUp(
    String email,
    String password,
    String confirmPassword, {
    String? firstName,
    String? middleName,
    String? lastName,
    required BuildContext context,
  }) async {
    try {
      if (password != confirmPassword) {
        throw Exception('كلمات المرور غير متطابقة');
      }

      _setLoading(true);
      _errorMessage = null;

      // Build full name
      final fullName = [firstName, middleName, lastName]
          .where((name) => name != null && name.trim().isNotEmpty)
          .join(' ');

      await FirebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: fullName,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        context: context,
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      throw Exception(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // تسجيل الدخول كضيف
  Future<void> signInAsGuest() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      debugPrint('👤 Attempting to sign in as guest...');

      final userCredential = await _auth.signInAnonymously();

      debugPrint(
          '✅ Guest sign in successful! User: ${userCredential.user?.uid}');

      // Update user immediately and notify
      _user = userCredential.user;
      _isLoading = false;

      // Force immediate UI update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
        debugPrint('🔔 Notified listeners after guest sign in');
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Guest sign in failed: ${e.code}');
      _errorMessage = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Preferences will be reset automatically in authStateChanges listener
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الخروج';
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  // Sync preferences when user logs in
  Future<void> _syncPreferencesOnLogin() async {
    try {
      // This will be called by LanguageProvider and ThemeProvider
      // when they detect a user login through their listeners
    } catch (e) {
      debugPrint('Error syncing preferences on login: $e');
    }
  }

  // Reset preferences when user logs out
  Future<void> _resetPreferencesOnLogout() async {
    try {
      // This will be called by LanguageProvider and ThemeProvider
      // when they detect a user logout through their listeners
    } catch (e) {
      debugPrint('Error resetting preferences on logout: $e');
    }
  }

  // Method to trigger preference sync for providers
  Future<void> syncUserPreferences() async {
    if (_user != null) {
      await _syncPreferencesOnLogin();
    }
  }

  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      throw Exception(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'network-request-failed':
        return 'تحقق من اتصال الإنترنت';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // تحديث بيانات المستخدم
  Future<void> refreshUser() async {
    try {
      await _auth.currentUser?.reload();
      _user = _auth.currentUser;
      if (_user != null) {
        await _checkUserRole(_user!.uid);
      }
      notifyListeners();
    } catch (e) {
      // Handle error silently or log it
    }
  }

  // Check user role and admin status
  Future<void> _checkUserRole(String uid) async {
    try {
      // Add timeout to prevent hanging
      final adminCheck = FirebaseAuthService.isUserAdmin(uid).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Admin check timed out, defaulting to false');
          return false;
        },
      );

      final roleCheck = FirebaseAuthService.getUserRole(uid).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Role check timed out, defaulting to user');
          return 'user';
        },
      );

      _isAdmin = await adminCheck;
      _userRole = await roleCheck;
    } catch (e) {
      debugPrint('Error checking user role: $e');
      _isAdmin = false;
      _userRole = 'user';
    }
  }

  // Manually refresh user role (useful after role changes)
  Future<void> refreshUserRole() async {
    if (_user != null) {
      await _checkUserRole(_user!.uid);
      notifyListeners();
    }
  }
}
