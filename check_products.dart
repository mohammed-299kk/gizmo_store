import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🔍 فحص المنتجات في قاعدة البيانات...');

  try {
    // Get products collection
    final productsRef = FirebaseFirestore.instance.collection('products');
    final snapshot = await productsRef.get();

    print('📊 عدد المنتجات الموجودة: ${snapshot.docs.length}');

    if (snapshot.docs.isEmpty) {
      print('❌ لا توجد منتجات في قاعدة البيانات');
    } else {
      print('\n📦 المنتجات الموجودة:');
      for (int i = 0; i < snapshot.docs.length && i < 10; i++) {
        final doc = snapshot.docs[i];
        final data = doc.data();
        print(
            '${i + 1}. ${data['name'] ?? 'بدون اسم'} - السعر: ${data['price'] ?? 'غير محدد'} - الفئة: ${data['categoryId'] ?? 'غير محدد'}');
      }

      if (snapshot.docs.length > 10) {
        print('... و ${snapshot.docs.length - 10} منتج آخر');
      }
    }

    // Check categories too
    final categoriesRef = FirebaseFirestore.instance.collection('categories');
    final categoriesSnapshot = await categoriesRef.get();
    print('\n📂 عدد الفئات الموجودة: ${categoriesSnapshot.docs.length}');
  } catch (e) {
    print('❌ خطأ في الاستعلام: $e');
  }

  exit(0);
}
