import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ProductsScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? products; // قائمة المنتجات الوهمية

  const ProductsScreen({super.key, this.products});

  @override
  Widget build(BuildContext context) {
    // إذا وصلت قائمة منتجات، اعرضها مباشرة
    if (products != null && products!.isNotEmpty) {
      return ListView.builder(
        itemCount: products!.length,
        itemBuilder: (context, index) {
          final product = products![index];
          return ListTile(
            title: Text(product['name'] ?? 'منتج بدون اسم'),
            subtitle: Text("السعر: ${product['price'] ?? 'غير محدد'} جنيه"),
          );
        },
      );
    }

    // خلاف ذلك، استخدم Firestore
    final query =
        FirebaseFirestore.instance.collection('products').orderBy('name');

    return FirestoreListView<Map<String, dynamic>>(
      query: query,
      itemBuilder: (context, snapshot) {
        if (!snapshot.exists) {
          return const ListTile(
            title: Text("لا توجد منتجات بعد"),
          );
        }

        final product = snapshot.data();

        return ListTile(
          title: Text(product['name'] ?? 'منتج بدون اسم'),
          subtitle: Text("السعر: ${product['price'] ?? 'غير محدد'} جنيه"),
        );
      },
    );
  }
}
