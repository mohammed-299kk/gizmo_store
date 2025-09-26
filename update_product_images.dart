import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('🔥 Firebase initialized successfully');
    
    final firestore = FirebaseFirestore.instance;
    
    print('🖼️ Updating product images...');
    
    // Update iPhone 15 Pro with working image
    await firestore.collection('products').doc('iphone-15-pro').update({
      'imageUrl': 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-naturaltitanium?wid=2000&hei=2000&fmt=p-jpg&qlt=80&.v=1692895395658',
      'image': 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-naturaltitanium?wid=2000&hei=2000&fmt=p-jpg&qlt=80&.v=1692895395658',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('✅ Updated iPhone 15 Pro image');
    
    print('🎉 Product images update completed!');
  } catch (e) {
    print('❌ Error: $e');
  }
}