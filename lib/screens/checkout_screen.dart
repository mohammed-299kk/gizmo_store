import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:gizmo_store/providers/checkout_provider.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/address.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _showShippingMethodDialog(BuildContext context) {
    final checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.shippingMethod),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('توصيل سريع (24 ساعة)'),
                subtitle: const Text('15 ريال'),
                leading: Radio<String>(
                  value: 'fast_delivery',
                  groupValue: checkoutProvider.selectedShippingMethod,
                  onChanged: (value) {
                    checkoutProvider.selectShippingMethod(value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('توصيل عادي (3-5 أيام)'),
                subtitle: const Text('10 ريال'),
                leading: Radio<String>(
                  value: 'standard_delivery',
                  groupValue: checkoutProvider.selectedShippingMethod,
                  onChanged: (value) {
                    checkoutProvider.selectShippingMethod(value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('توصيل مجاني (7-10 أيام)'),
                subtitle: const Text('مجاني'),
                leading: Radio<String>(
                  value: 'free_delivery',
                  groupValue: checkoutProvider.selectedShippingMethod,
                  onChanged: (value) {
                    checkoutProvider.selectShippingMethod(value!);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder(BuildContext context) {
    final checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);

    if (checkoutProvider.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.noAddressSelected)),
      );
      return;
    }

    try {
      final orderItems = cartItems
          .map((cartItem) => OrderItem(
                id: cartItem.product.id,
                name: cartItem.product.name,
                price: cartItem.product.price,
                quantity: cartItem.quantity,
                image: cartItem.product.image ?? '',
              ))
          .toList();

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'TODO_USER_ID', // TODO: Replace with actual user ID from auth
        items: orderItems,
        total: totalPrice,
        date: DateTime.now(),
        status: 'pending',
        paymentMethod: checkoutProvider.selectedPaymentMethod ?? 'cash',
        shippingAddress: checkoutProvider.selectedAddress,
        notes: checkoutProvider.selectedShippingMethod ?? '',
      );

      // TODO: Save order to Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.orderPlacedSuccessfully)),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.errorPlacingOrder)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.checkout)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.shippingAddress,
                style: Theme.of(context).textTheme.titleLarge),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(checkoutProvider.selectedAddress ??
                    AppLocalizations.of(context)!.pleaseSelectAddress),
                subtitle: checkoutProvider.selectedAddress != null
                    ? Text(AppLocalizations.of(context)!.deliveryAddress)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (checkoutProvider.selectedAddress != null)
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/addresses'),
                        child: Text(AppLocalizations.of(context)!.change),
                      ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, '/addresses'),
              ),
            ),
            const Divider(),
            Text(AppLocalizations.of(context)!.shippingMethod,
                style: Theme.of(context).textTheme.titleLarge),
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text(checkoutProvider.selectedShippingMethod ??
                    AppLocalizations.of(context)!.pleaseSelectShippingMethod),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to shipping method selection
                  _showShippingMethodDialog(context);
                },
              ),
            ),
            const Divider(),
            Text(AppLocalizations.of(context)!.orderSummary,
                style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    child: ListTile(
                      leading: item.product.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.image!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            ),
                      title: Text(item.product.name),
                      subtitle: Text(
                          '${AppLocalizations.of(context)!.quantity}: ${item.quantity}'),
                      trailing: Text(
                          '${item.product.currency}${item.totalPrice.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.total,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(
                    '${cartItems.isNotEmpty ? cartItems.first.product.currency : ''}${totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.placeOrder),
            ),
          ],
        ),
      ),
    );
  }
}
