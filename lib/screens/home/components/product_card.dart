// lib/screens/home/components/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/providers/wishlist_provider.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:gizmo_store/utils/image_helper.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد حجم البطاقة بناءً على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth < 600 ? 120.0 : 180.0; // أصغر جداً للهاتف المحمول

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 8), // تقليل المسافة أكثر
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // تقليل الانحناء
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), // تقليل الظل
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج مع شارة الخصم
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    height: screenWidth < 600
                        ? 90
                        : 140, // أصغر جداً للهاتف المحمول
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: product.imageUrl != null &&
                            product.imageUrl!.isNotEmpty
                        ? ImageHelper.buildCachedImage(
                            imageUrl: product.imageUrl!,
                            width: double.infinity,
                            height: screenWidth < 600 ? 90 : 140,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          ),
                  ),
                ),
                if (product.discount != null && product.discount! > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product.discount}%-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // أيقونة المفضلة
                Positioned(
                  top: 8,
                  left: 8,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      final isInWishlist =
                          wishlistProvider.isInWishlist(product.id);
                      return GestureDetector(
                        onTap: () async {
                          try {
                            // التحقق من تسجيل الدخول أولاً
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                            .pleaseLoginFirst ??
                                        'يرجى تسجيل الدخول أولاً'),
                                    backgroundColor: Colors.orange,
                                    action: SnackBarAction(
                                      label: 'تسجيل الدخول',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/auth');
                                      },
                                    ),
                                  ),
                                );
                              }
                              return;
                            }

                            await wishlistProvider.toggleWishlist(product);

                            // إظهار رسالة نجاح
                            if (context.mounted) {
                              final isInWishlist =
                                  wishlistProvider.isInWishlist(product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isInWishlist
                                      ? 'تم إضافة ${product.name} للمفضلة'
                                      : 'تم إزالة ${product.name} من المفضلة'),
                                  backgroundColor:
                                      isInWishlist ? Colors.green : Colors.grey,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist
                                ? Color(0xFFB71C1C)
                                : Colors.grey[600],
                            size: screenWidth < 600
                                ? 16
                                : 18, // تصغير أيقونة القلب للهاتف
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // تفاصيل المنتج
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(
                    screenWidth < 600 ? 4 : 8), // تقليل المسافة أكثر للهاتف
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize:
                            screenWidth < 600 ? 12 : 14, // تصغير النص للهاتف
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                        height: screenWidth < 600 ? 2 : 6), // تقليل المسافة أكثر
                    // التقييم
                    if (product.rating != null)
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < product.rating!.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: screenWidth < 600
                                    ? 10
                                    : 12, // تصغير النجوم للهاتف
                              );
                            }),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewsCount ?? 0})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    // السعر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.originalPrice != null)
                          Text(
                            '${product.originalPrice!.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          '${product.price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                          style: TextStyle(
                            color: Color(0xFFB71C1C),
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth < 600
                                ? 14
                                : 16, // تصغير السعر للهاتف
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Location and date for this month
                        Text(
                          AppLocalizations.of(context)!.locationAndDate,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
