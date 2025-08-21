import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalPrice =>
      widget.cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  void _checkout() {
    // يمكن الانتقال لشاشة الدفع لاحقًا
    Navigator.pushNamed(context, '/checkout', arguments: widget.cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات')),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('السلة فارغة'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                            'الكمية: ${item.quantity} - \$${item.totalPrice}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(index),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('المجموع: \$${totalPrice.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _checkout,
                        child: const Text('الدفع'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
