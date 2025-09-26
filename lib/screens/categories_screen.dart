import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/models/category.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/services/database_setup_service.dart';
import 'package:gizmo_store/screens/category_products_screen.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  Map<String, int> categoryProductCounts = {};
  bool _isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      // تحميل الفئات الافتراضية
      List<Category> loadedCategories = _getFallbackCategories();
      
      // عرض الفئات فوراً بدون انتظار عدد المنتجات
      setState(() {
        categories = loadedCategories;
        _isLoading = false;
      });
      
      // تحميل عدد المنتجات لكل فئة بشكل متوازي في الخلفية
      _loadProductCountsInBackground(loadedCategories);
      
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        categories = _getFallbackCategories();
        _isLoading = false;
        errorMessage = AppLocalizations.of(context)!.failedToLoadCategories;
      });
    }
  }

  Future<void> _loadProductCountsInBackground(List<Category> categories) async {
    try {
      // تحميل عدد المنتجات لكل فئة بشكل متوازي
      List<Future<MapEntry<String, int>>> futures = categories.map((category) async {
        try {
          List<Product> products = await DatabaseSetupService.getProductsByCategory(category.name);
          return MapEntry(category.name, products.length);
        } catch (e) {
          print('Error loading products for category ${category.name}: $e');
          return MapEntry(category.name, 0);
        }
      }).toList();

      // انتظار جميع العمليات المتوازية
      List<MapEntry<String, int>> results = await Future.wait(futures);
      
      // تحديث عدد المنتجات
      Map<String, int> productCounts = Map.fromEntries(results);
      
      if (mounted) {
        setState(() {
          categoryProductCounts = productCounts;
        });
      }
    } catch (e) {
      print('Error loading product counts: $e');
    }
  }

  List<Category> _getFallbackCategories() {
    final localizations = AppLocalizations.of(context)!;
    return [
      Category(
        id: 'smartphones',
        name: 'smartphones',
        displayName: localizations.categorySmartphones,
        imageUrl: 'https://cdn.pixabay.com/photo/2016/12/09/11/33/smartphone-1894723_960_720.jpg',
      ),
      Category(
        id: 'laptops',
        name: 'laptops',
        displayName: localizations.categoryLaptops,
        imageUrl: 'https://cdn.pixabay.com/photo/2015/09/09/16/05/forest-931706_960_720.jpg',
      ),
      Category(
        id: 'headphones',
        name: 'headphones',
        displayName: localizations.categoryHeadphones,
        imageUrl: 'https://cdn.pixabay.com/photo/2018/09/17/14/27/headphones-3683983_960_720.jpg',
      ),
      Category(
        id: 'smartwatches',
        name: 'smartwatches',
        displayName: localizations.categorySmartWatches,
        imageUrl: 'https://cdn.pixabay.com/photo/2015/12/09/17/12/smartwatch-1085307_960_720.jpg',
      ),
      Category(
        id: 'tablets',
        name: 'tablets',
        displayName: localizations.categoryTablets,
        imageUrl: 'https://cdn.pixabay.com/photo/2015/01/08/18/25/desk-593327_960_720.jpg',
      ),
      Category(
        id: 'accessories',
        name: 'accessories',
        displayName: localizations.categoryAccessories,
        imageUrl: 'https://cdn.pixabay.com/photo/2017/08/10/08/47/laptop-2619564_960_720.jpg',
      ),
      Category(
        id: 'cameras',
        name: 'cameras',
        displayName: localizations.categoryCameras,
        imageUrl: 'https://cdn.pixabay.com/photo/2016/04/04/14/12/camera-1307199_960_720.jpg',
      ),
      Category(
        id: 'tv',
        name: 'tv',
        displayName: localizations.categoryTv,
        imageUrl: 'https://cdn.pixabay.com/photo/2019/06/30/20/09/tv-4308538_960_720.jpg',
      ),
      Category(
        id: 'gaming',
        name: 'gaming',
        displayName: localizations.categoryGaming,
        imageUrl: 'https://cdn.pixabay.com/photo/2017/11/15/15/27/nintendo-2951227_960_720.jpg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.categoriesTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD32F2F),
            Color(0xFFB71C1C),
              ],
            ),
          ),
        ),
        elevation: 8,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadCategories,
              tooltip: AppLocalizations.of(context)!.refresh,
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFB71C1C),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.loadingCategories,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (categories.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.category_outlined,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.noCategoriesAvailable,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  AppLocalizations.of(context)!.retry,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCategories,
      color: Color(0xFFB71C1C),
      backgroundColor: Colors.white,
      child: Column(
        children: [
          if (errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.withOpacity(0.1), Colors.red.withOpacity(0.1)],
                ),
                border: Border.all(color: Colors.orange, width: 1.5),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // تحديد عدد الأعمدة بناءً على عرض الشاشة للفئات
                  int crossAxisCount;
                  double childAspectRatio;
                  double spacing;
                  
                  if (constraints.maxWidth > 1200) {
                    // شاشات كبيرة جداً (Desktop)
                    crossAxisCount = 4;
                    childAspectRatio = 1.0;
                    spacing = 24;
                  } else if (constraints.maxWidth > 800) {
                    // شاشات متوسطة (Tablet)
                    crossAxisCount = 3;
                    childAspectRatio = 0.95;
                    spacing = 20;
                  } else if (constraints.maxWidth > 600) {
                    // شاشات صغيرة (Large Phone)
                    crossAxisCount = 2;
                    childAspectRatio = 0.9;
                    spacing = 20;
                  } else {
                    // شاشات صغيرة جداً (Small Phone)
                    crossAxisCount = 2;
                    childAspectRatio = 0.85;
                    spacing = 16;
                  }
                  
                  return GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    itemBuilder: (ctx, i) => _buildCategoryCard(categories[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              category: category.name,
            ),
          ),
        );
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image section with gradient background
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD32F2F).withOpacity(0.8),
            Color(0xFFB71C1C).withOpacity(0.9),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: category.imageUrl,
                            fit: BoxFit.cover,
                            // تحسينات الأداء للفئات
                            memCacheWidth: 160,
                            memCacheHeight: 160,
                            maxWidthDiskCache: 320,
                            maxHeightDiskCache: 320,
                            fadeInDuration: const Duration(milliseconds: 250),
                            fadeOutDuration: const Duration(milliseconds: 150),
                            httpHeaders: const {
                              'Cache-Control': 'max-age=604800', // أسبوع للفئات
                              'Accept': 'image/webp,image/jpeg,image/png,*/*',
                            },
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'تحميل...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
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
                                    Colors.red.withOpacity(0.3),
                                    Colors.red.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                _getCategoryIcon(category.name),
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Decorative elements
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 15,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.displayName ?? category.name, // استخدام displayName إذا كان متوفراً
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    _buildProductCount(category.name),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 30,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
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

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'laptops':
        return Icons.laptop_mac;
      case 'smartphones':
        return Icons.smartphone;
      case 'headphones':
        return Icons.headphones;
      case 'smartwatches':
        return Icons.watch;
      case 'tablets':
        return Icons.tablet_mac;
      case 'accessories':
        return Icons.category;
      case 'cameras':
        return Icons.camera_alt;
      case 'tv':
        return Icons.tv;
      case 'gaming':
        return Icons.sports_esports;
      default:
        return Icons.category;
    }
  }

  Widget _buildProductCount(String categoryName) {
    final count = categoryProductCounts[categoryName];
    
    if (count == null) {
      // عرض مؤشر تحميل صغير أثناء تحميل عدد المنتجات
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
    
    return Text(
      '$count منتج',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
