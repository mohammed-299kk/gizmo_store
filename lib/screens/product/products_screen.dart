import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final query =
        FirebaseFirestore.instance.collection('products').orderBy('name');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizmo Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: FirestoreListView<Map<String, dynamic>>(
        query: query,
        itemBuilder: (context, snapshot) {
          final product = snapshot.data();
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Price: \$${product['price']}'),
          );
        },
      ),
    );
  }
}
