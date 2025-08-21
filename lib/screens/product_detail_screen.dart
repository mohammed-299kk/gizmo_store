import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final List<CartItem> cart;

  const ProductDetailScreen(
      {super.key, required this.product, required this.cart});

  void _addToCart(BuildContext context) {
    final existingItem = cart.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product: product, quantity: 0));

    if (existingItem.quantity == 0) {
      cart.add(CartItem(product: product));
    } else {
      existingItem.quantity += 1;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
    );
  }

  void _goToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen(cartItems: cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text('السعر: \$${product.price}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _addToCart(context),
                  child: const Text('أضف إلى السلة'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => _goToCart(context),
                  child: const Text('اذهب إلى السلة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
