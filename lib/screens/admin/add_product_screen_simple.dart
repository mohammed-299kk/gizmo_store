import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class AddProductScreenSimple extends StatefulWidget {
  const AddProductScreenSimple({super.key});

  @override
  State<AddProductScreenSimple> createState() => _AddProductScreenSimpleState();
}

class _AddProductScreenSimpleState extends State<AddProductScreenSimple> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _stockController = TextEditingController();
  
  String _selectedCategory = 'smartphones';
  bool _isLoading = false;

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

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final stock = int.tryParse(_stockController.text) ?? 0;

      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'price': price,
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'image': _imageController.text.trim(),
        'imageUrl': _imageController.text.trim(),
        'images': [_imageController.text.trim()],
        'stock': stock,
        'stockQuantity': stock,
        'isAvailable': stock > 0,
        'inStock': stock > 0,
        'currency': 'ج.س',
        'rating': 0.0,
        'reviewsCount': 0,
        'featured': false,
        'discount': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );

        // مسح النموذج
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _imageController.clear();
        _stockController.clear();
        setState(() => _selectedCategory = 'smartphones');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج جديد'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // اسم المنتج
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المنتج *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال اسم المنتج';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // السعر
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'السعر (ج.س) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال السعر';
                }
                if (double.tryParse(value) == null) {
                  return 'يرجى إدخال رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // الفئة
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'الفئة *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'],
                  child: Row(
                    children: [
                      Icon(category['icon'], size: 20),
                      const SizedBox(width: 8),
                      Text(category['name']),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // الوصف
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال وصف المنتج';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // رابط الصورة
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'رابط الصورة *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
                hintText: 'https://example.com/image.jpg',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال رابط الصورة';
                }
                if (!value.startsWith('http')) {
                  return 'يرجى إدخال رابط صحيح يبدأ بـ http';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // الكمية في المخزون
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'الكمية في المخزون *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال الكمية';
                }
                if (int.tryParse(value) == null) {
                  return 'يرجى إدخال رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // زر الحفظ
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'إضافة المنتج',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

