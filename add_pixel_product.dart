// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   try {
//     // Initialize Firebase
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
    
//     print('🔄 جاري إضافة منتج Google Pixel 8...');
    
//     // Product data
//     final productData = {
//       'name': 'Google Pixel 8',
//       'nameAr': 'جوجل بيكسل 8',
//       'description': 'Pure Android experience with advanced AI photography',
//       'descriptionAr': 'تجربة أندرويد نقية مع تصوير ذكي متقدم',
//       'price': 699,
//       'originalPrice': 799,
//       'category': 'smartphones',
//       'categoryAr': 'هواتف ذكية',
//       'brand': 'Google',
//       'brandAr': 'جوجل',
//       'images': [
//         'https://res.cloudinary.com/demo/image/upload/v1640123456/pixel-8-1.jpg',
//         'https://res.cloudinary.com/demo/image/upload/v1640123456/pixel-8-2.jpg'
//       ],
//       'inStock': true,
//       'stockQuantity': 25,
//       'rating': 4.7,
//       'reviewCount': 156,
//       'specifications': {
//         'screen': '6.2 inch OLED',
//         'processor': 'Google Tensor G3',
//         'storage': '128GB',
//         'camera': '50MP Dual Camera',
//         'battery': '4575 mAh'
//       },
//       'features': ['5G', 'Pure Android', 'AI Photography', 'Fast Charging'],
//       'colors': ['Obsidian', 'Hazel', 'Rose'],
//       'createdAt': FieldValue.serverTimestamp(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     };
    
//     // Add to Firestore
//     await FirebaseFirestore.instance
//         .collection('products')
//         .doc('google-pixel-8')
//         .set(productData);
    
//     print('✅ تم إضافة منتج Google Pixel 8 بنجاح!');
//     print('📱 معرف المنتج: google-pixel-8');
    
//   } catch (e) {
//     print('❌ خطأ في إضافة المنتج: $e');
//     exit(1);
//   }
  
//   exit(0);
// }