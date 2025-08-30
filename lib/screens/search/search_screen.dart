import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// استيراد الموديل (لو موجود في lib/models/product.dart)
import 'package:gizmo_store/models/product.dart';

// استيراد شاشة التفاصيل (لو موجودة في lib/screens/product_detail_screen.dart)
import 'package:gizmo_store/screens/product_detail_screen.dart';

// استيراد الشاشات الأخرى حسب الحاجة (تشيك لو فعلاً عندك هذه الملفات)
import 'package:gizmo_store/screens/order/orders_screen.dart';
import 'package:gizmo_store/screens/auth/auth_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

enum ViewMode { grid, list }

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  String _sortBy = 'الأحدث';
  double _minPrice = 0;
  double _maxPrice = 5000;
  String _selectedCategory = 'الكل';
  Timer? _debounceTimer;
  bool _isSearching = false;
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  ViewMode _viewMode = ViewMode.grid;
  bool _showAdvancedFilters = false;
  String _selectedBrand = 'الكل';

  // خيارات التصنيف والترتيب
  final List<String> _sortOptions = [
    'الأحدث',
    'السعر: من الأقل للأعلى',
    'السعر: من الأعلى للأقل',
    'الأعلى تقييماً',
  ];
  final List<String> _categories = [
    'الكل',
    'الهواتف الذكية',
    'أجهزة الكمبيوتر',
    'الأجهزة اللوحية',
    'الساعات الذكية',
    'السماعات',
    'الملحقات',
  ];

  final List<String> _brands = [
    'الكل',
    'Apple',
    'Samsung',
    'Sony',
    'Dell',
    'Huawei',
    'Xiaomi'
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = allProducts!;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _performSearch(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty) {
          _searchResults = allProducts!;
        } else {
          _searchResults = allProducts!
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()) ||
                    product.description
                        .toLowerCase()
                        .contains(query.toLowerCase()),
              )
              .toList();
        }
        _applyFilters();
        _isSearching = false;
      });
    });
  }

  void _applyFilters() {
    setState(() {
      _searchResults = _searchResults.where((product) {
        bool categoryMatch = _selectedCategory == 'الكل' ||
            product.category == _selectedCategory;
        bool priceMatch =
            product.price >= _minPrice && product.price <= _maxPrice;

        // فلترة حسب العلامة التجارية
        bool brandMatch =
            _selectedBrand == 'الكل' || product.name.contains(_selectedBrand);

        return categoryMatch && priceMatch && brandMatch;
      }).toList();

      // تطبيق الترتيب
      switch (_sortBy) {
        case 'السعر: من الأقل للأعلى':
          _searchResults.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'السعر: من الأعلى للأقل':
          _searchResults.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'الأعلى تقييماً':
          _searchResults.sort((a, b) => b.rating!.compareTo(a.rating as num));
          break;
      }
      _currentPage = 0; // إعادة الصفحة إلى الصفر عند تغيير الفلتر
    });
  }

  void _loadMore() {
    if ((_currentPage + 1) * _itemsPerPage < _searchResults.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  List<Product> get _currentPageResults {
    int end = (_currentPage + 1) * _itemsPerPage;
    if (end > _searchResults.length) {
      end = _searchResults.length;
    }
    return _searchResults.sublist(0, end);
  }

  List<Product>? get allProducts => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البحث')),
      body: Column(
        children: [
          // شريط البحث
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث عن المنتجات...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _performSearch,
            ),
          ),

          // الفلاتر الأساسية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'التصنيف',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category,
                            style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sortBy,
                    decoration: InputDecoration(
                      labelText: 'ترتيب حسب',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _sortOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child:
                            Text(option, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                      _applyFilters();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_showAdvancedFilters
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined),
                  onPressed: () {
                    setState(() {
                      _showAdvancedFilters = !_showAdvancedFilters;
                    });
                  },
                ),
              ],
            ),
          ),

          // الفلاتر المتقدمة
          if (_showAdvancedFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // فلترة السعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السعر: من \$${_minPrice.toStringAsFixed(0)} إلى \$${_maxPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    labels: RangeLabels(
                      '\$${_minPrice.toStringAsFixed(0)}',
                      '\$${_maxPrice.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                    onChangeEnd: (values) {
                      _applyFilters();
                    },
                  ),

                  // فلترة العلامة التجارية
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBrand,
                    decoration: InputDecoration(
                      labelText: 'العلامة التجارية',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _brands.map((brand) {
                      return DropdownMenuItem(
                        value: brand,
                        child:
                            Text(brand, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBrand = value!;
                      });
                      _applyFilters();
                    },
                  ),
                ],
              ),
            ),

          // خيارات العرض
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ToggleButtons(
                  isSelected: [
                    _viewMode == ViewMode.grid,
                    _viewMode == ViewMode.list,
                  ],
                  onPressed: (index) {
                    setState(() {
                      _viewMode = index == 0 ? ViewMode.grid : ViewMode.list;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                  children: const [
                    Icon(Icons.grid_view),
                    Icon(Icons.list),
                  ],
                ),
              ],
            ),
          ),

          // نتائج البحث
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _currentPageResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'لا توجد نتائج',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchResults = allProducts!;
                                  _applyFilters();
                                });
                              },
                              child: const Text('إعادة تعيين الفلاتر'),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: _viewMode == ViewMode.grid
                                ? GridView.builder(
                                    padding: const EdgeInsets.all(16),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.7,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: _currentPageResults.length,
                                    itemBuilder: (context, index) {
                                      final product =
                                          _currentPageResults[index];
                                      return _buildProductItem(product);
                                    },
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _currentPageResults.length,
                                    itemBuilder: (context, index) {
                                      final product =
                                          _currentPageResults[index];
                                      return _buildProductListItem(product);
                                    },
                                  ),
                          ),
                          if (_currentPageResults.length <
                              _searchResults.length)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                onPressed: _loadMore,
                                child: const Text('عرض المزيد'),
                              ),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              cart: const [],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.image!,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: double.infinity,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      Text(
                        ' ${product.rating}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                      if (product.discount! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
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
  }

  Widget _buildProductListItem(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              cart: const [],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.image!,
                width: 100,
                height: 100,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        Text(
                          ' ${product.rating}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB71C1C),
                          ),
                        ),
                        if (product.discount! > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
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
            ),
          ],
        ),
      ),
    );
  }
}
