// lib/screens/search/advanced_search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../product/product_detail_screen.dart';
import '../../models/cart_item.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showFilters = false;

  final List<String> _categories = [
    'الكل',
    'الهواتف الذكية',
    'أجهزة الكمبيوتر',
    'الأجهزة اللوحية',
    'الساعات الذكية',
    'السماعات',
    'الملحقات',
  ];

  final List<String> _sortOptions = [
    'الأحدث',
    'السعر: من الأقل للأعلى',
    'السعر: من الأعلى للأقل',
    'التقييم',
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon:
                Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFiltersSection(),
          _buildSearchHistory(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'ابحث عن المنتجات...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        searchProvider.clearSearchResults();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.mic, color: Colors.grey),
                      onPressed: () {
                        // البحث الصوتي
                        searchProvider.startVoiceSearch();
                      },
                    ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty) {
                searchProvider.searchProducts(value);
              } else {
                searchProvider.clearSearchResults();
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                searchProvider.searchProducts(value);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildFiltersSection() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF2A2A2A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الفلاتر',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // فلتر الفئة
              _buildCategoryFilter(searchProvider),
              const SizedBox(height: 16),

              // فلتر السعر
              _buildPriceFilter(searchProvider),
              const SizedBox(height: 16),

              // فلتر التقييم
              _buildRatingFilter(searchProvider),
              const SizedBox(height: 16),

              // خيارات الترتيب
              _buildSortOptions(searchProvider),
              const SizedBox(height: 16),

              // أزرار الفلاتر
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        searchProvider.resetFilters();
                        if (_searchController.text.isNotEmpty) {
                          searchProvider.searchProducts(_searchController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('إعادة تعيين'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          searchProvider.searchProducts(_searchController.text);
                        }
                        setState(() {
                          _showFilters = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('تطبيق'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(SearchProvider searchProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الفئة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _categories.map((category) {
            final isSelected = searchProvider.selectedCategory == category;
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                searchProvider.searchWithFilters(
                  query: _searchController.text,
                  category: category,
                );
              },
              selectedColor: const Color(0xFFB71C1C),
              backgroundColor: Colors.grey[700],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceFilter(SearchProvider searchProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نطاق السعر (جنيه)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(searchProvider.minPrice, searchProvider.maxPrice),
          min: 0,
          max: 10000000,
          divisions: 100,
          activeColor: const Color(0xFFB71C1C),
          inactiveColor: Colors.grey[600],
          labels: RangeLabels(
            '${searchProvider.minPrice.toInt()}',
            '${searchProvider.maxPrice.toInt()}',
          ),
          onChanged: (values) {
            searchProvider.searchWithFilters(
              query: _searchController.text,
              minPrice: values.start,
              maxPrice: values.end,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${searchProvider.minPrice.toInt()} جنيه',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              '${searchProvider.maxPrice.toInt()} جنيه',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingFilter(SearchProvider searchProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التقييم الأدنى',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final rating = index + 1.0;
            final isSelected = searchProvider.minRating >= rating;
            return GestureDetector(
              onTap: () {
                searchProvider.searchWithFilters(
                  query: _searchController.text,
                  minRating: rating,
                );
              },
              child: Icon(
                Icons.star,
                color: isSelected ? Colors.amber : Colors.grey[600],
                size: 30,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSortOptions(SearchProvider searchProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ترتيب حسب',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: searchProvider.sortBy,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white),
          items: _sortOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              searchProvider.searchWithFilters(
                query: _searchController.text,
                sortBy: value,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchHistory() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.currentQuery.isNotEmpty ||
            searchProvider.searchHistory.isEmpty) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'عمليات البحث السابقة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      searchProvider.clearSearchHistory();
                    },
                    child: const Text(
                      'مسح الكل',
                      style: TextStyle(color: Color(0xFFB71C1C)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: searchProvider.searchHistory.map((query) {
                  return InputChip(
                    label: Text(query),
                    onPressed: () {
                      _searchController.text = query;
                      searchProvider.searchProducts(query);
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      searchProvider.removeFromSearchHistory(query);
                    },
                    backgroundColor: Colors.grey[700],
                    labelStyle: const TextStyle(color: Colors.white),
                    deleteIconColor: Colors.grey[400],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB71C1C),
            ),
          );
        }

        if (searchProvider.currentQuery.isEmpty) {
          return _buildEmptyState();
        }

        if (searchProvider.searchResults.isEmpty) {
          return _buildNoResults();
        }

        return _buildProductGrid(searchProvider.searchResults);
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'ابحث عن المنتجات',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'جرب كلمات بحث أخرى أو قم بتعديل الفلاتر',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(product) {
    return Card(
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج مع أيقونة المفضلة
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: product.image != null && product.image!.isNotEmpty
                          ? Image.network(
                              product.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                );
                              },
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                    ),
                  ),
                  // أيقونة المفضلة
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, child) {
                        final isInWishlist =
                            wishlistProvider.isInWishlist(product.id);
                        return GestureDetector(
                          onTap: () async {
                            try {
                              await wishlistProvider.toggleWishlist(product);
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
                                  ? const Color(0xFFB71C1C)
                                  : Colors.grey[600],
                              size: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // تفاصيل المنتج
            Expanded(
              flex: 2,
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
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
                              color: Colors.grey[400],
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    Text(
                      '${product.price.toStringAsFixed(0)} جنيه',
                      style: const TextStyle(
                        color: Color(0xFFB71C1C),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
}
