// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // تحديث الشاشة بعد أي تعديل على السلة
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<CartItem> items =
        CartService.getItems(); // استدعاء static مباشرة

    double total = items.fold(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات')),
      body: items.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text('السعر: \$${item.product.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                int newQty = item.quantity - 1;
                                CartService.updateQuantity(
                                    item.product.id, newQty);
                                _refresh();
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                int newQty = item.quantity + 1;
                                CartService.updateQuantity(
                                    item.product.id, newQty);
                                _refresh();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                CartService.removeItem(item.product.id);
                                _refresh();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'المجموع: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    CartService.clear();
                    _refresh();
                  },
                  child: const Text('تفريغ السلة'),
                ),
              ],
            ),
    );
  }
}
