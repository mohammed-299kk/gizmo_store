import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// استيراد الموديل
import 'package:gizmo_store/models/product.dart';

// استيراد شاشة التفاصيل
import 'package:gizmo_store/screens/product/product_detail_screen.dart';

// استيراد خدمة Firestore
import 'package:gizmo_store/services/firestore_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum ViewMode { grid, list }

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  String _sortBy = '';
  double _minPrice = 0;
  double _maxPrice = 5000;
  String _selectedCategory = '';
  Timer? _debounceTimer;
  bool _isSearching = false;
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  ViewMode _viewMode = ViewMode.grid;
  bool _showAdvancedFilters = false;
  String _selectedBrand = '';
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;
  final FocusNode _searchFocusNode = FocusNode();

  // خيارات التصنيف والترتيب
  List<String> get _sortOptions => [
        AppLocalizations.of(context)!.newest,
        AppLocalizations.of(context)!.priceLowToHigh,
        AppLocalizations.of(context)!.priceHighToLow,
        AppLocalizations.of(context)!.topRated,
      ];
  List<String> get _categories => [
        AppLocalizations.of(context)!.all,
        AppLocalizations.of(context)!.smartphones,
        AppLocalizations.of(context)!.computers,
        AppLocalizations.of(context)!.tablets,
        AppLocalizations.of(context)!.smartwatches,
        AppLocalizations.of(context)!.headphones,
        AppLocalizations.of(context)!.accessories,
      ];

  List<String> get _brands => [
        AppLocalizations.of(context)!.all,
        'Apple',
        'Samsung',
        'Sony',
        'Dell',
        'Huawei',
        'Xiaomi'
      ];

  String _formatPrice(double price) {
    String priceStr = price.toStringAsFixed(2);
    List<String> parts = priceStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Add thousand separators
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }

    return '$formattedInteger.$decimalPart';
  }

  @override
  void initState() {
    super.initState();
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_searchController.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize localized strings after context is available
    if (_sortBy.isEmpty) {
      _sortBy = AppLocalizations.of(context)!.newest;
    }
    if (_selectedCategory.isEmpty) {
      _selectedCategory = AppLocalizations.of(context)!.all;
    }
    if (_selectedBrand.isEmpty) {
      _selectedBrand = AppLocalizations.of(context)!.all;
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isSearching = true;
    });

    try {
      // Use FirestoreService to load all products
      final List<Product> products = await FirestoreService().getAllProducts();

      if (mounted) {
        setState(() {
          _searchResults = products;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Error loading products: $e');
      // Handle error gracefully
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر تحميل المنتجات من الخادم'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _filterAnimationController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        List<Product> results;

        if (query.isEmpty) {
          // Use FirestoreService to get all products
          results = await FirestoreService().getAllProducts();
        } else {
          // Use improved search from FirestoreService
          results = await FirestoreService().searchProducts(query.trim());
        }

        if (mounted) {
          setState(() {
            _searchResults = results;
            _applyFilters();
            _isSearching = false;
          });
        }
      } catch (e) {
        print('Search error: $e');
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });

          // Show error message to user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ أثناء البحث، يتم عرض منتجات تجريبية'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void _applyFilters() {
    setState(() {
      _searchResults = _searchResults.where((product) {
        bool categoryMatch =
            _selectedCategory == AppLocalizations.of(context)!.all ||
                product.category == _selectedCategory;
        bool priceMatch =
            product.price >= _minPrice && product.price <= _maxPrice;

        // فلترة حسب العلامة التجارية
        bool brandMatch = _selectedBrand == AppLocalizations.of(context)!.all ||
            product.name.contains(_selectedBrand);

        return categoryMatch && priceMatch && brandMatch;
      }).toList();

      // تطبيق الترتيب
      if (_sortBy == AppLocalizations.of(context)!.priceLowToHigh) {
        _searchResults.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == AppLocalizations.of(context)!.priceHighToLow) {
        _searchResults.sort((a, b) => b.price.compareTo(a.price));
      } else if (_sortBy == AppLocalizations.of(context)!.topRated) {
        _searchResults.sort((a, b) => b.rating.compareTo(a.rating));
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

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.red.shade600 : Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.red.shade600 : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String?>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String?>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ترتيب حسب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ..._sortOptions.map((option) => ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                      _applyFilters();
                      Navigator.pop(context);
                    },
                    activeColor: Colors.red.shade600,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.search,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.shade600,
                Colors.red.shade700,
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Enhanced Search Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.shade600,
                  Colors.red.shade700,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade300.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                children: [
                  // Search bar with enhanced design
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.searchForProducts,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.red.shade600,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.red.shade300,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onSubmitted: (_) =>
                          _performSearch(_searchController.text),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quick action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.tune,
                        label: 'فلاتر',
                        onTap: () {
                          setState(() {
                            _showAdvancedFilters = !_showAdvancedFilters;
                            if (_showAdvancedFilters) {
                              _filterAnimationController.forward();
                            } else {
                              _filterAnimationController.reverse();
                            }
                          });
                        },
                        isActive: _showAdvancedFilters,
                      ),
                      _buildQuickActionButton(
                        icon: _viewMode == ViewMode.grid
                            ? Icons.view_list
                            : Icons.grid_view,
                        label: _viewMode == ViewMode.grid ? 'قائمة' : 'شبكة',
                        onTap: () {
                          setState(() {
                            _viewMode = _viewMode == ViewMode.grid
                                ? ViewMode.list
                                : ViewMode.grid;
                          });
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.sort,
                        label: 'ترتيب',
                        onTap: _showSortOptions,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Enhanced Advanced filters with animation
          SizeTransition(
            sizeFactor: _filterAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tune,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'فلاتر متقدمة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'نطاق السعر',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.red.shade400,
                        inactiveTrackColor: Colors.red.shade100,
                        thumbColor: Colors.red.shade600,
                        overlayColor: Colors.red.shade100,
                        valueIndicatorColor: Colors.red.shade600,
                      ),
                      child: RangeSlider(
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
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            label: AppLocalizations.of(context)!.category,
                            value: _selectedCategory,
                            items: _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFilterDropdown(
                            label: AppLocalizations.of(context)!.brand,
                            value: _selectedBrand,
                            items: _brands.map((brand) {
                              return DropdownMenuItem(
                                value: brand,
                                child: Text(brand),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBrand = value!;
                              });
                              _applyFilters();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory =
                                  AppLocalizations.of(context)!.all;
                              _selectedBrand =
                                  AppLocalizations.of(context)!.all;
                              _minPrice = 0;
                              _maxPrice = 5000;
                            });
                            _applyFilters();
                          },
                          child: Text(
                            'إعادة تعيين',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showAdvancedFilters = false;
                              _filterAnimationController.reverse();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('تطبيق'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showAdvancedFilters) const SizedBox(height: 16),

          // Enhanced Results Section
          Expanded(
            child: _isSearching
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.red.shade600,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'جاري البحث...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : _currentPageResults.isEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                AppLocalizations.of(context)!.noResults,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'جرب تعديل كلمات البحث أو الفلاتر',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _selectedCategory =
                                        AppLocalizations.of(context)!.all;
                                    _selectedBrand =
                                        AppLocalizations.of(context)!.all;
                                    _minPrice = 0;
                                    _maxPrice = 5000;
                                  });
                                  _loadProducts();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'إعادة تعيين البحث',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Results header
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'النتائج (${_searchResults.length})',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.red.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _viewMode == ViewMode.grid
                                              ? Icons.grid_view
                                              : Icons.view_list,
                                          size: 16,
                                          color: Colors.red.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _viewMode == ViewMode.grid
                                              ? 'شبكة'
                                              : 'قائمة',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Products grid/list
                            Expanded(
                              child: _viewMode == ViewMode.grid
                                  ? LayoutBuilder(
                                      builder: (context, constraints) {
                                        // تحديد عدد الأعمدة بناءً على عرض الشاشة للبحث
                                        int crossAxisCount;
                                        double childAspectRatio;
                                        double spacing;

                                        if (constraints.maxWidth > 1200) {
                                          // شاشات كبيرة جداً (Desktop)
                                          crossAxisCount = 4;
                                          childAspectRatio = 0.8;
                                          spacing = 16;
                                        } else if (constraints.maxWidth > 800) {
                                          // شاشات متوسطة (Tablet)
                                          crossAxisCount = 3;
                                          childAspectRatio = 0.75;
                                          spacing = 14;
                                        } else if (constraints.maxWidth > 600) {
                                          // شاشات صغيرة (Large Phone)
                                          crossAxisCount = 2;
                                          childAspectRatio = 0.75;
                                          spacing = 12;
                                        } else {
                                          // شاشات صغيرة جداً (Small Phone)
                                          crossAxisCount = 2;
                                          childAspectRatio = 0.7;
                                          spacing = 10;
                                        }

                                        return GridView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            childAspectRatio: childAspectRatio,
                                            crossAxisSpacing: spacing,
                                            mainAxisSpacing: spacing,
                                          ),
                                          itemCount: _currentPageResults.length,
                                          itemBuilder: (context, index) {
                                            final product =
                                                _currentPageResults[index];
                                            return _buildProductItem(product);
                                          },
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      itemCount: _currentPageResults.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            _currentPageResults[index];
                                        return _buildProductListItem(product);
                                      },
                                    ),
                            ),
                            // Load more button
                            if (_currentPageResults.length <
                                _searchResults.length)
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: ElevatedButton(
                                  onPressed: _loadMore,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red.shade600,
                                    side: BorderSide(
                                      color: Colors.red.shade300,
                                      width: 1,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.expand_more,
                                        color: Colors.red.shade600,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(context)!.loadMore,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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

  Widget _buildProductItem(Product product) {
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade100,
                      Colors.white,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        // تحسينات الأداء للبحث
                        memCacheWidth: 300,
                        memCacheHeight: 250,
                        maxWidthDiskCache: 600,
                        maxHeightDiskCache: 500,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        httpHeaders: const {
                          'Cache-Control': 'max-age=86400',
                          'Accept': 'image/webp,image/jpeg,image/png,*/*',
                        },
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade100,
                                Colors.grey.shade50,
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
                                  color: Color(0xFFB71C1C),
                                  strokeWidth: 2,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'تحميل...',
                                  style: TextStyle(
                                    color: Color(0xFFB71C1C),
                                    fontSize: 10,
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
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 40,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'فشل التحميل',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.discount > 0)
                                Text(
                                  '\$${_formatPrice(product.price * (1 + product.discount / 100))}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                '\$${_formatPrice(product.price)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _addToCart(product),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD32F2F),
                                  Color(0xFFB71C1C),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFD32F2F).withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
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

  Widget _buildProductListItem(Product product) {
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    // تحسينات الأداء للقائمة
                    memCacheWidth: 240, // ضعف الحجم للشاشات عالية الدقة
                    memCacheHeight: 240,
                    maxWidthDiskCache: 480,
                    maxHeightDiskCache: 480,
                    fadeInDuration: const Duration(milliseconds: 150),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    httpHeaders: const {
                      'Cache-Control': 'max-age=86400',
                      'Accept': 'image/webp,image/jpeg,image/png,*/*',
                    },
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade100,
                            Colors.grey.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFD32F2F)),
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'تحميل...',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
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
                            Colors.red.shade100,
                            Colors.red.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'فشل التحميل',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (product.discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFD32F2F),
                            Color(0xFFB71C1C),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${product.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFD32F2F).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFD32F2F),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${product.rating}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFD32F2F),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.discount > 0)
                                Text(
                                  '\$${_formatPrice(product.price * (1 + product.discount / 100))}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                '\$${_formatPrice(product.price)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _addToCart(product),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD32F2F),
                                  Color(0xFFB71C1C),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFD32F2F).withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 18,
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

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${product.name} إلى السلة'),
        backgroundColor: const Color(0xFFB71C1C),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
