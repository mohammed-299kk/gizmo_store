import 'package:flutter/material.dart';
import 'app_spacing.dart';
import 'app_colors.dart';
import '../utils/image_helper.dart';

/// نظام البطاقات الموحد للتطبيق
class AppCards {
  AppCards._();

  // تصميم البطاقة الأساسية
  static BoxDecoration get basicCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMD,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // بطاقة مرتفعة
  static BoxDecoration get elevatedCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      );

  // بطاقة منتج
  static BoxDecoration get productCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: AppColors.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      );

  // بطاقة طلب
  static BoxDecoration get orderCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: AppColors.outline.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // بطاقة عنصر السلة
  static BoxDecoration get cartItemCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: AppColors.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      );

  // بطاقة إشعار
  static BoxDecoration get notificationCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusSM,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // بطاقة خطأ
  static BoxDecoration get errorCard => BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // بطاقة نجاح
  static BoxDecoration get successCard => BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // بطاقة تحذير
  static BoxDecoration get warningCard => BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // بطاقة مع تدرج
  static BoxDecoration gradientCard({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      BoxDecoration(
        borderRadius: AppSpacing.borderRadiusLG,
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // بطاقة شفافة
  static BoxDecoration get glassmorphismCard => BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
}

/// ويدجت بطاقة مخصصة
class AppCard extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isInteractive;

  const AppCard({
    super.key,
    required this.child,
    this.decoration,
    this.padding,
    this.margin,
    this.onTap,
    this.width,
    this.height,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.paddingMD,
      margin: margin,
      decoration: decoration ?? AppCards.basicCard,
      child: child,
    );

    if (onTap != null || isInteractive) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: (decoration?.borderRadius as BorderRadius?) ??
              AppSpacing.borderRadiusMD,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// بطاقة منتج مخصصة
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? originalPrice;
  final double? rating;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onAddToWishlist;
  final bool isInWishlist;
  final String? discount;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    this.rating,
    this.onTap,
    this.onAddToCart,
    this.onAddToWishlist,
    this.isInWishlist = false,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      decoration: AppCards.productCard,
      padding: EdgeInsets.zero,
      onTap: onTap,
      isInteractive: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ImageHelper.buildCachedImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // شارة الخصم
              if (discount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    child: Text(
                      discount!,
                      style: TextStyle(
                        color: AppColors.onError,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // زر المفضلة
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: onAddToWishlist,
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist ? AppColors.error : AppColors.onSurface,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          // معلومات المنتج
          Expanded(
            child: Padding(
              padding: AppSpacing.paddingMD,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.verticalXS,
                  // التقييم
                  if (rating != null)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        AppSpacing.horizontalXS,
                        Text(
                          rating!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  const Spacer(),
                  // السعر
                  Row(
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (originalPrice != null) ...[
                        AppSpacing.horizontalXS,
                        Text(
                          originalPrice!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                  AppSpacing.verticalSM,
                  // زر إضافة للسلة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('إضافة للسلة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppSpacing.borderRadiusSM,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة عنصر السلة
class CartItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? totalPrice;
  final int quantity;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.totalPrice,
    required this.quantity,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      decoration: AppCards.cartItemCard,
      child: Row(
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusSM,
            child: SizedBox(
              width: 80,
              height: 80,
              child: ImageHelper.buildCachedImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.horizontalMD,
          // معلومات المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalXS,
                Text(
                  price,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                AppSpacing.verticalSM,
                // أزرار الكمية
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceVariant,
                        foregroundColor: AppColors.onSurfaceVariant,
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                    Padding(
                      padding: AppSpacing.paddingMD,
                      child: Text(
                        quantity.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrease,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // زر الحذف
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.errorContainer,
              foregroundColor: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}