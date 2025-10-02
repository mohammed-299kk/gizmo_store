import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/screens/product/product_detail_screen.dart';
import 'package:gizmo_store/services/auth_service.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  IconData _getProductIcon(String category) {
    switch (category.toLowerCase()) {
      case 'smartphones':
      case 'هواتف ذكية':
        return Icons.smartphone;
      case 'laptops':
      case 'أجهزة الكمبيوتر المحمولة':
        return Icons.laptop;
      case 'tablets':
      case 'الأجهزة اللوحية':
        return Icons.tablet;
      case 'watches':
      case 'الساعات الذكية':
        return Icons.watch;
      case 'headphones':
      case 'سماعات الرأس':
        return Icons.headphones;
      case 'accessories':
      case 'الإكسسوارات':
        return Icons.cable;
      default:
        return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.signOut(context);
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FirestoreListView<Map<String, dynamic>>(
          query: FirebaseFirestore.instance.collection('products'),
          itemBuilder: (context, snapshot) {
            final product = Product.fromMap(snapshot.data()!, snapshot.id);
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.purple.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      _getProductIcon(product.category ?? 'other'),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (product.category != null)
                      Text(
                        product.category!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
