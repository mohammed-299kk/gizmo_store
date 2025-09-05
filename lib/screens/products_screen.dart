import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import '../l10n/app_localizations.dart';

class ProductsScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? products;

  const ProductsScreen({super.key, this.products});

  @override
  Widget build(BuildContext context) {
    // If products list is provided, display it directly
    if (products != null && products!.isNotEmpty) {
      return ListView.builder(
        itemCount: products!.length,
        itemBuilder: (context, index) {
          final product = products![index];
          return ListTile(
            title: Text(product['name'] ?? AppLocalizations.of(context)!.productWithoutName),
            subtitle: Text("${AppLocalizations.of(context)!.price}: ${product['price'] ?? AppLocalizations.of(context)!.notSpecified} ${AppLocalizations.of(context)!.currency}"),
          );
        },
      );
    }

    // Otherwise, use Firestore
    final query =
        FirebaseFirestore.instance.collection('products').orderBy('name');

    return FirestoreListView<Map<String, dynamic>>(
      query: query,
      itemBuilder: (context, snapshot) {
        if (!snapshot.exists) {
          return const ListTile(
            title: Text(AppLocalizations.of(context)!.noProductsYet),
          );
        }

        final product = snapshot.data();

        return ListTile(
          title: Text(product['name'] ?? AppLocalizations.of(context)!.productWithoutName),
          subtitle: Text(AppLocalizations.of(context)!.priceFormat.replaceAll('{price}', product['price']?.toString() ?? AppLocalizations.of(context)!.notSpecified)),
        );
      },
    );
  }
}
