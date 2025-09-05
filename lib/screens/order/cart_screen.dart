import 'package:flutter/material.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/screens/order/checkout_screen.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

// Sample product data for testing CartScreen
final List<Product> featuredProducts = [
  Product(
    id: 'some-id', // provide a value for the id parameter
    name: 'iPhone 15 Pro Max',
    price: 1200.0,
    description: 'iPhone 15 Pro Max with advanced A17 Pro chip.',
    image: 'https://example.com/iphone15pro.jpg',
    discount: 10,
    originalPrice: 1330.0,
    rating: 4.5,
    reviewsCount: 25,
    specifications: ['6.7 inch display', '48MP camera', '256GB storage'],
    reviews: [
      {
        'name': 'Mohammed - Khartoum',
        'rating': 5,
        'comment': 'Excellent product!',
        'date': '2024-12-15'
      },
      {
        'name': 'Sara - Khartoum North',
        'rating': 4,
        'comment': 'Very good but expensive',
        'date': '2024-12-12'
      },
    ],
  ),
  Product(
    id: 'some_id', // replace with a valid id
    name: 'iPhone 15 Pro Max',
    price: 1200.0,
    description: 'iPhone 15 Pro Max with advanced A17 Pro chip.',
    image: 'https://example.com/iphone15pro.jpg',
    discount: 10,
    originalPrice: 1330.0,
    rating: 4.5,
    reviewsCount: 25,
    specifications: ['6.7 inch display', '48MP camera', '256GB storage'],
    reviews: [
      {'name': 'Ahmed', 'rating': 4, 'comment': 'Very good'},
    ],
  ),
];

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    // Initialize cart items using featuredProducts
    cartItems = [
      CartItem(product: featuredProducts[0], quantity: 1),
      CartItem(product: featuredProducts[1], quantity: 2),
    ];
  }

  double get subtotal => cartItems.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity));

  double get shipping => subtotal > 100 ? 0 : 10;

  double get total => subtotal + shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.shoppingCart)),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.cartEmpty,
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.shopNow),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(item.product.image ?? ''),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    // Handle image loading error silently
                                  },
                                ),
                              ),
                              child: item.product.image == null || item.product.image!.isEmpty
                                  ? const Icon(Icons.image_not_supported, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('\$${item.product.price}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB71C1C)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('${AppLocalizations.of(context)!.quantity}: '),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]!),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (item.quantity > 1) {
                                                  setState(() {
                                                    item.quantity--;
                                                  });
                                                }
                                              },
                                              child: const Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(Icons.remove,
                                                      size: 16)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              child: Text('${item.quantity}'),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  item.quantity++;
                                                });
                                              },
                                              child: const Padding(
                                                  padding: EdgeInsets.all(4),
                                                  child: Icon(Icons.add,
                                                      size: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            cartItems.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.subtotal),
                          Text('\$${subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.shipping),
                          Text(shipping == 0
                              ? AppLocalizations.of(context)!.free
                              : '\$${shipping.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.total,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB71C1C)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.proceedToCheckout,
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
