// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

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
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع أثناء تسجيل الدخول");
    }
  }

  // إنشاء حساب جديد
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع أثناء إنشاء الحساب");
    }
  }

  // تسجيل الدخول كضيف (Anonymous)
  Future<User?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("فشل تسجيل الدخول كضيف");
    }
  }

  // تسجيل الخروج
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("فشل تسجيل الخروج");
    }
  }
}
