import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Authentication state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login with email and password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login
      if (credential.user != null) {
        await _updateUserLastLogin(credential.user!.uid, context);
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e, context);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw Exception('${localizations.unexpectedError}: $e');
    }
  }

  // Create new account
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? firstName,
    String? middleName,
    String? lastName,
    required BuildContext context,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update username
        await credential.user!.updateDisplayName(name);

        // Create user profile in Firestore
        await _createUserProfile(
          uid: credential.user!.uid,
          email: email,
          name: name,
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          context: context,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e, context);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw Exception('${localizations.unexpectedError}: $e');
    }
  }

  // Sign in as guest
  static Future<UserCredential?> signInAnonymously(BuildContext context) async {
    try {
      final credential = await _auth.signInAnonymously();
      
      if (credential.user != null) {
        // Create guest profile in Firestore
        await _createGuestProfile(credential.user!.uid, context);
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e, context);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw Exception('${localizations.unexpectedError}: $e');
    }
  }

  // Sign out
  static Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw Exception('${localizations.signOutFailed}: $e');
    }
  }

  // Send password reset email
  static Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e, context);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw Exception('${localizations.passwordResetFailed}: $e');
    }
  }

  // إنشاء ملف المستخدم في Firestore
  static Future<void> _createUserProfile({
    required String uid,
    required String email,
    required String name,
    String? firstName,
    String? middleName,
    String? lastName,
    required BuildContext context,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'userType': 'user',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'preferences': {
          'language': 'ar',
          'notifications': true,
          'theme': 'dark',
        },
        'profile': {
          'firstName': firstName,
          'middleName': middleName,
          'lastName': lastName,
          'avatar': null,
          'phone': null,
          'address': null,
          'dateOfBirth': null,
        },
        'stats': {
          'totalOrders': 0,
          'totalSpent': 0,
          'favoriteProducts': [],
          'cartItems': [],
        }
      });
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      debugPrint('${localizations.errorCreatingUserProfile}: $e');
    }
  }

  // Create guest profile in Firestore
  static Future<void> _createGuestProfile(String uid, BuildContext context) async {
    try {
      final localizations = AppLocalizations.of(context)!;
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': null,
        'name': localizations.guestName,
        'userType': 'guest',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'preferences': {
          'language': 'ar',
          'notifications': false,
          'theme': 'dark',
        },
        'stats': {
          'totalOrders': 0,
          'totalSpent': 0,
          'favoriteProducts': [],
          'cartItems': [],
        }
      });
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      debugPrint('${localizations.errorCreatingGuestProfile}: $e');
    }
  }

  // Update last login
  static Future<void> _updateUserLastLogin(String uid, BuildContext context) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      debugPrint('${localizations.errorUpdatingLastLogin}: $e');
    }
  }

  // Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid, BuildContext context) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      debugPrint('${localizations.errorFetchingUserData}: $e');
      return null;
    }
  }

  // Update user data
  static Future<void> updateUserData(String uid, Map<String, dynamic> data, BuildContext context) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      throw Exception('${localizations.dataUpdateFailed}: $e');
    }
  }

  // Handle Firebase Auth exceptions
  static Exception _handleAuthException(FirebaseAuthException e, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    switch (e.code) {
      case 'user-not-found':
        return Exception(localizations.userNotFound);
      case 'wrong-password':
        return Exception(localizations.wrongPassword);
      case 'email-already-in-use':
        return Exception(localizations.emailAlreadyInUse);
      case 'weak-password':
        return Exception(localizations.weakPassword);
      case 'invalid-email':
        return Exception(localizations.invalidEmail);
      case 'user-disabled':
        return Exception(localizations.userDisabled);
      case 'too-many-requests':
        return Exception(localizations.tooManyRequests);
      case 'operation-not-allowed':
        return Exception(localizations.operationNotAllowed);
      case 'invalid-credential':
        return Exception(localizations.invalidCredential);
      case 'network-request-failed':
        return Exception(localizations.networkRequestFailed);
      case 'requires-recent-login':
        return Exception(localizations.requiresRecentLogin);
      default:
        return Exception('${localizations.authenticationError}: ${e.message}');
    }
  }

  // Check connection status
  static Future<bool> checkConnection() async {
    try {
      await _firestore.collection('test').doc('connection').get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // User statistics
  static Future<Map<String, dynamic>> getUserStats(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['stats'] ?? {};
      }
      return {};
    } catch (e) {
      debugPrint('Error fetching user statistics: $e');
      return {};
    }
  }

  // Update user statistics
  static Future<void> updateUserStats(String uid, Map<String, dynamic> stats, BuildContext context) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'stats': stats,
      });
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      debugPrint('${localizations.errorUpdatingUserStats}: $e');
    }
  }

  // Check if user is admin
  static Future<bool> isUserAdmin(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('Admin check timed out for uid: $uid');
          throw Exception('Timeout checking admin status');
        },
      );
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return data['isAdmin'] == true || 
                 data['role'] == 'admin' || 
                 data['userType'] == 'admin';
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking admin status: $e');
      return false;
    }
  }

  // Get user role
  static Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('User role check timed out for uid: $uid');
          throw Exception('Timeout getting user role');
        },
      );
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          return data['role'] ?? data['userType'] ?? 'user';
        }
      }
      return 'user';
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return 'user';
    }
  }
}
