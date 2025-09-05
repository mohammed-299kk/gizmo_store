import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({super.key, required this.cartItem});

  String _formatPrice(double price) {
    String priceStr = price.toStringAsFixed(2);
    List<String> parts = priceStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];
    
    // Add thousand separators
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    
    return '$formattedInteger.$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(cartItem.product.name),
        subtitle: Text('السعر: \$${_formatPrice(cartItem.product.price)}'),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => CartService.updateQuantity(
                    cartItem.product.id, cartItem.quantity - 1),
              ),
              Text(cartItem.quantity.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => CartService.updateQuantity(
                    cartItem.product.id, cartItem.quantity + 1),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => CartService.removeItem(cartItem.product.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
