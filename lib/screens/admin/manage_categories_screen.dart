import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmo_store/models/product.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الفئات المتاحة
  final List<Map<String, dynamic>> _categories = [
    {'id': 'smartphones', 'name': 'هواتف ذكية', 'icon': Icons.smartphone},
    {'id': 'laptops', 'name': 'أجهزة اللابتوب', 'icon': Icons.laptop_mac},
    {'id': 'headphones', 'name': 'سماعات الرأس', 'icon': Icons.headphones},
    {'id': 'smartwatches', 'name': 'الساعات الذكية', 'icon': Icons.watch},
    {'id': 'tablets', 'name': 'الأجهزة اللوحية', 'icon': Icons.tablet_mac},
    {'id': 'accessories', 'name': 'الإكسسوارات', 'icon': Icons.cable},
    {'id': 'cameras', 'name': 'الكاميرات', 'icon': Icons.camera_alt},
    {'id': 'tv', 'name': 'التلفزيونات', 'icon': Icons.tv},
    {'id': 'gaming', 'name': 'الألعاب', 'icon': Icons.sports_esports},
  ];

  String? _selectedCategoryId;
  List<Product> _allProducts = [];
  List<Product> _categoryProducts = [];
  Set<String> _selectedProductIds = {}; // المنتجات المحددة
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _firestore.collection('products').get();
      _allProducts = snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل المنتجات: $e')),
        );
      }
    }
  }

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _categoryProducts =
          _allProducts.where((p) => p.category == categoryId).toList();

      // تحديد المنتجات الموجودة في هذه الفئة
      _selectedProductIds.clear();
      for (var product in _categoryProducts) {
        _selectedProductIds.add(product.id);
      }
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_selectedCategoryId == null) return;

    setState(() => _isSaving = true);

    try {
      // حفظ التغييرات في Firebase
      final batch = _firestore.batch();

      for (var product in _allProducts) {
        final shouldBeInCategory = _selectedProductIds.contains(product.id);
        final isInCategory = product.category == _selectedCategoryId;

        // إذا كان المنتج محدد ولكن ليس في الفئة، أضفه
        if (shouldBeInCategory && !isInCategory) {
          batch.update(
            _firestore.collection('products').doc(product.id),
            {'category': _selectedCategoryId},
          );
        }
        // إذا كان المنتج غير محدد ولكن في الفئة، احذفه
        else if (!shouldBeInCategory && isInCategory) {
          batch.update(
            _firestore.collection('products').doc(product.id),
            {'category': 'uncategorized'},
          );
        }
      }

      await batch.commit();

      // إعادة تحميل المنتجات
      await _loadAllProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التغييرات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في حفظ التغييرات: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('إدارة الفئات', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: _selectedCategoryId != null
            ? [
                // زر الحفظ
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _isSaving
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : TextButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            'حفظ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // عرض الفئات
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'اختر فئة المنتج',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected =
                              _selectedCategoryId == category['id'];
                          final productCount = _allProducts
                              .where((p) => p.category == category['id'])
                              .length;

                          return InkWell(
                            onTap: () => _selectCategory(category['id']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFB71C1C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFB71C1C)
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category['icon'],
                                    size: 32,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$productCount منتج',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? Colors.white70
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // عرض المنتجات
                Expanded(
                  child: _selectedCategoryId == null
                      ? const Center(
                          child: Text(
                            'اختر فئة لعرض المنتجات',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : _buildProductsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildProductsList() {
    return Column(
      children: [
        // عنوان القسم
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'جميع المنتجات',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_selectedProductIds.length} محدد من ${_allProducts.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // قائمة المنتجات
        Expanded(
          child: _allProducts.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد منتجات',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _allProducts.length,
                  itemBuilder: (context, index) {
                    final product = _allProducts[index];
                    final isSelected = _selectedProductIds.contains(product.id);
                    return _buildProductCard(product, isSelected);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
      child: ListTile(
        onTap: () {
          setState(() {
            if (_selectedProductIds.contains(product.id)) {
              _selectedProductIds.remove(product.id);
            } else {
              _selectedProductIds.add(product.id);
            }
          });
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${product.price} ${product.currency}',
              style: const TextStyle(color: Color(0xFFB71C1C)),
            ),
            const SizedBox(height: 4),
            Text(
              'الفئة الحالية: ${_getCategoryName(product.category)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _selectedProductIds.add(product.id);
              } else {
                _selectedProductIds.remove(product.id);
              }
            });
          },
          activeColor: const Color(0xFFB71C1C),
        ),
      ),
    );
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'غير مصنف';
    final category = _categories.firstWhere(
      (c) => c['id'] == categoryId,
      orElse: () => {'name': 'غير مصنف'},
    );
    return category['name'];
  }
}
