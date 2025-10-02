import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../../models/product.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Color(0xFFB71C1C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.priceLabel}: \$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                CartService.addItem(CartItem(product: product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} ${AppLocalizations.of(context)!.addedToCart}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.addToCart),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = product.imageUrl ?? '';
    if (imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported,
          size: 200, color: Colors.grey);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: double.infinity,
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
        size: 200,
        color: Colors.grey,
      ),
    );
  }
}
