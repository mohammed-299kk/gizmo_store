// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';

// void main() async {
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   try {
//     // Create admin user
//     final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: 'admin@gizmo.com',
//       password: 'gizmo1234',
//     );

//     final user = userCredential.user;
//     if (user != null) {
//       // Update display name
//       await user.updateDisplayName('Admin User');
      
//       // Create user document in Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': 'Admin User',
//         'isAdmin': true,
//         'role': 'admin',
//         'userType': 'admin',
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       print('✅ Admin user created successfully!');
//       print('Email: ${user.email}');
//       print('UID: ${user.uid}');
//       print('Password: gizmo1234');
//     }
//   } catch (e) {
//     if (e.toString().contains('email-already-in-use')) {
//       print('⚠️  Admin user already exists. Trying to sign in...');
      
//       try {
//         final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: 'admin@gizmo.com',
//           password: 'gizmo1234',
//         );
        
//         final user = userCredential.user;
//         if (user != null) {
//           // Update Firestore document
//           await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//             'uid': user.uid,
//             'email': user.email,
//             'displayName': 'Admin User',
//             'isAdmin': true,
//             'role': 'admin',
//             'userType': 'admin',
//             'updatedAt': FieldValue.serverTimestamp(),
//           }, SetOptions(merge: true));
          
//           print('✅ Admin user updated successfully!');
//           print('Email: ${user.email}');
//           print('UID: ${user.uid}');
//         }
//       } catch (signInError) {
//         print('❌ Error signing in: $signInError');
//       }
//     } else {
//       print('❌ Error creating admin user: $e');
//     }
//   }
// }