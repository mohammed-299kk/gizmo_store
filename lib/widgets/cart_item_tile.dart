import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(cartItem.product.name),
        subtitle: Text('السعر: \$${cartItem.product.price.toStringAsFixed(2)}'),
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
              Text('${cartItem.quantity}'),
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
