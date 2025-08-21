import 'package:flutter/material.dart';
import 'package:gizmo_store/models/product.dart'; // تأكد من مسار الـ Product

class ProductsScreen extends StatelessWidget {
  final List<Product> products;

  const ProductsScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المنتجات')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
          );
        },
      ),
    );
  }
}
