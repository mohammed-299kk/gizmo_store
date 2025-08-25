import 'package:flutter/material.dart';
import 'package:gizmo_store/providers/checkout_provider.dart';
import 'package:provider/provider.dart';
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
    final checkoutProvider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عنوان الشحن', style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text(checkoutProvider.selectedAddress ?? 'الرجاء تحديد عنوان'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/addresses'),
            ),
            const Divider(),
            Text('طريقة الشحن', style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text(checkoutProvider.selectedShippingMethod ?? 'الرجاء تحديد طريقة الشحن'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/shipping'),
            ),
            const Divider(),
            Text('ملخص الطلب', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.product.name),
                    subtitle:
                        Text('الكمية: ${item.quantity}'),
                    trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('المجموع', style: Theme.of(context).textTheme.titleLarge),
                Text('\$${totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('تأكيد الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}