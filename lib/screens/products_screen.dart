import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_spacing.dart';
import '../constants/app_colors.dart';
import '../constants/app_animations.dart';
import '../constants/app_buttons.dart';
import '../constants/app_navigation.dart';
import '../constants/app_cards.dart';

class ProductsScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? products;

  const ProductsScreen({super.key, this.products});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Map<String, dynamic>> _products = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    if (widget.products == null) {
      _loadProducts();
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadProducts();
      }
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // تحسين الاستعلام مع إضافة فهرسة مركبة
      Query query = FirebaseFirestore.instance
          .collection('products')
          .where('isActive', isEqualTo: true) // فقط المنتجات النشطة
          .orderBy('createdAt', descending: true)
          .limit(50); // عرض المزيد من المنتجات

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      // استخدام Source.serverAndCache لتحسين الأداء
      final QuerySnapshot snapshot = await query.get(
        const GetOptions(source: Source.serverAndCache),
      );

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          if (_lastDocument == null) {
            _products.clear();
          }
          
          // تحسين معالجة البيانات
          final newProducts = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'name': data['name'] ?? '',
              'price': data['price'] ?? 0,
              'imageUrl': data['imageUrl'] ?? '',
              'description': data['description'] ?? '',
              'category': data['category'] ?? '',
              'isActive': data['isActive'] ?? true,
              'createdAt': data['createdAt'],
              // إضافة فقط الحقول المطلوبة لتوفير الذاكرة
            };
          }).toList();
          
          _products.addAll(newProducts);
          _lastDocument = snapshot.docs.last;
          _hasMore = snapshot.docs.length == 15;
        });
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل المنتجات: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              textColor: AppColors.onError,
              onPressed: () => _loadProducts(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigation.buildSubPageAppBar(
        context: context,
        title: 'المنتجات',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // فتح فلتر المنتجات
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // If products list is provided, display it directly
    if (widget.products != null && widget.products!.isNotEmpty) {
      return Padding(
        padding: AppSpacing.screenPaddingHorizontal,
        child: ListView.separated(
          itemCount: widget.products!.length,
          separatorBuilder: (context, index) => AppSpacing.verticalMD,
          itemBuilder: (context, index) {
            final product = widget.products![index];
            return AppAnimations.fadeInUp(
              delay: Duration(milliseconds: index * 100),
              child: _buildProductCard(context, product),
            );
          },
        ),
      );
    }

    // Show loading indicator for first load
    if (_products.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show empty state if no products
    if (_products.isEmpty && !_isLoading) {
      return Container(
        padding: AppSpacing.paddingXL,
        margin: AppSpacing.paddingMD,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppSpacing.cardBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: AppSpacing.iconSizeXLarge,
                color: Theme.of(context).colorScheme.secondary,
              ),
              AppSpacing.verticalMD,
              Text(
                AppLocalizations.of(context)!.noProductsYet,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show products with pagination
    return Padding(
      padding: AppSpacing.screenPaddingHorizontal,
      child: ListView.separated(
        controller: _scrollController,
        // تحسينات الأداء للتمرير
        physics: const BouncingScrollPhysics(),
        cacheExtent: 500, // تخزين مؤقت للعناصر خارج الشاشة
        addAutomaticKeepAlives: false, // تحسين الذاكرة
        addRepaintBoundaries: true, // تحسين الرسم
        itemCount: _products.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => AppSpacing.verticalMD,
        itemBuilder: (context, index) {
          if (index == _products.length) {
            // Loading indicator at the bottom
            return Container(
              padding: AppSpacing.paddingMD,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تحميل المزيد...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = _products[index];
          return AppAnimations.fadeInUp(
            delay: Duration(milliseconds: (index % 10) * 50),
            child: _buildProductCard(context, product),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return AppCard(
      decoration: AppCards.productCard,
      padding: EdgeInsets.zero,
      onTap: () => _viewProductDetails(context, product),
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
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: product['imageUrl'] ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // تحسينات الأداء
                    memCacheWidth: 400, // تحديد عرض الذاكرة المؤقتة
                    memCacheHeight: 225, // تحديد ارتفاع الذاكرة المؤقتة (16:9)
                    maxWidthDiskCache: 800, // الحد الأقصى لعرض التخزين المؤقت
                    maxHeightDiskCache: 450, // الحد الأقصى لارتفاع التخزين المؤقت
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary.withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'جاري التحميل...',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariant.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: AppColors.onSurfaceVariant.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'فشل تحميل الصورة',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // تحسين الشبكة
                    httpHeaders: const {
                      'Cache-Control': 'max-age=86400', // تخزين مؤقت لمدة يوم
                    },
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
                    onPressed: () => _toggleWishlist(context, product),
                    icon: Icon(
                      Icons.favorite_border,
                      color: AppColors.onSurface,
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
          Padding(
            padding: AppSpacing.paddingMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? AppLocalizations.of(context)!.productWithoutName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalXS,
                if (product['description'] != null)
                  Text(
                    product['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                AppSpacing.verticalSM,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${product['price'] ?? AppLocalizations.of(context)!.notSpecified} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    AppButton(
                      text: AppLocalizations.of(context)!.addToCart,
                      style: AppButtons.cartButton,
                      onPressed: () => _addToCart(context, product),
                      icon: Icons.add_shopping_cart,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewProductDetails(BuildContext context, Map<String, dynamic> product) {
    // Navigate to product details
  }

  void _toggleWishlist(BuildContext context, Map<String, dynamic> product) {
    // Toggle wishlist functionality
  }

  void _addToCart(BuildContext context, Map<String, dynamic> product) {
    // Add to cart action
  }
}
