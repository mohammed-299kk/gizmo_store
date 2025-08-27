import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAdmin = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _isAdmin;
  bool get isAuthenticated => _user != null && _isAdmin;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _checkAdminStatus(user.uid);
      } else {
        _isAdmin = false;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _errorMessage = null;
      
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        await _checkAdminStatus(result.user!.uid);
        if (!_isAdmin) {
          await signOut();
          throw Exception('Access denied. Admin privileges required.');
        }
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      throw Exception(_errorMessage);
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _isAdmin = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error signing out';
      notifyListeners();
    }
  }

  Future<void> _checkAdminStatus(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        _isAdmin = data?['role'] == 'admin' || data?['isAdmin'] == true;
      } else {
        _isAdmin = false;
      }
    } catch (e) {
      _isAdmin = false;
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'User account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Try again later';
      default:
        return 'Authentication failed';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
