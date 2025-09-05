import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:gizmo_store/models/product.dart';
import '../../services/product_service.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageProducts),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchForProduct,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Products List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ProductService.searchProductsStream(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final products = snapshot.data?.docs ?? [];

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noProducts,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final doc = products[index];
                    final data = doc.data() as Map<String, dynamic>;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: data['image'] != null && data['image'].isNotEmpty
                              ? NetworkImage(data['image'])
                              : null,
                          child: data['image'] == null || data['image'].isEmpty
                              ? const Icon(Icons.image)
                              : null,
                          onBackgroundImageError: (exception, stackTrace) {
                            // Handle image loading error silently
                          },
                        ),
                        title: Text(
                          data['name'] ?? AppLocalizations.of(context)!.noName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${AppLocalizations.of(context)!.categoryLabel}${data['category'] ?? AppLocalizations.of(context)!.notSpecified}'),
                            Text(
                              '${AppLocalizations.of(context)!.priceLabel}${data['price']} ${data['currency'] ?? AppLocalizations.of(context)!.sudanesePound}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (data['discount'] != null && data['discount'] > 0)
                              Text(
                                '${AppLocalizations.of(context)!.discountLabel}${data['discount']}%',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _editProduct(doc.id, data);
                                break;
                              case 'delete':
                                _deleteProduct(doc.id, data['name'] ?? AppLocalizations.of(context)!.product);
                                break;
                              case 'toggle_availability':
                                _toggleAvailability(doc.id, data['isAvailable'] ?? true);
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
                        onTap: () => _viewProductDetails(data),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(String productId, Map<String, dynamic> productData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          productId: productId,
          productData: productData,
        ),
      ),
    );
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
              if (productData['image'] != null && productData['image'].isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(productData['image']),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading error silently
                      },
                    ),
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
