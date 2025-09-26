import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('Firebase initialized successfully');
    
    // Check products collection
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();
    
    print('Products found: ${productsSnapshot.docs.length}');
    
    if (productsSnapshot.docs.isNotEmpty) {
      print('First few products:');
      for (int i = 0; i < productsSnapshot.docs.length && i < 5; i++) {
        final doc = productsSnapshot.docs[i];
        final data = doc.data();
        print('- ${data['name']} (${data['category']}) - ${data['price']} ج.س');
      }
    } else {
      print('No products found in database');
    }
    
    // Check categories collection
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .get();
    
    print('\nCategories found: ${categoriesSnapshot.docs.length}');
    
    if (categoriesSnapshot.docs.isNotEmpty) {
      print('Categories:');
      for (final doc in categoriesSnapshot.docs) {
        final data = doc.data();
        print('- ${data['name']}');
      }
    } else {
      print('No categories found in database');
    }
    
  } catch (e) {
    print('Error: $e');
  }
}