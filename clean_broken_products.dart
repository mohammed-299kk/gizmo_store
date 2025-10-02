// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   print('🧹 Cleaning products with broken images...\n');

//   try {
//     final firestore = FirebaseFirestore.instance;
//     final snapshot = await firestore.collection('products').get();
    
//     print('📊 Total products before cleanup: ${snapshot.docs.length}');
//     print('=' * 50);
    
//     int deletedCount = 0;
//     List<String> deletedProducts = [];
    
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final name = data['name'] ?? 'Unknown';
//       final imageUrl = data['image'] ?? '';
//       final featured = data['featured'] ?? false;
      
//       // Check if image is broken or missing
//       bool isBrokenImage = imageUrl.isEmpty || 
//           imageUrl == 'null' || 
//           imageUrl.contains('placeholder') || 
//           imageUrl.contains('example.com') ||
//           imageUrl.contains('via.placeholder.com') ||
//           imageUrl.contains('assets/images/') ||
//           imageUrl.startsWith('assets/') ||
//           !imageUrl.startsWith('http');
      
//       if (isBrokenImage) {
//         print('🗑️ Deleting: ${featured ? '[FEATURED] ' : ''}$name');
//         print('   Broken image: $imageUrl');
        
//         // Delete the product
//         await doc.reference.delete();
//         deletedCount++;
//         deletedProducts.add(name);
        
//         print('   ✅ Deleted successfully');
//       } else {
//         print('✅ Keeping: ${featured ? '[FEATURED] ' : ''}$name');
//       }
//       print('');
//     }
    
//     print('=' * 50);
//     print('📈 Cleanup Summary:');
//     print('🗑️ Products deleted: $deletedCount');
//     print('✅ Products remaining: ${snapshot.docs.length - deletedCount}');
    
//     if (deletedProducts.isNotEmpty) {
//       print('\n📝 Deleted products:');
//       for (String product in deletedProducts) {
//         print('  - $product');
//       }
//     }
    
//     print('\n🎉 Cleanup completed successfully!');
    
//   } catch (e) {
//     print('❌ Error during cleanup: $e');
//   }
// }