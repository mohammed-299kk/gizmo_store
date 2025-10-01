import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/cart_item.dart';
import '../../models/address.dart';
import '../../models/order.dart';
import '../../services/cart_service.dart';
import '../../services/firestore_service.dart';
import '../../l10n/app_localizations.dart';
import '../profile/address_management_screen.dart';
import '../payment/payment_simulation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Address? _selectedAddress;
  String _selectedPaymentMethod = 'cash';
  bool _isLoading = false;
  List<Address> _addresses = [];
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late Stream<List<Address>> _addressesStream;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    if (_currentUser == null) return;

    _addressesStream = _firestoreService.getUserAddresses(_currentUser!.uid);
    _addressesStream.listen((addresses) {
      if (mounted) {
        setState(() {
          _addresses = addresses;
          if (addresses.isNotEmpty && _selectedAddress == null) {
            _selectedAddress = addresses.firstWhere(
              (addr) => addr.isDefault,
              orElse: () => addresses.first,
            );
          }
        });
      }
    }).onError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorLoadingAddresses),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = CartService.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.checkout),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: 24),
                  _buildAddressSection(),
                  const SizedBox(height: 24),
                  _buildPaymentSection(),
                  const SizedBox(height: 32),
                  _buildPlaceOrderButton(totalPrice),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.orderSummary,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...widget.cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.product.name} x${item.quantity}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '${(item.product.price * item.quantity).toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.total,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${CartService.totalPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.deliveryAddress,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => _navigateToAddressManagement(),
                  child: Text(AppLocalizations.of(context)!.change),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedAddress != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedAddress!.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!.formattedAddress,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!.phone,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_off,
                      color: Theme.of(context).colorScheme.error,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.noAddressSelected,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _navigateToAddressManagement(),
                      child: Text(AppLocalizations.of(context)!.addAddress),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.paymentMethod,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.money, color: Colors.green[600]),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.cashOnDelivery),
                ],
              ),
              value: 'cash',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.credit_card, color: Color(0xFFB71C1C)),
                  const SizedBox(width: 8),
                  const Text('Visa Card'),
                ],
              ),
              subtitle: const Text(
                'مجرد محاكاة - لا يتم خصم أموال حقيقية',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: 'visa',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.credit_card, color: Color(0xFFB71C1C)),
                  const SizedBox(width: 8),
                  const Text('Mastercard'),
                ],
              ),
              subtitle: const Text(
                'مجرد محاكاة - لا يتم خصم أموال حقيقية',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              value: 'mastercard',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton(double totalPrice) {
    final canPlaceOrder = _selectedAddress != null && !_isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canPlaceOrder ? _placeOrder : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Text(
          '${AppLocalizations.of(context)!.placeOrder} (${totalPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAddressManagement() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressManagementScreen(),
      ),
    );

    if (result == true) {
      _loadAddresses();
    }
  }

  Future<void> _placeOrder() async {
    if (_currentUser == null || _selectedAddress == null) return;

    // التنقل إلى شاشة الدفع التجريبي
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSimulationScreen(
          totalAmount: CartService.totalPrice,
          shippingAddress: _selectedAddress?.formattedAddress,
          phoneNumber: _selectedAddress?.phone,
          cartItems: widget.cartItems,
        ),
      ),
    );
  }
}
