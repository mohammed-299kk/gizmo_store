// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_exceptions.dart'; // Added this line

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream لتتبع تغييرات حالة المستخدم (تسجيل دخول/خروج)
  Stream<User?> get userChanges => _auth.authStateChanges();

  // تحقق من تسجيل الدخول الحالي
  bool get isLoggedIn => _auth.currentUser != null;

  bool get isGuest =>
      _auth.currentUser != null && _auth.currentUser!.isAnonymous;

  // تسجيل الدخول بالبريد وكلمة المرور
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Authentication failed.");
    } catch (e) {
      throw AuthException("An unexpected error occurred during sign-in: $e");
    }
  }

  // إنشاء حساب جديد
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Account creation failed.");
    } catch (e) {
      throw AuthException("An unexpected error occurred during account creation: $e");
    }
  }

  // تسجيل الدخول كضيف (Anonymous)
  Future<User?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Anonymous sign-in failed.");
    } catch (e) {
      throw AuthException("An unexpected error occurred during anonymous sign-in: $e");
    }
  }

  // تسجيل الخروج
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Sign-out failed.");
    } catch (e) {
      throw AuthException("An unexpected error occurred during sign-out: $e");
    }
  }
}
