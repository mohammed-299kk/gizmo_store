import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/services/database_setup_service.dart';
import 'package:gizmo_store/screens/product/product_detail_screen.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> categoryProducts = [];
  bool _isLoading = true;
  String? errorMessage;

  // دالة مساعدة لتحديد نوع الصورة وعرضها بشكل صحيح
  Widget _buildImageWidget(String? imagePath,
      {double? width, double? height, BoxFit? fit}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // إذا كانت الصورة تبدأ بـ http أو https فهي من الإنترنت
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else {
      // إذا لم تبدأ بـ http فهي صورة محلية
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      List<Product> products = await DatabaseSetupService.getProductsByCategory(widget.category);
      
      print('Loaded ${products.length} products for category: ${widget.category}');

      setState(() {
        categoryProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
        errorMessage = AppLocalizations.of(context)!.failedToLoadProducts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)!.categoryProducts} ${widget.category}'),
        backgroundColor: Color(0xFFB71C1C), // Changed from Color(0xFFB71C1C) to orange
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryProducts.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.noProductsInCategory,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // تحديد عدد الأعمدة بناءً على عرض الشاشة لمنتجات الفئة
                    int crossAxisCount;
                    double childAspectRatio;
                    double spacing;
                    
                    if (constraints.maxWidth > 1200) {
                      // شاشات كبيرة جداً (Desktop)
                      crossAxisCount = 4;
                      childAspectRatio = 0.8;
                      spacing = 12;
                    } else if (constraints.maxWidth > 800) {
                      // شاشات متوسطة (Tablet)
                      crossAxisCount = 3;
                      childAspectRatio = 0.75;
                      spacing = 10;
                    } else if (constraints.maxWidth > 600) {
                      // شاشات صغيرة (Large Phone)
                      crossAxisCount = 2;
                      childAspectRatio = 0.75;
                      spacing = 8;
                    } else {
                      // شاشات صغيرة جداً (Small Phone)
                      crossAxisCount = 2;
                      childAspectRatio = 0.7;
                      spacing = 6;
                    }
                    
                    return GridView.builder(
                      padding: EdgeInsets.all(constraints.maxWidth > 600 ? 16 : 12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: categoryProducts.length,
                      itemBuilder: (context, index) {
                    final product = categoryProducts[index];
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
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: _buildImageWidget(
                                  product.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text('${product.rating}'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${product.price.toStringAsFixed(0)} ج.س',
                                        style: const TextStyle(
                                          color: Color(0xFFB71C1C),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (product.discount != null && product.discount! > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${product.discount}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                  },
                ),
    );
  }
}
