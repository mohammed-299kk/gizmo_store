// lib/screens/home/components/featured_products_section.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/screens/home/components/product_card.dart';
import 'package:gizmo_store/screens/product/product_detail_screen.dart';

class FeaturedProductsSection extends StatelessWidget {
  final List<Product> products;

  const FeaturedProductsSection({
    super.key,
    required this.products,
  });

  String _formatPrice(double price) {
    // إضافة فواصل الآلاف لتسهيل القراءة
    String priceStr = price.toStringAsFixed(0);
    String formattedInteger = '';
    for (int i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += priceStr[i];
    }
    return formattedInteger;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'المنتجات المميزة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: _buildCompactProductCard(context, products[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCompactProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
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
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: _buildImageWidget(product),
                  ),
                ),
                if (product.discount != null && product.discount! > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.discount}%-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // تفاصيل المنتج
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
                                size: 10,
                              );
                            }),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.reviewsCount ?? 0})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 8,
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
                            '${_formatPrice(product.originalPrice!)} ${AppLocalizations.of(context)!.currency}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 9,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          '${_formatPrice(product.price)} ${AppLocalizations.of(context)!.currency}',
                          style: const TextStyle(
                            color: Color(0xFFB71C1C),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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

  Widget _buildImageWidget(Product product) {
    final imageUrl = product.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty || !_isValidImageUrl(imageUrl)) {
      return _buildNoImagePlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      // تحسينات الأداء للمنتجات المميزة
      memCacheWidth: 250,
      memCacheHeight: 200,
      maxWidthDiskCache: 500,
      maxHeightDiskCache: 400,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      httpHeaders: const {
        'Cache-Control': 'max-age=86400',
        'Accept': 'image/webp,image/jpeg,image/png,*/*',
      },
      placeholder: (context, url) => _buildLoadingPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorPlaceholder(),
    );
  }

  bool _isValidImageUrl(String url) {
    if (!url.startsWith('http')) return false;
    return true;
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFB71C1C),
              strokeWidth: 2,
            ),
            SizedBox(height: 4),
            Text(
              'جاري التحميل...',
              style: TextStyle(
                color: Color(0xFFB71C1C),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.red.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: Colors.red.shade400,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              'خطأ في الصورة',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_android,
              color: Colors.grey,
              size: 30,
            ),
            SizedBox(height: 4),
            Text(
              'بدون صورة',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
