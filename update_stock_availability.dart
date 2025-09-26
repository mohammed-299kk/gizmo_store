import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  print('🚀 بدء تحديث حالة المخزون للمنتجات...');
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDvzKKWzKOLKOLKOLKOLKOLKOLKOLKOLKOL",
        authDomain: "gizmo-store-2024.firebaseapp.com",
        projectId: "gizmo-store-2024",
        storageBucket: "gizmo-store-2024.firebasestorage.app",
        messagingSenderId: "123456789",
        appId: "1:123456789:web:abcdefghijklmnop",
      ),
    );
    
    print('✅ تم تهيئة Firebase بنجاح');
    
    final firestore = FirebaseFirestore.instance;
    
    // Get all products
    print('📦 جلب جميع المنتجات...');
    final querySnapshot = await firestore.collection('products').get();
    
    print('📊 تم العثور على ${querySnapshot.docs.length} منتج');
    
    int updatedCount = 0;
    int errorCount = 0;
    
    // Update each product
    for (var doc in querySnapshot.docs) {
      try {
        final data = doc.data();
        final productName = data['name'] ?? 'منتج غير معروف';
        final currentStock = data['stock'] ?? data['stockQuantity'] ?? 0;
        final isAvailable = data['isAvailable'] ?? false;
        
        print('🔄 تحديث المنتج: $productName');
        print('   المخزون الحالي: $currentStock');
        print('   متوفر حالياً: $isAvailable');
        
        // Determine new stock quantity based on current stock
        int newStock;
        if (currentStock <= 0) {
          newStock = 25; // Default stock for out-of-stock items
        } else if (currentStock < 10) {
          newStock = currentStock + 20; // Add 20 to low stock items
        } else {
          newStock = currentStock; // Keep current stock if adequate
        }
        
        // Update the product
        await doc.reference.update({
          'stock': newStock,
          'stockQuantity': newStock, // For compatibility
          'isAvailable': true,
          'inStock': true, // For compatibility
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        print('   ✅ تم التحديث - المخزون الجديد: $newStock');
        updatedCount++;
        
        // Add a small delay to avoid overwhelming Firestore
        await Future.delayed(const Duration(milliseconds: 100));
        
      } catch (e) {
        print('   ❌ خطأ في تحديث المنتج: $e');
        errorCount++;
      }
    }
    
    print('\n🎉 اكتمل تحديث المخزون!');
    print('✅ تم تحديث $updatedCount منتج بنجاح');
    if (errorCount > 0) {
      print('❌ فشل في تحديث $errorCount منتج');
    }
    
    // Verify the updates
    print('\n🔍 التحقق من التحديثات...');
    final verifySnapshot = await firestore.collection('products').get();
    
    int availableCount = 0;
    int totalStock = 0;
    
    for (var doc in verifySnapshot.docs) {
      final data = doc.data();
      final isAvailable = data['isAvailable'] ?? false;
      final stock = data['stock'] ?? data['stockQuantity'] ?? 0;
      
      if (isAvailable && stock > 0) {
        availableCount++;
      }
      totalStock += stock as int;
    }
    
    print('📊 النتائج النهائية:');
    print('   المنتجات المتوفرة: $availableCount من ${verifySnapshot.docs.length}');
    print('   إجمالي المخزون: $totalStock قطعة');
    
    if (availableCount == verifySnapshot.docs.length) {
      print('🎯 ممتاز! جميع المنتجات أصبحت متوفرة في المخزون');
    } else {
      print('⚠️ تحذير: ${verifySnapshot.docs.length - availableCount} منتج لا يزال غير متوفر');
    }
    
  } catch (e) {
    print('❌ خطأ عام: $e');
    exit(1);
  }
  
  print('\n✨ انتهى السكريبت بنجاح!');
  exit(0);
}