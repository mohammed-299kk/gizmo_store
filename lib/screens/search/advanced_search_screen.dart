// lib/screens/search/advanced_search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../../providers/search_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../product/product_detail_screen.dart';
import '../../models/cart_item.dart';
import '../../utils/image_helper.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showFilters = false;

  List<String> get _categories => [
        AppLocalizations.of(context)!.all,
        AppLocalizations.of(context)!.smartphones,
        AppLocalizations.of(context)!.computers,
        AppLocalizations.of(context)!.tablets,
        AppLocalizations.of(context)!.smartwatches,
        AppLocalizations.of(context)!.headphones,
        AppLocalizations.of(context)!.accessories,
      ];

  List<String> get _sortOptions => [
        AppLocalizations.of(context)!.newest,
        AppLocalizations.of(context)!.priceLowToHigh,
        AppLocalizations.of(context)!.priceHighToLow,
        AppLocalizations.of(context)!.topRated,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
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
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchForProducts,
              prefixIcon: Icon(Icons.search,
                  color: Theme.of(context)
                      .iconTheme
                      .color
                      ?.withValues(alpha: 0.6)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withValues(alpha: 0.6)),
                      onPressed: () {
                        _searchController.clear();
                        searchProvider.clearSearchResults();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.mic,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withValues(alpha: 0.6)),
                      onPressed: () {
                        // Voice search
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
          color: Theme.of(context).cardTheme.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.filters,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Category filter
              _buildCategoryFilter(searchProvider),
              const SizedBox(height: 16),

              // Price filter
              _buildPriceFilter(searchProvider),
              const SizedBox(height: 16),

              // Rating filter
              _buildRatingFilter(searchProvider),
              const SizedBox(height: 16),

              // Sort options
              _buildSortOptions(searchProvider),
              const SizedBox(height: 16),

              // Filter buttons
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
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                      ),
                      child: Text(AppLocalizations.of(context)!.reset),
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Text(AppLocalizations.of(context)!.apply),
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
        Text(
          AppLocalizations.of(context)!.category,
          style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500),
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
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).textTheme.bodyMedium?.color,
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
        Text(
          AppLocalizations.of(context)!.priceRange.toString(),
          style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(searchProvider.minPrice, searchProvider.maxPrice),
          min: 0,
          max: 10000000,
          divisions: 100,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
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
              '${searchProvider.minPrice.toInt()} ${AppLocalizations.of(context)!.currency}',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            Text(
              '${searchProvider.maxPrice.toInt()} ${AppLocalizations.of(context)!.currency}',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color),
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
        Text(
          AppLocalizations.of(context)!.minimumRating,
          style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500),
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
                color: isSelected
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary,
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
        Text(
          AppLocalizations.of(context)!.sortBy,
          style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: searchProvider.sortBy,
          dropdownColor: Theme.of(context).cardTheme.color,
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
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
                  Text(
                    'عمليات البحث السابقة',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      searchProvider.clearSearchHistory();
                    },
                    child: Text(
                      'مسح الكل',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                    deleteIconColor: Theme.of(context).iconTheme.color,
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
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.searchForProducts,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noResults,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.tryDifferentKeywords,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
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
      color: Theme.of(context).cardTheme.color,
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
            // Product image with wishlist icon
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.secondary,
                      child: product.imageUrl != null &&
                              product.imageUrl!.isNotEmpty
                          ? ImageHelper.buildCachedImage(
                              imageUrl: product.imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).iconTheme.color,
                              size: 40,
                            ),
                    ),
                  ),
                  // Wishlist icon
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
                                    content: Text(
                                        '${AppLocalizations.of(context)!.error}: $error'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isInWishlist
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).iconTheme.color,
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
            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
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
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 10,
                              );
                            }),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.reviewsCount ?? 0})',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    Text(
                      '${product.price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
