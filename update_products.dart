import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  try {
    print('🔄 Updating products with featured field...');

    // Featured product IDs
    final featuredProductIds = [
      'airpods-pro-2',
      'apple-watch-series-9',
      'anker-powerbank'
    ];

    // Get all products
    final productsSnapshot = await firestore.collection('products').get();

    if (productsSnapshot.docs.isEmpty) {
      print('❌ No products found!');
      return;
    }

    final batch = firestore.batch();
    int count = 0;

    for (final doc in productsSnapshot.docs) {
      final productRef = firestore.collection('products').doc(doc.id);
      final isFeatured = featuredProductIds.contains(doc.id);

      batch.update(productRef, {
        'featured': isFeatured,
      });

      count++;
      print('📝 ${doc.id}: featured = $isFeatured');
    }

    // Commit the batch
    await batch.commit();

    print('✅ Successfully updated $count products with featured field!');
    print('🌟 ${featuredProductIds.length} products marked as featured');
  } catch (error) {
    print('❌ Error updating products: $error');
  }
}