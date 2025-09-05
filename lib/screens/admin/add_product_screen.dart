import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../../widgets/image_upload_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _locationController = TextEditingController();

  final _specificationsController = TextEditingController();
  
  String _selectedCategory = '';
  String _selectedCurrency = '';
  bool _isFeatured = false;
  bool _isLoading = false;
  
  List<String> _categories = [];
  List<String> _currencies = [];
  
  List<String> _imageUrls = [];
  List<String> _specifications = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _initializeCurrencies(BuildContext context) {
    _currencies = [
      AppLocalizations.of(context)!.sudanesePound,
      AppLocalizations.of(context)!.usDollar,
      AppLocalizations.of(context)!.euro,
      AppLocalizations.of(context)!.saudiRiyal,
      AppLocalizations.of(context)!.emiratiDirham,
    ];
    if (_selectedCurrency.isEmpty && _currencies.isNotEmpty) {
      _selectedCurrency = _currencies.first;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .get();
      
      setState(() {
        _categories = snapshot.docs
            .map((doc) => doc.data()['name'] as String)
            .toList();
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.errorLoadingCategories}: $e')),
      );
    }
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

  void _onImagesChanged(List<String> newImages) {
    setState(() {
      _imageUrls = newImages;
    });
  }

  Future<void> _saveProduct() async {
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
      
      final discount = (double.tryParse(_discountController.text.trim()) ?? 0).toInt();
      final originalPrice = discount > 0 ? price / (1 - discount / 100) : price;

      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': price,
        'originalPrice': originalPrice,
        'category': _selectedCategory,
        'currency': _selectedCurrency,
        'discount': discount,
        'featured': _isFeatured,
        'image': _imageUrls.isNotEmpty ? _imageUrls.first : '',
        'images': _imageUrls,
        'location': _locationController.text,
        'specifications': _specifications,
        'isAvailable': true,
        'stock': 100, // Default stock
        'rating': 0.0,
        'reviewsCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.productAddedSuccessfully)),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorAddingProduct}: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _discountController.clear();
    _locationController.clear();
    _specificationsController.clear();
    setState(() {
      _isFeatured = false;
      _imageUrls.clear();
      _specifications.clear();
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
      if (_currencies.isNotEmpty) {
        _selectedCurrency = _currencies.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initializeCurrencies(context);
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                AppLocalizations.of(context)!.addNewProductTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
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
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.productDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterProductDescription;
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
                          return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
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
                          _selectedCurrency = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
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
                    _selectedCategory = value!;
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
              
              // Discount
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.discountPercentage,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              
              // Featured
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.featuredProduct),
                value: _isFeatured,
                onChanged: (value) {
                  setState(() {
                    _isFeatured = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Images Section
              Text(
                AppLocalizations.of(context)!.productImages,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ImageUploadWidget(
                initialImages: _imageUrls,
                onImagesChanged: _onImagesChanged,
                folder: 'gizmo_store/products',
                allowMultiple: true,
                placeholder: 'إضافة صور المنتج',
                height: 120,
                width: 100,
              ),
              const SizedBox(height: 16),
              
              // Specifications Section
              Text(
                AppLocalizations.of(context)!.specifications,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _specificationsController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.specification,
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
              const SizedBox(height: 8),
              if (_specifications.isNotEmpty)
                Column(
                  children: _specifications.asMap().entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeSpecification(entry.key),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 32),
              
              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        AppLocalizations.of(context)!.saveProduct,
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
    _specificationsController.dispose();
    super.dispose();
  }
}
