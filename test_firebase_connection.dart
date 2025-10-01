// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print('✅ Firebase initialized successfully');
    
//     // Test Firestore connection
//     final firestore = FirebaseFirestore.instance;
    
//     // Check products collection
//     print('🔍 Checking products collection...');
//     final productsSnapshot = await firestore.collection('products').get();
//     print('📦 Found ${productsSnapshot.docs.length} products');
    
//     if (productsSnapshot.docs.isNotEmpty) {
//       print('📋 First product:');
//       final firstProduct = productsSnapshot.docs.first.data();
//       print('   Name: ${firstProduct['name']}');
//       print('   Price: ${firstProduct['price']}');
//       print('   Category: ${firstProduct['category']}');
//     }
    
//     // Check categories collection
//     print('🔍 Checking categories collection...');
//     final categoriesSnapshot = await firestore.collection('categories').get();
//     print('📂 Found ${categoriesSnapshot.docs.length} categories');
    
//     if (categoriesSnapshot.docs.isNotEmpty) {
//       print('📋 Categories:');
//       for (var doc in categoriesSnapshot.docs) {
//         final category = doc.data();
//         print('   - ${category['name']} (${category['nameEn']})');
//       }
//     }
    
//   } catch (e) {
//     print('❌ Error: $e');
//   }
// }