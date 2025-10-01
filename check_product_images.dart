// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   print('🔍 Checking product images...\n');

//   try {
//     final firestore = FirebaseFirestore.instance;
//     final snapshot = await firestore.collection('products').get();
    
//     print('📊 Total products: ${snapshot.docs.length}');
//     print('=' * 50);
    
//     int brokenImages = 0;
//     int workingImages = 0;
//     List<String> brokenProductIds = [];
    
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final name = data['name'] ?? 'Unknown';
//       final imageUrl = data['image'] ?? '';
//       final featured = data['featured'] ?? false;
      
//       if (imageUrl.isEmpty || 
//           imageUrl == 'null' || 
//           imageUrl.contains('placeholder') || 
//           imageUrl.contains('example.com') ||
//           imageUrl.contains('via.placeholder.com')) {
//         print('❌ ${featured ? '[FEATURED] ' : ''}$name');
//         print('   Image: $imageUrl');
//         print('   ID: ${doc.id}');
//         brokenImages++;
//         brokenProductIds.add(doc.id);
//       } else {
//         print('✅ ${featured ? '[FEATURED] ' : ''}$name');
//         workingImages++;
//       }
//       print('');
//     }
    
//     print('=' * 50);
//     print('📈 Summary:');
//     print('✅ Working images: $workingImages');
//     print('❌ Broken/missing images: $brokenImages');
    
//     if (brokenProductIds.isNotEmpty) {
//       print('\n🗑️ Products with broken images (IDs):');
//       for (String id in brokenProductIds) {
//         print('  - $id');
//       }
//     }
    
//   } catch (e) {
//     print('❌ Error: $e');
//   }
// }