import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'checkout_screen.dart';
import '../constants/app_spacing.dart';
import '../constants/app_colors.dart';
import '../constants/app_animations.dart';
import '../constants/app_buttons.dart';
import '../constants/app_navigation.dart';
import '../constants/app_cards.dart';

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
      appBar: AppNavigation.buildSubPageAppBar(
        context: context,
        title: 'السلة (${widget.cartItems.length})',
        actions: [
          if (widget.cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                // مسح جميع العناصر
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('تأكيد المسح'),
                    content: const Text('هل تريد مسح جميع العناصر من السلة؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          // مسح جميع العناصر
                          Navigator.pop(context);
                        },
                        child: const Text('مسح'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: AppSpacing.screenPaddingHorizontal,
                    child: ListView.separated(
                      itemCount: widget.cartItems.length,
                      separatorBuilder: (context, index) => AppSpacing.verticalMD,
                      padding: AppSpacing.paddingMD,
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        return AppAnimations.fadeInUp(
                          delay: Duration(milliseconds: index * 100),
                          child: _buildCartItem(context, item, index),
                        );
                      },
                    ),
                  ),
                ),
                _buildCheckoutSection(context),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: AppAnimations.fadeInUp(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: AppSpacing.paddingXXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: AppSpacing.iconSizeXLarge * 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              AppSpacing.verticalXL,
              Text(
                AppLocalizations.of(context)!.cartEmpty,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalMD,
              Text(
                'أضف بعض المنتجات لتبدأ التسوق',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalXL,
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('تصفح المنتجات'),
                style: ElevatedButton.styleFrom(
                  padding: AppSpacing.buttonPaddingLarge,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.buttonBorderRadius,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, int index) {
    return CartItemCard(
      imageUrl: item.product.imageUrl ?? '',
      title: item.product.name,
      price: '${item.product.currency}${item.product.price.toStringAsFixed(2)}',
      quantity: item.quantity,
      totalPrice: '${item.product.currency}${item.totalPrice.toStringAsFixed(2)}',
      onIncrease: () {
        setState(() {
          item.quantity++;
        });
      },
      onDecrease: item.quantity > 1 ? () {
        setState(() {
          item.quantity--;
        });
      } : null,
      onRemove: () => _removeItem(index),
    );
  }

  Widget _buildCheckoutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: Column(
          children: [
            Container(
              padding: AppSpacing.cardPaddingAll,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.borderRadiusLG,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.total,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.cartItems.isNotEmpty ? widget.cartItems.first.product.currency : ''}${totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: AppSpacing.borderRadiusCircle,
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: AppSpacing.iconSizeLarge,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalLG,
            AppAnimations.scaleIn(
              child: AppButton(
                text: AppLocalizations.of(context)!.checkout,
                onPressed: widget.cartItems.isNotEmpty ? _checkout : null,
                icon: const Icon(Icons.payment_outlined),
                style: AppButtons.checkoutButton,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
