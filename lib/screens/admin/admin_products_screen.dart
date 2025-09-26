import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';
import '../../utils/image_helper.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  Set<String> _selectedProducts = {};
  
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreProducts = true;
  bool _isSearching = false;
  bool _showFilters = false;
  
  String _selectedCategory = 'الكل';
  String _selectedAvailability = 'الكل';
  String _selectedFeatured = 'الكل';
  String _sortBy = 'الأحدث';
  
  DocumentSnapshot? _lastDocument;
  Timer? _searchTimer;
  
  // Animation controllers
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadCategories();
    _loadProducts();
    _setupScrollListener();
    _searchController.addListener(_onSearchChanged);
  }

  void _setupAnimations() {
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _filterAnimationController, curve: Curves.easeInOut),
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );
    
    _fabAnimationController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoadingMore && _hasMoreProducts) {
          _loadMoreProducts();
        }
      }
    });
  }

  void _onSearchChanged() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });
    
    final query = _searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_products);
        _isSearching = false;
      });
    } else {
      final filtered = _products.where((product) {
        return product.name.toLowerCase().contains(query) ||
               product.description.toLowerCase().contains(query) ||
               (product.category?.toLowerCase().contains(query) ?? false) ||
               (product.brand?.toLowerCase().contains(query) ?? false);
      }).toList();
      
      setState(() {
        _filteredProducts = filtered;
        _isSearching = false;
      });
    }
    
    _applyFiltersAndSort();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService.getCategories();
      setState(() {
        // Filter out empty names and remove duplicates
        final categoryNames = categories
            .map((cat) => cat['name'] as String)
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList();
        _categories = ['الكل', ...categoryNames];
      });
    } catch (e) {
      // Use fallback categories if service fails
      setState(() {
        _categories = ['الكل', 'لابتوب', 'هاتف', 'سماعات', 'ساعة ذكية', 'تابلت'];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل الفئات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadProducts({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoading = true;
        _products.clear();
        _filteredProducts.clear();
        _lastDocument = null;
        _hasMoreProducts = true;
      });
    }

    try {
      Query query = FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(100); // زيادة الحد لعرض المزيد من المنتجات

      if (_lastDocument != null && !refresh) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();
      
      if (snapshot.docs.isNotEmpty) {
        final newProducts = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product.fromMap(data, doc.id);
        }).toList();

        setState(() {
          if (refresh) {
            _products = newProducts;
          } else {
            _products.addAll(newProducts);
          }
          _lastDocument = snapshot.docs.last;
          _hasMoreProducts = snapshot.docs.length == 100;
        });

        _performSearch();
      } else {
        setState(() {
          _hasMoreProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل المنتجات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _isLoadingMore = true;
    });
    await _loadProducts();
  }

  void _applyFiltersAndSort() {
    List<Product> filtered = List.from(_filteredProducts);

    // Apply category filter
    if (_selectedCategory != 'الكل') {
      filtered = filtered.where((product) => product.category == _selectedCategory).toList();
    }

    // Apply availability filter
    if (_selectedAvailability != 'الكل') {
      if (_selectedAvailability == 'متوفر') {
        filtered = filtered.where((product) => product.isAvailable && (product.stock ?? 0) > 0).toList();
      } else if (_selectedAvailability == 'غير متوفر') {
        filtered = filtered.where((product) => !product.isAvailable || (product.stock ?? 0) <= 0).toList();
      } else if (_selectedAvailability == 'مخزون منخفض') {
        filtered = filtered.where((product) => (product.stock ?? 0) > 0 && (product.stock ?? 0) <= 5).toList();
      }
    }

    // Apply featured filter
    if (_selectedFeatured != 'الكل') {
      if (_selectedFeatured == 'مميز') {
        filtered = filtered.where((product) => product.featured).toList();
      } else if (_selectedFeatured == 'عادي') {
        filtered = filtered.where((product) => !product.featured).toList();
      }
    }

    // Apply sorting
    switch (_sortBy) {
      case 'الأحدث':
        filtered.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
      case 'الأقدم':
        filtered.sort((a, b) => (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()));
        break;
      case 'الاسم (أ-ي)':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'الاسم (ي-أ)':
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'السعر (الأقل)':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'السعر (الأعلى)':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'المخزون (الأقل)':
        filtered.sort((a, b) => (a.stock ?? 0).compareTo(b.stock ?? 0));
        break;
      case 'المخزون (الأعلى)':
        filtered.sort((a, b) => (b.stock ?? 0).compareTo(a.stock ?? 0));
        break;
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    
    if (_showFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'الكل';
      _selectedAvailability = 'الكل';
      _selectedFeatured = 'الكل';
      _sortBy = 'الأحدث';
      _searchController.clear();
    });
    _performSearch();
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  void _selectAllProducts() {
    setState(() {
      if (_selectedProducts.length == _filteredProducts.length) {
        _selectedProducts.clear();
      } else {
        _selectedProducts = _filteredProducts.map((p) => p.id).toSet();
      }
    });
  }

  Future<void> _bulkUpdateAvailability(bool isAvailable) async {
    if (_selectedProducts.isEmpty) return;

    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (final productId in _selectedProducts) {
        final docRef = FirebaseFirestore.instance.collection('products').doc(productId);
        batch.update(docRef, {
          'isAvailable': isAvailable,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      
      setState(() {
        _selectedProducts.clear();
      });
      
      await _loadProducts(refresh: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAvailable ? 'تم تفعيل المنتجات المحددة' : 'تم إلغاء تفعيل المنتجات المحددة'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحديث المنتجات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _bulkUpdateFeatured(bool isFeatured) async {
    if (_selectedProducts.isEmpty) return;

    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (final productId in _selectedProducts) {
        final docRef = FirebaseFirestore.instance.collection('products').doc(productId);
        batch.update(docRef, {
          'featured': isFeatured,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      
      setState(() {
        _selectedProducts.clear();
      });
      
      await _loadProducts(refresh: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFeatured ? 'تم تمييز المنتجات المحددة' : 'تم إلغاء تمييز المنتجات المحددة'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحديث المنتجات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _bulkDelete() async {
    if (_selectedProducts.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ${_selectedProducts.length} منتج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (final productId in _selectedProducts) {
        final docRef = FirebaseFirestore.instance.collection('products').doc(productId);
        batch.delete(docRef);
      }
      
      await batch.commit();
      
      setState(() {
        _selectedProducts.clear();
      });
      
      await _loadProducts(refresh: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتجات المحددة'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حذف المنتجات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ProductService.deleteProduct(productId, context);
      await _loadProducts(refresh: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حذف المنتج: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          productId: product.id,
          productData: product.toMap(),
        ),
      ),
    );

    if (result == true) {
      await _loadProducts(refresh: true);
    }
  }

  Future<void> _addProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      ),
    );

    if (result == true) {
      await _loadProducts(refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedProducts.isNotEmpty) ...[
            IconButton(
              onPressed: () => _bulkUpdateAvailability(true),
              icon: const Icon(Icons.visibility),
              tooltip: 'تفعيل المحدد',
            ),
            IconButton(
              onPressed: () => _bulkUpdateAvailability(false),
              icon: const Icon(Icons.visibility_off),
              tooltip: 'إلغاء تفعيل المحدد',
            ),
            IconButton(
              onPressed: () => _bulkUpdateFeatured(true),
              icon: const Icon(Icons.star),
              tooltip: 'تمييز المحدد',
            ),
            IconButton(
              onPressed: _bulkDelete,
              icon: const Icon(Icons.delete),
              tooltip: 'حذف المحدد',
            ),
          ] else ...[
            IconButton(
              onPressed: _toggleFilters,
              icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
              tooltip: 'الفلاتر',
            ),
            IconButton(
              onPressed: () => _loadProducts(refresh: true),
              icon: const Icon(Icons.refresh),
              tooltip: 'تحديث',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFB71C1C),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'البحث في المنتجات...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _performSearch();
                        },
                        icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7)),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),

          // Filters Panel
          AnimatedBuilder(
            animation: _filterAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _filterAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Column(
                    children: [
                      // Filter Row 1
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown(
                              label: 'الفئة',
                              value: _selectedCategory,
                              items: _categories,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                                _applyFiltersAndSort();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFilterDropdown(
                              label: 'التوفر',
                              value: _selectedAvailability,
                              items: const ['الكل', 'متوفر', 'غير متوفر', 'مخزون منخفض'],
                              onChanged: (value) {
                                setState(() {
                                  _selectedAvailability = value!;
                                });
                                _applyFiltersAndSort();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Filter Row 2
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown(
                              label: 'التمييز',
                              value: _selectedFeatured,
                              items: const ['الكل', 'مميز', 'عادي'],
                              onChanged: (value) {
                                setState(() {
                                  _selectedFeatured = value!;
                                });
                                _applyFiltersAndSort();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFilterDropdown(
                              label: 'الترتيب',
                              value: _sortBy,
                              items: const [
                                'الأحدث',
                                'الأقدم',
                                'الاسم (أ-ي)',
                                'الاسم (ي-أ)',
                                'السعر (الأقل)',
                                'السعر (الأعلى)',
                                'المخزون (الأقل)',
                                'المخزون (الأعلى)',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _sortBy = value!;
                                });
                                _applyFiltersAndSort();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Clear Filters Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('مسح الفلاتر'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB71C1C),
                            side: const BorderSide(color: Color(0xFFB71C1C)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Selection Header
          if (_selectedProducts.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Text(
                    'تم تحديد ${_selectedProducts.length} منتج',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _selectedProducts.clear()),
                    child: const Text('إلغاء التحديد'),
                  ),
                ],
              ),
            ),

          // Products List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => _loadProducts(refresh: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredProducts.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredProducts.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            
                            final product = _filteredProducts[index];
                            final isSelected = _selectedProducts.contains(product.id);
                            
                            return _buildProductCard(product, isSelected);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _addProduct,
          backgroundColor: const Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('إضافة منتج'),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // التأكد من أن القيمة المحددة موجودة في قائمة العناصر
    String? validValue;
    if (value.isNotEmpty && items.contains(value)) {
      validValue = value;
    }
    
    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'لا توجد منتجات تطابق البحث'
                : 'لا توجد منتجات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'جرب البحث بكلمات مختلفة'
                : 'ابدأ بإضافة منتجات جديدة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addProduct,
            icon: const Icon(Icons.add),
            label: const Text('إضافة منتج جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: Color(0xFFB71C1C), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _toggleProductSelection(product.id),
        onLongPress: () => _toggleProductSelection(product.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  // Selection Checkbox
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleProductSelection(product.id),
                    activeColor: const Color(0xFFB71C1C),
                  ),
                  
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageHelper.buildCachedImage(
                      imageUrl: product.imageUrl ?? 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=300&fit=crop&crop=center',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category ?? 'غير محدد',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${product.price} ${product.currency}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (product.stock ?? 0) > 5
                                    ? Colors.green.shade100
                                    : (product.stock ?? 0) > 0
                                        ? Colors.orange.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'المخزون: ${product.stock ?? 0}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (product.stock ?? 0) > 5
                                      ? Colors.green.shade700
                                      : (product.stock ?? 0) > 0
                                          ? Colors.orange.shade700
                                          : Colors.red.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Buttons
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => _editProduct(product),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'تعديل',
                      ),
                      IconButton(
                        onPressed: () => _deleteProduct(product.id),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'حذف',
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Status Row
              Row(
                children: [
                  // Availability Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.isAvailable && (product.stock ?? 0) > 0
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.isAvailable && (product.stock ?? 0) > 0
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 16,
                          color: product.isAvailable && (product.stock ?? 0) > 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.isAvailable && (product.stock ?? 0) > 0 ? 'متوفر' : 'غير متوفر',
                          style: TextStyle(
                            fontSize: 12,
                            color: product.isAvailable && (product.stock ?? 0) > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Featured Status
                  if (product.featured)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'مميز',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // Quick Actions
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(product.id)
                                .update({
                              'isAvailable': !product.isAvailable,
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                            await _loadProducts(refresh: true);
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ في تحديث المنتج: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(
                          product.isAvailable ? Icons.visibility_off : Icons.visibility,
                          color: product.isAvailable ? Colors.orange : Colors.green,
                        ),
                        tooltip: product.isAvailable ? 'إخفاء' : 'إظهار',
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(product.id)
                                .update({
                              'featured': !product.featured,
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                            await _loadProducts(refresh: true);
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ في تحديث المنتج: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(
                              product.featured ? Icons.star : Icons.star_border,
                              color: product.featured ? Colors.amber : Colors.grey,
                            ),
                            tooltip: product.featured ? 'إلغاء التمييز' : 'تمييز',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _filterAnimationController.dispose();
    _fabAnimationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}