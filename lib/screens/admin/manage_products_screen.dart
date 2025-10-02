import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/product_service.dart';
import '../../utils/image_helper.dart';
import 'edit_product_screen.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  String _selectedAvailability = 'الكل';
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageProducts),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Enhanced Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchProducts,
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFB71C1C)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFB71C1C)),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        label: 'الفئة',
                        value: _selectedCategory,
                        items: ['الكل', 'لابتوب', 'هاتف', 'سماعات', 'ساعة ذكية', 'تابلت'],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown(
                        label: 'حالة التوفر',
                        value: _selectedAvailability,
                        items: ['الكل', 'متوفر', 'غير متوفر'],
                        onChanged: (value) {
                          setState(() {
                            _selectedAvailability = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Products List/Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ProductService.getAllProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFB71C1C),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${AppLocalizations.of(context)!.errorLoadingProducts}: ${snapshot.error}',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noProducts,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter products based on search and filters
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final category = data['category'] ?? '';
                  final isAvailable = data['isAvailable'] ?? true;

                  // Search filter
                  if (_searchQuery.isNotEmpty && !name.contains(_searchQuery)) {
                    return false;
                  }

                  // Category filter
                  if (_selectedCategory != 'الكل' && category != _selectedCategory) {
                    return false;
                  }

                  // Availability filter
                  if (_selectedAvailability == 'متوفر' && !isAvailable) {
                    return false;
                  }
                  if (_selectedAvailability == 'غير متوفر' && isAvailable) {
                    return false;
                  }

                  return true;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد منتجات تطابق البحث',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _isGridView
                    ? _buildGridView(filteredDocs)
                    : _buildListView(filteredDocs);
              },
            ),
          ),
        ],
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
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue,
          isExpanded: true,
          hint: Text(label),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final data = doc.data() as Map<String, dynamic>;
        return _buildProductCard(doc.id, data, false);
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> docs) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final data = doc.data() as Map<String, dynamic>;
        return _buildProductCard(doc.id, data, true);
      },
    );
  }

  Widget _buildProductCard(String productId, Map<String, dynamic> data, bool isGrid) {
    final isAvailable = data['isAvailable'] ?? true;
    final stock = data['stock'] ?? 0;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editProduct(productId, data),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: isGrid ? _buildGridCardContent(productId, data) : _buildListCardContent(productId, data),
        ),
      ),
    );
  }

  Widget _buildGridCardContent(String productId, Map<String, dynamic> data) {
    final isAvailable = data['isAvailable'] ?? true;
    final stock = data['stock'] ?? 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image and Status
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageHelper.buildCachedImage(
                  imageUrl: data['imageUrl'] ?? data['image'] ?? '',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Availability Badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAvailable ? 'متوفر' : 'غير متوفر',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Quick Actions
              Positioned(
                bottom: 8,
                left: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQuickActionButton(
                      icon: Icons.edit,
                      color: Colors.blue,
                      onPressed: () => _editProduct(productId, data),
                    ),
                    const SizedBox(width: 4),
                    _buildQuickActionButton(
                      icon: isAvailable ? Icons.visibility_off : Icons.visibility,
                      color: isAvailable ? Colors.orange : Colors.green,
                      onPressed: () => _toggleAvailability(productId, isAvailable),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Product Info
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['name'] ?? 'اسم غير محدد',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                data['category'] ?? 'فئة غير محددة',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data['price'] ?? 0} ${data['currency'] ?? 'ج.س'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'المخزون: $stock',
                    style: TextStyle(
                      color: stock > 0 ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListCardContent(String productId, Map<String, dynamic> data) {
    final isAvailable = data['isAvailable'] ?? true;
    final stock = data['stock'] ?? 0;
    
    return Row(
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ImageHelper.buildCachedImage(
            imageUrl: data['imageUrl'] ?? data['image'] ?? '',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        // Product Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data['name'] ?? 'اسم غير محدد',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isAvailable ? 'متوفر' : 'غير متوفر',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                data['category'] ?? 'فئة غير محددة',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data['price'] ?? 0} ${data['currency'] ?? 'ج.س'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'المخزون: $stock',
                    style: TextStyle(
                      color: stock > 0 ? Colors.green : Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Actions Menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editProduct(productId, data);
                break;
              case 'toggle_availability':
                _toggleAvailability(productId, data['isAvailable'] ?? true);
                break;
              case 'delete':
                _deleteProduct(productId, data['name'] ?? 'منتج غير محدد');
                break;
              case 'view':
                _viewProductDetails(data);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Color(0xFFB71C1C)),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  const Icon(Icons.visibility, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('عرض التفاصيل'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_availability',
              child: Row(
                children: [
                  Icon(
                    data['isAvailable'] == true
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: data['isAvailable'] == true
                        ? Color(0xFFB71C1C)
                        : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data['isAvailable'] == true
                        ? AppLocalizations.of(context)!.hide
                        : AppLocalizations.of(context)!.show,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.delete),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Future<void> _editProduct(String productId, Map<String, dynamic> productData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          productId: productId,
          productData: productData,
        ),
      ),
    );

    // Show success message if product was updated
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث المنتج بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteProduct(String productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDelete),
        content: Text(AppLocalizations.of(context)!.deleteProductConfirmation(productName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ProductService.deleteProduct(productId, context);
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.productDeletedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppLocalizations.of(context)!.errorDeletingProduct}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleAvailability(String productId, bool currentAvailability) async {
    try {
      await ProductService.toggleProductAvailability(productId, !currentAvailability, context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentAvailability
                  ? AppLocalizations.of(context)!.productHidden
                  : AppLocalizations.of(context)!.productShown,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorUpdatingProduct}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewProductDetails(Map<String, dynamic> productData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(productData['name'] ?? AppLocalizations.of(context)!.productDetails),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (productData['imageUrl'] != null && productData['imageUrl'].isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageHelper.buildCachedImage(
                    imageUrl: productData['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.descriptionLabel}${productData['description'] ?? AppLocalizations.of(context)!.noDescription}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.categoryLabel}${productData['category'] ?? AppLocalizations.of(context)!.notSpecified}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.priceLabel}${productData['price']} ${productData['currency'] ?? AppLocalizations.of(context)!.sudanesePound}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (productData['discount'] != null && productData['discount'] > 0) ...{
                const SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context)!.discountLabel}${productData['discount']}%',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              },
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.stockLabel}${productData['stock'] ?? 0}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.ratingLabel}${productData['rating'] ?? 0.0} (${productData['reviewsCount'] ?? 0} ${AppLocalizations.of(context)!.reviews})',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.statusLabel}${(productData['isAvailable'] ?? true) ? AppLocalizations.of(context)!.available : AppLocalizations.of(context)!.unavailable}',
                style: TextStyle(
                  fontSize: 16,
                  color: (productData['isAvailable'] ?? true)
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
