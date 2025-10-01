// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firebase_options.dart';

// void main() async {
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
  
//   print('🔥 Firebase initialized successfully');
  
//   final firestore = FirebaseFirestore.instance;
  
//   try {
//     print('🛍️ Adding new products...');
    
//     // Add Google Pixel 8 Pro
//     await firestore.collection('products').add({
//       'name': 'Google Pixel 8 Pro',
//       'description': 'هاتف ذكي متطور من Google بكاميرا احترافية وذكاء اصطناعي',
//       'price': 1899500.0,
//       'originalPrice': 2199500.0,
//       'image': 'https://lh3.googleusercontent.com/Nu3a6F80WfixUquxXzGDdLkYJnJtQARkJ-dh0SB1CzGKBUPCoWJzZw',
//       'category': 'الهواتف الذكية',
//       'rating': 4.6,
//       'reviewsCount': 89,
//       'featured': true,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
    
//     // Add Samsung Galaxy Watch 6
//     await firestore.collection('products').add({
//       'name': 'Samsung Galaxy Watch 6',
//       'description': 'ساعة ذكية متطورة مع مراقبة صحية شاملة',
//       'price': 649500.0,
//       'originalPrice': 799500.0,
//       'image': 'https://images.samsung.com/is/image/samsung/p6pim/ae/2307/gallery/ae-galaxy-watch6-r930-sm-r930nzeamea-537402886',
//       'category': 'الساعات الذكية',
//       'rating': 4.4,
//       'reviewsCount': 67,
//       'featured': false,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
    
//     // Add Bose QuietComfort 45
//     await firestore.collection('products').add({
//       'name': 'Bose QuietComfort 45',
//       'description': 'سماعات لاسلكية بتقنية إلغاء الضوضاء المتقدمة',
//       'price': 749500.0,
//       'originalPrice': 899500.0,
//       'image': 'https://assets.bose.com/content/dam/Bose_DAM/Web/consumer_electronics/global/products/headphones/qc45_headphones/product_silo_images/QC45_PDP_Ecom-Gallery-B01.jpg',
//       'category': 'سماعات الرأس',
//       'rating': 4.8,
//       'reviewsCount': 156,
//       'featured': true,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
    
//     // Add Dell XPS 13
//     await firestore.collection('products').add({
//       'name': 'Dell XPS 13',
//       'description': 'لابتوب نحيف وخفيف بأداء عالي للمحترفين',
//       'price': 2299500.0,
//       'originalPrice': 2699500.0,
//       'image': 'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-13-9315/media-gallery/notebook-xps-13-9315-nt-blue-gallery-1.psd',
//       'category': 'أجهزة الكمبيوتر المحمولة',
//       'rating': 4.5,
//       'reviewsCount': 78,
//       'featured': false,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
    
//     // Add Samsung Galaxy Tab S9
//     await firestore.collection('products').add({
//       'name': 'Samsung Galaxy Tab S9',
//       'description': 'تابلت متطور بشاشة عالية الدقة وقلم S Pen',
//       'price': 1549500.0,
//       'originalPrice': 1799500.0,
//       'image': 'https://images.samsung.com/is/image/samsung/p6pim/ae/2307/gallery/ae-galaxy-tab-s9-x710-sm-x710nzeamea-537402901',
//       'category': 'الأجهزة اللوحية',
//       'rating': 4.3,
//       'reviewsCount': 45,
//       'featured': false,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
    
//     print('✅ New products added successfully!');
//     print('🎉 Database setup completed!');
//   } catch (e) {
//     print('❌ Error during setup: $e');
//   }
// }