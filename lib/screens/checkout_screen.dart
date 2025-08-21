import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _placeOrder(BuildContext context) {
    final order = Order(
      items: cartItems,
      date: DateTime.now(),
      total: totalPrice,
    );

    // هنا يمكن إضافة حفظ الطلب في Firestore أو أي مكان آخر
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء الطلب بنجاح!')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.product.name),
                    subtitle:
                        Text('الكمية: ${item.quantity} - \$${item.totalPrice}'),
                  );
                },
              ),
            ),
            Text('المجموع: \$${totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _placeOrder(context),
              child: const Text('تأكيد الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}
