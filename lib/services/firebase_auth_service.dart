import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الحصول على المستخدم الحالي
  static User? get currentUser => _auth.currentUser;

  // تدفق حالة المصادقة
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // تحديث آخر تسجيل دخول
      if (credential.user != null) {
        await _updateUserLastLogin(credential.user!.uid);
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  // إنشاء حساب جديد
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // تحديث اسم المستخدم
        await credential.user!.updateDisplayName(name);
        
        // إنشاء ملف المستخدم في Firestore
        await _createUserProfile(
          uid: credential.user!.uid,
          email: email,
          name: name,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  // تسجيل الدخول كضيف
  static Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      
      if (credential.user != null) {
        // إنشاء ملف ضيف في Firestore
        await _createGuestProfile(credential.user!.uid);
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  // تسجيل الخروج
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('فشل في تسجيل الخروج: $e');
    }
  }

  // إرسال رابط إعادة تعيين كلمة المرور
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('فشل في إرسال رابط إعادة التعيين: $e');
    }
  }

  // إنشاء ملف المستخدم في Firestore
  static Future<void> _createUserProfile({
    required String uid,
    required String email,
    required String name,
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
      print('خطأ في إنشاء ملف المستخدم: $e');
    }
  }

  // إنشاء ملف الضيف في Firestore
  static Future<void> _createGuestProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': null,
        'name': 'ضيف',
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
          'cartItems': [],
        }
      });
    } catch (e) {
      print('خطأ في إنشاء ملف الضيف: $e');
    }
  }

  // تحديث آخر تسجيل دخول
  static Future<void> _updateUserLastLogin(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('خطأ في تحديث آخر تسجيل دخول: $e');
    }
  }

  // الحصول على بيانات المستخدم من Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
      return null;
    }
  }

  // تحديث بيانات المستخدم
  static Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('فشل في تحديث البيانات: $e');
    }
  }

  // معالجة أخطاء Firebase Auth
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'لا يوجد مستخدم بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً. حاول لاحقاً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      case 'invalid-credential':
        return 'بيانات الاعتماد غير صحيحة';
      case 'network-request-failed':
        return 'فشل في الاتصال بالشبكة';
      case 'requires-recent-login':
        return 'يتطلب تسجيل دخول حديث';
      default:
        return 'حدث خطأ في المصادقة: ${e.message}';
    }
  }

  // التحقق من حالة الاتصال
  static Future<bool> checkConnection() async {
    try {
      await _firestore.collection('test').doc('connection').get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // إحصائيات المستخدم
  static Future<Map<String, dynamic>> getUserStats(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['stats'] ?? {};
      }
      return {};
    } catch (e) {
      print('خطأ في جلب إحصائيات المستخدم: $e');
      return {};
    }
  }

  // تحديث إحصائيات المستخدم
  static Future<void> updateUserStats(String uid, Map<String, dynamic> stats) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'stats': stats,
      });
    } catch (e) {
      print('خطأ في تحديث إحصائيات المستخدم: $e');
    }
  }
}