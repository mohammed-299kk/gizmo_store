import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'checkout_screen.dart';

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
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.cartEmpty)),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cartItems: widget.cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.shoppingCart)),
      body: widget.cartItems.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.cartEmpty))
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
                            '${AppLocalizations.of(context)!.quantity}: ${item.quantity} - ${item.product.currency}${item.totalPrice.toStringAsFixed(2)}'),
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
                      Text('${AppLocalizations.of(context)!.total}: ${widget.cartItems.isNotEmpty ? widget.cartItems.first.product.currency : ''}${totalPrice.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: widget.cartItems.isNotEmpty ? _checkout : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(AppLocalizations.of(context)!.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
