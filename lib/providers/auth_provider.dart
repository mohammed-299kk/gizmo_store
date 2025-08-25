import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    // الاستماع إلى تغييرات حالة المصادقة
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // تسجيل الدخول
  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      // Clear previous session before signing in
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      throw Exception(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // تسجيل جديد
  Future<void> signUp(
      String email, String password, String confirmPassword) async {
    try {
      if (password != confirmPassword) {
        throw Exception('كلمات المرور غير متطابقة');
      }

      _setLoading(true);
      _errorMessage = null;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      throw Exception(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الخروج';
      notifyListeners();
      throw Exception(_errorMessage);
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
}
