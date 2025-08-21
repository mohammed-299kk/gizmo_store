// تم إنشاء هذا الملف تلقائياً بواسطة FlutterFire CLI
// يجب أن يكون موجوداً إذا استخدمت flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM',
    appId: '1:32902740595:web:7de8f1273a64f9f28fc806',
    messagingSenderId: '32902740595',
    projectId: 'gizmostore-2a3ff',
    authDomain: 'gizmostore-2a3ff.firebaseapp.com',
    storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
    measurementId: 'G-WF0Z8EKYMX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_iLiUfhwwkgcWjnM_mUqiKrmotqtdoX0',
    appId: '1:32902740595:android:bec80d1f18d70dfb8fc806',
    messagingSenderId: '32902740595',
    projectId: 'gizmostore-2a3ff',
    storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_iLiUfhwwkgcWjnM_mUqiKrmotqtdoX0',
    appId: '1:32902740595:ios:bec80d1f18d70dfb8fc806',
    messagingSenderId: '32902740595',
    projectId: 'gizmostore-2a3ff',
    storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
    iosBundleId: 'com.example.gizmoStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_iLiUfhwwkgcWjnM_mUqiKrmotqtdoX0',
    appId: '1:32902740595:ios:bec80d1f18d70dfb8fc806',
    messagingSenderId: '32902740595',
    projectId: 'gizmostore-2a3ff',
    storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
    iosBundleId: 'com.example.gizmoStore',
  );
}
