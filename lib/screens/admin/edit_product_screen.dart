import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../widgets/image_upload_widget.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _locationController;
  late TextEditingController _stockController;
  late TextEditingController _specificationsController;

  String _selectedCategory = '';
  String _selectedCurrency = '';
  bool _isFeatured = false;
  bool _isAvailable = true;
  bool _isLoading = false;

  List<String> _categories = [];
  List<String> _currencies = [];

  List<String> _imageUrls = [];
  List<String> _specifications = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCurrencies();
    });
  }

  void _initializeCurrencies() {
    final localizations = AppLocalizations.of(context)!;
    _currencies = [
      localizations.sudanesePound,
      localizations.usDollar,
      localizations.euro,
      localizations.saudiRiyal,
      localizations.emiratiDirham,
    ];

    // التأكد من أن العملة المحددة موجودة في القائمة
    if (_selectedCurrency.isEmpty || !_currencies.contains(_selectedCurrency)) {
      _selectedCurrency = localizations.sudanesePound;
    }

    setState(() {});
  }

  void _initializeControllers() {
    // تحويل البيانات إلى Map عادي لتجنب مشاكل LinkedMap
    final data = Map<String, dynamic>.from(widget.productData);

    _nameController = TextEditingController(text: data['name'] ?? '');
    _descriptionController =
        TextEditingController(text: data['description'] ?? '');
    _priceController =
        TextEditingController(text: (data['price'] ?? 0).toString());
    _discountController =
        TextEditingController(text: (data['discount'] ?? 0).toString());
    _locationController = TextEditingController(text: data['location'] ?? '');
    _stockController =
        TextEditingController(text: (data['stock'] ?? 0).toString());
    _specificationsController = TextEditingController();

    _selectedCategory = data['category'] ?? '';
    // سيتم تعيين العملة في _initializeCurrencies
    _selectedCurrency = data['currency'] ?? '';
    _isFeatured = data['featured'] ?? false;
    _isAvailable = data['isAvailable'] ?? true;

    // Initialize image URLs - معالجة آمنة للبيانات
    try {
      if (data['images'] != null) {
        if (data['images'] is List) {
          _imageUrls = List<String>.from(data['images']);
        } else {
          _imageUrls = [];
        }
      } else if (data['image'] != null && data['image'].isNotEmpty) {
        _imageUrls = [data['image']];
      }
    } catch (e) {
      print('خطأ في تحميل الصور: $e');
      _imageUrls = [];
    }

    // Initialize specifications - معالجة آمنة للبيانات
    try {
      if (data['specifications'] != null) {
        if (data['specifications'] is List) {
          _specifications = List<String>.from(data['specifications']);
        } else {
          _specifications = [];
        }
      }
    } catch (e) {
      print('خطأ في تحميل المواصفات: $e');
      _specifications = [];
    }
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      setState(() {
        _categories =
            snapshot.docs.map((doc) => doc.data()['name'] as String).toList();

        // If current category is not in the list, add it
        if (_selectedCategory.isNotEmpty &&
            !_categories.contains(_selectedCategory)) {
          _categories.add(_selectedCategory);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${AppLocalizations.of(context)!.errorLoadingCategories}: $e')),
        );
      }
    }
  }

  void _onImagesChanged(List<String> newImages) {
    setState(() {
      _imageUrls = newImages;
    });
  }

  void _addSpecification() {
    if (_specificationsController.text.isNotEmpty) {
      setState(() {
        _specifications.add(_specificationsController.text);
        _specificationsController.clear();
      });
    }
  }

  void _removeSpecification(int index) {
    setState(() {
      _specifications.removeAt(index);
    });
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Safe parsing with error handling
      final priceText = _priceController.text.trim();
      if (priceText.isEmpty) {
        throw Exception(AppLocalizations.of(context)!.pleaseEnterPrice);
      }

      final price = double.tryParse(priceText);
      if (price == null || price <= 0) {
        throw Exception(AppLocalizations.of(context)!.pleaseEnterValidNumber);
      }

      final discount =
          (double.tryParse(_discountController.text.trim()) ?? 0).toInt();
      final originalPrice = discount > 0 ? price / (1 - discount / 100) : price;
      final stock = int.tryParse(_stockController.text.trim()) ?? 0;

      // Create Product object and update using ProductService
      final product = Product(
        id: widget.productId,
        name: _nameController.text,
        description: _descriptionController.text,
        price: price,
        originalPrice: originalPrice,
        category: _selectedCategory,
        currency: _selectedCurrency,
        discount: discount,
        featured: _isFeatured,
        isAvailable: _isAvailable,
        image: _imageUrls.isNotEmpty ? _imageUrls.first : '',
        images: _imageUrls,
        location: _locationController.text,
        specifications: _specifications,
        stock: stock,
      );

      await ProductService.updateProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.productUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppLocalizations.of(context)!.errorUpdatingProduct}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProduct),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _updateProduct,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.productName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterProductName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Product Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.productDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .pleaseEnterProductDescription;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              if (_categories.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _categories.contains(_selectedCategory)
                      ? _selectedCategory
                      : null,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.category,
                    border: const OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseSelectCategory;
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),

              // Price and Currency
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.price,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterPrice;
                        }
                        if (double.tryParse(value) == null) {
                          return AppLocalizations.of(context)!
                              .pleaseEnterValidNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.currency,
                        border: const OutlineInputBorder(),
                      ),
                      items: _currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrency = value ??
                              AppLocalizations.of(context)!.sudanesePound;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Discount and Stock
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.discount,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.stock,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.location,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Image Upload Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.images,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ImageUploadWidget(
                        initialImages: _imageUrls,
                        onImagesChanged: _onImagesChanged,
                        folder: 'gizmo_store/products',
                        allowMultiple: true,
                        placeholder: 'تحديث صور المنتج',
                        height: 120,
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Specifications Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.specifications,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _specificationsController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .addSpecification,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addSpecification,
                            child: Text(AppLocalizations.of(context)!.add),
                          ),
                        ],
                      ),
                      if (_specifications.isNotEmpty) ...{
                        const SizedBox(height: 16),
                        Text(
                            '${AppLocalizations.of(context)!.currentSpecifications}:'),
                        const SizedBox(height: 8),
                        ...List.generate(_specifications.length, (index) {
                          return Card(
                            child: ListTile(
                              title: Text(_specifications[index]),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeSpecification(index),
                              ),
                            ),
                          );
                        }),
                      },
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Switches
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title:
                            Text(AppLocalizations.of(context)!.featuredProduct),
                        value: _isFeatured,
                        onChanged: (value) {
                          setState(() {
                            _isFeatured = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                            AppLocalizations.of(context)!.availableForSale),
                        value: _isAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Update Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        AppLocalizations.of(context)!.updateProduct,
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _locationController.dispose();
    _stockController.dispose();
    _specificationsController.dispose();
    super.dispose();
  }
}
