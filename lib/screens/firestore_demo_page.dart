import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'products_list_page.dart'; // استيراد صفحة عرض المنتجات

class FirestoreDemoPage extends StatelessWidget {
  const FirestoreDemoPage({super.key});

  // دالة تضيف منتج جديد وتنتقل بعد الإضافة
  Future<void> addProduct(BuildContext context) async {
    // إنشاء منتج تجريبي
    final product = Product(
      id: '', // سيتم توليد ID تلقائي من Firestore
      name: 'New Phone',
      description: 'A cool new phone from GizmoStore',
      price: 799,
      image: 'https://m.media-amazon.com/images/I/61+btTqf7tL._AC_SL1500_.jpg', // صورة خارجية للهاتف
    );

    try {
      // إضافة المنتج إلى Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'created_at': FieldValue.serverTimestamp(),
      });

      // إعلام المستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );

      // الانتقال لصفحة عرض المنتجات
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProductsListPage()),
      );
    } catch (e) {
      print('Error adding product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Add Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => addProduct(context),
          child: const Text('Add Product'),
        ),
      ),
    );
  }
}
