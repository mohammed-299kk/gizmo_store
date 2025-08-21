// lib/widgets/cart_summary.dart
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CartItem> cartItems = CartService.getItems();
    final double total =
        cartItems.fold(0, (sum, item) => sum + item.totalPrice);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('عدد العناصر: ${cartItems.length}'),
            const SizedBox(height: 8),
            Text('الإجمالي: \$${total.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // هنا يمكن توجيه المستخدم لصفحة الدفع أو إتمام الطلب
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم الانتقال لصفحة الدفع')),
                );
              },
              child: const Text('إتمام الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}
