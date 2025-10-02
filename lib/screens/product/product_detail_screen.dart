// lib/screens/product_detail/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/models/cart_item.dart';
import 'package:gizmo_store/screens/cart/cart_screen.dart';
import 'package:gizmo_store/services/cart_service.dart';
import 'package:gizmo_store/services/firestore_service.dart';
import 'package:gizmo_store/providers/wishlist_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  double? _userRating; // تقييم المستخدم الحالي
  bool _isLoadingRating = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  // تحميل تقييم المستخدم الحالي
  Future<void> _loadUserRating() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final rating = await _firestoreService.getUserRating(
        productId: widget.product.id,
        userId: user.uid,
      );
      if (mounted) {
        setState(() {
          _userRating = rating;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.productDetails,
            style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProduct,
          ),
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isInWishlist =
                  wishlistProvider.isInWishlist(widget.product.id);
              return IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorites(wishlistProvider),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(),
            _buildProductHeader(),
            _buildRatingSection(),
            _buildDescriptionSection(),
            _buildSpecificationsSection(),
            _buildReviewsSection(),
            _buildQuantitySelector(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // معرض صور المنتج
  Widget _buildImageGallery() {
    // استخدام imageUrl بدلاً من images للحصول على صورة صحيحة
    final imageUrl = widget.product.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.image_not_supported,
          size: 80,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          // تحسينات الأداء لصور تفاصيل المنتج
          memCacheWidth: 800, // حجم أكبر لصور التفاصيل
          memCacheHeight: 800,
          maxWidthDiskCache: 1200,
          maxHeightDiskCache: 1200,
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 150),
          httpHeaders: const {
            'Cache-Control': 'max-age=86400',
            'Accept': 'image/webp,image/jpeg,image/png,*/*',
          },
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تحميل الصورة...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade100,
                  Colors.red.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'فشل في تحميل الصورة',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // معلومات المنتج الأساسية
  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineSmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${_formatPrice(widget.product.price)} ج.س',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (widget.product.originalPrice != null) ...[
                const SizedBox(width: 12),
                Text(
                  '${_formatPrice(widget.product.originalPrice!)} ج.س',
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              ],
              if ((widget.product.discount ?? 0) > 0) ...[
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${AppLocalizations.of(context)!.discount} ${widget.product.discount}%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // عرض كمية المخزون
          _buildStockInfo(),
        ],
      ),
    );
  }

  // عرض معلومات المخزون
  Widget _buildStockInfo() {
    final stock = widget.product.stock ?? 0;
    final isAvailable = widget.product.isAvailable ?? false;

    Color stockColor;
    String stockText;
    IconData stockIcon;

    if (!isAvailable || stock <= 0) {
      stockColor = Colors.red;
      stockText = 'غير متوفر في المخزون';
      stockIcon = Icons.cancel;
    } else if (stock < 5) {
      stockColor = Colors.orange;
      stockText = 'متبقي $stock قطع فقط - اطلب الآن!';
      stockIcon = Icons.warning_amber;
    } else if (stock < 10) {
      stockColor = Colors.blue;
      stockText = 'متوفر في المخزون: $stock قطعة';
      stockIcon = Icons.inventory_2;
    } else {
      stockColor = Colors.green;
      stockText = 'متوفر في المخزون: $stock قطعة';
      stockIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: stockColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: stockColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stockIcon,
            color: stockColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            stockText,
            style: TextStyle(
              color: stockColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // قسم التقييم
  Widget _buildRatingSection() {
    final rating = widget.product.rating ?? 0;
    final reviewsCount = widget.product.reviewsCount ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض متوسط التقييم
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.floor() ? Icons.star : Icons.star_border,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '$rating ($reviewsCount ${AppLocalizations.of(context)!.reviews})',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // قسم تقييم المستخدم
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userRating == null ? 'قيّم هذا المنتج' : 'تقييمك',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                const SizedBox(height: 12),
                // نجوم التقييم التفاعلية
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1.0;
                    final isSelected =
                        _userRating != null && starValue <= _userRating!;

                    return GestureDetector(
                      onTap: _isLoadingRating
                          ? null
                          : () => _submitRating(starValue),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          isSelected ? Icons.star : Icons.star_border,
                          color: isSelected
                              ? Colors.amber
                              : Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withValues(alpha: 0.3),
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
                if (_isLoadingRating) ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ],
                if (_userRating != null && !_isLoadingRating) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'شكراً لتقييمك! (${_userRating!.toStringAsFixed(0)} نجوم)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // إرسال التقييم
  Future<void> _submitRating(double rating) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تسجيل الدخول لتقييم المنتج'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoadingRating = true;
    });

    try {
      final newAverageRating = await _firestoreService.addOrUpdateRating(
        productId: widget.product.id,
        userId: user.uid,
        rating: rating,
      );

      if (mounted) {
        setState(() {
          _userRating = rating;
          _isLoadingRating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _userRating == rating
                  ? 'تم تحديث تقييمك بنجاح!'
                  : 'شكراً لتقييمك!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // قسم الوصف
  Widget _buildDescriptionSection() {
    final description = widget.product.description ??
        AppLocalizations.of(context)!.noProductDescription;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.description,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          const SizedBox(height: 8),
          Text(description,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5)),
        ],
      ),
    );
  }

  // قسم المواصفات
  Widget _buildSpecificationsSection() {
    List<String> specs = widget.product.specifications ?? [];

    // إذا لم تكن هناك مواصفات، نضع مواصفات افتراضية
    if (specs.isEmpty) {
      final productName = widget.product.name.toLowerCase();

      if (productName.contains('phone') ||
          productName.contains('mobile') ||
          productName.contains('iphone') ||
          productName.contains('samsung')) {
        specs = [
          'شاشة عالية الدقة',
          'معالج قوي ومتطور',
          'كاميرا عالية الجودة',
          'بطارية طويلة المدى',
          'نظام تشغيل حديث',
          'ذاكرة تخزين كبيرة',
          'تصميم أنيق ومتين',
          'اتصال 5G/4G',
        ];
      } else if (productName.contains('laptop') ||
          productName.contains('macbook') ||
          productName.contains('computer')) {
        specs = [
          'معالج عالي الأداء',
          'ذاكرة عشوائية كبيرة',
          'ذاكرة تخزين SSD سريعة',
          'شاشة عالية الدقة',
          'بطارية طويلة المدى',
          'تصميم نحيف وخفيف',
          'منافذ متعددة',
          'نظام تشغيل حديث',
        ];
      } else if (productName.contains('headphone') ||
          productName.contains('earphone') ||
          productName.contains('airpods') ||
          productName.contains('sony')) {
        specs = [
          'جودة صوت عالية',
          'تصميم مريح',
          'بطارية طويلة المدى',
          'اتصال لاسلكي',
          'ميكروفون مدمج',
          'تحكم باللمس',
          'مقاومة للماء',
          'إلغاء الضوضاء',
        ];
      } else if (productName.contains('watch') ||
          productName.contains('ساعة')) {
        specs = [
          'شاشة عالية الدقة',
          'مراقبة اللياقة البدنية',
          'مقاومة للماء',
          'بطارية طويلة المدى',
          'اتصال لاسلكي',
          'تطبيقات متنوعة',
          'تصميم أنيق',
          'سهولة الاستخدام',
        ];
      } else if (productName.contains('ipad') ||
          productName.contains('tablet')) {
        specs = [
          'شاشة كبيرة عالية الدقة',
          'معالج قوي',
          'كاميرا عالية الجودة',
          'بطارية طويلة المدى',
          'دعم القلم الرقمي',
          'تصميم نحيف وخفيف',
          'نظام تشغيل متطور',
          'ذاكرة تخزين كبيرة',
        ];
      } else {
        specs = [
          'جودة عالية في التصنيع',
          'تصميم عصري وأنيق',
          'سهولة في الاستخدام',
          'ضمان الشركة المصنعة',
          'متوافق مع المعايير العالمية',
          'أداء موثوق ومستقر',
        ];
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.specifications,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color)),
          const SizedBox(height: 8),
          ...specs.map((spec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle)),
                    Expanded(
                        child: Text(spec,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // قسم المراجعات
  Widget _buildReviewsSection() {
    final reviews = widget.product.reviews ?? [];
    if (reviews.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.reviewsSection,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color)),
          const SizedBox(height: 12),
          ...reviews.take(3).map((review) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(review['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const Spacer(),
                        Row(
                          children: List.generate(
                              5,
                              (index) => Icon(
                                  index < review['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(review['comment'],
                        style: TextStyle(
                            fontSize: 13,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color)),
                  ],
                ),
              )),
          if (reviews.length > 3)
            TextButton(
                onPressed: _viewAllReviews,
                child: Text(AppLocalizations.of(context)!.viewAllReviews)),
        ],
      ),
    );
  }

  // اختيار الكمية
  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(AppLocalizations.of(context)!.quantity,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$_quantity',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // شريط الإجراءات السفلي
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 5)
          ]),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.addToCart,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen())),
              icon: Icon(Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart() {
    CartService.addItem(CartItem(product: widget.product, quantity: _quantity));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${widget.product.name} ${AppLocalizations.of(context)!.addedToCart}'),
        backgroundColor: Color(0xFFB71C1C),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareProduct() {
    // تنفيذ مشاركة المنتج
  }

  Future<void> _toggleFavorites(WishlistProvider wishlistProvider) async {
    try {
      // التحقق من تسجيل الدخول
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.pleaseLoginFirst ??
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

      // تبديل حالة المفضلة
      if (wishlistProvider.isInWishlist(widget.product.id)) {
        await wishlistProvider.removeFromWishlist(widget.product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${AppLocalizations.of(context)!.removedFromWishlist} ${widget.product.name} ${AppLocalizations.of(context)!.fromWishlist}'),
              backgroundColor: Colors.grey,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await wishlistProvider.addToWishlist(widget.product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${AppLocalizations.of(context)!.addedToWishlist} ${widget.product.name} ${AppLocalizations.of(context)!.toWishlist}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _viewAllReviews() {
    // تنفيذ عرض جميع المراجعات
  }

  String _formatPrice(double price) {
    // إضافة فواصل الآلاف
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
}
