import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/image_helper.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _iconController = TextEditingController();
  final _imageController = TextEditingController();
  final _orderController = TextEditingController();

  bool _isActive = true;
  bool _isLoading = false;

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final order = int.tryParse(_orderController.text) ?? 0;

      await FirebaseFirestore.instance.collection('categories').add({
        'name': _nameController.text,
        'nameEn': _nameEnController.text,
        'description': _descriptionController.text,
        'icon': _iconController.text,
        'image': _imageController.text,
        'isActive': _isActive,
        'order': order,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة الفئة بنجاح')),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في إضافة الفئة: $e')),
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
    _nameEnController.clear();
    _descriptionController.clear();
    _iconController.clear();
    _imageController.clear();
    _orderController.clear();
    setState(() {
      _isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة فئة جديدة'),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Category Name (Arabic)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الفئة (عربي)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الفئة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Name (English)
              TextFormField(
                controller: _nameEnController,
                decoration: const InputDecoration(
                  labelText: 'اسم الفئة (إنجليزي)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الفئة بالإنجليزية';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف الفئة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Icon
              TextFormField(
                controller: _iconController,
                decoration: const InputDecoration(
                  labelText: 'أيقونة الفئة (رابط أو اسم الأيقونة)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  hintText: 'مثال: Icons.shopping_cart أو رابط الصورة',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال أيقونة الفئة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'صورة الفئة (رابط)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.photo),
                  hintText: 'https://example.com/image.jpg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رابط صورة الفئة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Order
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(
                  labelText: 'ترتيب الفئة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sort),
                  hintText: 'رقم الترتيب (اختياري)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Active Status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'حالة الفئة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: Text(_isActive ? 'نشطة' : 'غير نشطة'),
                        subtitle: Text(
                          _isActive
                              ? 'الفئة ستظهر للمستخدمين'
                              : 'الفئة لن تظهر للمستخدمين',
                        ),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Preview Card
              if (_nameController.text.isNotEmpty ||
                  _imageController.text.isNotEmpty)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'معاينة الفئة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Icon preview
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _iconController.text.isNotEmpty
                                  ? (_iconController.text.startsWith('http')
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: ImageHelper.buildCachedImage(
                                            imageUrl: _iconController.text,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(Icons.category))
                                  : const Icon(Icons.category),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nameController.text.isNotEmpty
                                        ? _nameController.text
                                        : 'اسم الفئة',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_nameEnController.text.isNotEmpty)
                                    Text(
                                      _nameEnController.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  if (_descriptionController.text.isNotEmpty)
                                    Text(
                                      _descriptionController.text,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB71C1C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'حفظ الفئة',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _clearForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'مسح النموذج',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
    _nameController.dispose();
    _nameEnController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    _imageController.dispose();
    _orderController.dispose();
    super.dispose();
  }
}
