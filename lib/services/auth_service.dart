// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../utils/app_exceptions.dart'; // Added this line

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to track user state changes (login/logout)
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Check current login status
  bool get isLoggedIn => _auth.currentUser != null;

  bool get isGuest =>
      _auth.currentUser != null && _auth.currentUser!.isAnonymous;

  // Login with email and password
  Future<User?> signIn(String email, String password, BuildContext context) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException(e.message ?? localizations.authenticationFailed);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException("${localizations.unexpectedSignInError}: $e");
    }
  }

  // Create new account
  Future<User?> signUp(String email, String password, BuildContext context) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException(e.message ?? localizations.accountCreationFailed);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException("${localizations.unexpectedSignUpError}: $e");
    }
  }

  // Login as guest (Anonymous)
  Future<User?> signInAnonymously(BuildContext context) async {
    try {
      final credential = await _auth.signInAnonymously();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException(e.message ?? localizations.anonymousSignInFailed);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException("${localizations.unexpectedAnonymousSignInError}: $e");
    }
  }

  // Logout
  static Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException(e.message ?? localizations.signOutFailed);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw AuthException("${localizations.unexpectedSignOutError}: $e");
    }
  }
}
