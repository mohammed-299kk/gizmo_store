import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';

import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';
import '../../utils/image_helper.dart';
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

class _EditProductScreenState extends State<EditProductScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();

  // State variables
  String _selectedCategory = '';
  String _selectedCurrency = 'ج.س';
  bool _isFeatured = false;
  bool _isAvailable = true;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  
  List<String> _categories = [];
  List<String> _imageUrls = [];
  List<File> _newImages = [];
  List<String> _imagesToDelete = [];
  
  // Auto-save timer
  Timer? _autoSaveTimer;
  bool _isAutoSaving = false;
  
  // Animation controllers
  late AnimationController _saveAnimationController;
  late Animation<double> _saveAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadCategories();
    _setupAutoSave();
    _setupAnimations();
  }

  void _setupAnimations() {
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _saveAnimationController, curve: Curves.easeInOut),
    );
  }

  void _initializeControllers() {
    _nameController.text = widget.productData['name'] ?? '';
    _descriptionController.text = widget.productData['description'] ?? '';
    _priceController.text = widget.productData['price']?.toString() ?? '';
    _discountController.text = widget.productData['discount']?.toString() ?? '0';
    _stockController.text = widget.productData['stock']?.toString() ?? '0';
    _brandController.text = widget.productData['brand'] ?? '';
    _modelController.text = widget.productData['model'] ?? '';
    _colorController.text = widget.productData['color'] ?? '';
    _weightController.text = widget.productData['weight'] ?? '';
    _dimensionsController.text = widget.productData['dimensions'] ?? '';
    _warrantyController.text = widget.productData['warranty'] ?? '';
    
    _selectedCategory = widget.productData['category'] ?? '';
    _selectedCurrency = widget.productData['currency'] ?? 'ج.س';
    _isFeatured = widget.productData['isFeatured'] ?? false;
    _isAvailable = widget.productData['isAvailable'] ?? true;
    
    // Initialize image URLs with filtering for empty and invalid strings
    if (widget.productData['imageUrls'] != null) {
      _imageUrls = List<String>.from(widget.productData['imageUrls'])
          .where((url) => url != null && url.isNotEmpty && ImageHelper.isValidImageUrl(url))
          .toList();
    } else if (widget.productData['imageUrl'] != null && 
               widget.productData['imageUrl'].toString().isNotEmpty &&
               ImageHelper.isValidImageUrl(widget.productData['imageUrl'].toString())) {
      _imageUrls = [widget.productData['imageUrl'].toString()];
    }
    
    // Add listeners for auto-save
    _setupChangeListeners();
  }

  void _setupChangeListeners() {
    final controllers = [
      _nameController,
      _descriptionController,
      _priceController,
      _discountController,
      _stockController,
      _brandController,
      _modelController,
      _colorController,
      _weightController,
      _dimensionsController,
      _warrantyController,
    ];
    
    for (final controller in controllers) {
      controller.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
    _resetAutoSaveTimer();
  }

  void _setupAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_hasUnsavedChanges && !_isLoading && !_isAutoSaving) {
        _autoSaveProduct();
      }
    });
  }

  void _resetAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_hasUnsavedChanges && !_isLoading && !_isAutoSaving) {
        _autoSaveProduct();
      }
    });
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
        _categories = categoryNames;
      });
    } catch (e) {
      // Use fallback categories if service fails
      setState(() {
        _categories = ['لابتوب', 'هاتف', 'سماعات', 'ساعة ذكية', 'تابلت'];
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

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        for (final image in images) {
          _newImages.add(File(image.path));
        }
        _hasUnsavedChanges = true;
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      final imageUrl = _imageUrls[index];
      _imagesToDelete.add(imageUrl);
      _imageUrls.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  Widget _buildImageWidget(String? imageUrl, double width, double height) {
    // التحقق من صحة رابط الصورة
    if (imageUrl == null || imageUrl.isEmpty || !ImageHelper.isValidImageUrl(imageUrl)) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 40,
        ),
      );
    }

    return ImageHelper.buildCachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildFileImageWidget(File? imageFile, double width, double height) {
    // التحقق من وجود الملف
    if (imageFile == null || !imageFile.existsSync()) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 40,
        ),
      );
    }

    return Image.file(
      imageFile,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  Future<void> _autoSaveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isAutoSaving = true;
    });
    
    try {
      await _saveProduct(showSuccessMessage: false);
      setState(() {
        _hasUnsavedChanges = false;
      });
      
      // Show subtle auto-save indicator
      _saveAnimationController.forward().then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _saveAnimationController.reverse();
          }
        });
      });
    } catch (e) {
      // Silent fail for auto-save
    } finally {
      setState(() {
        _isAutoSaving = false;
      });
    }
  }

  Future<void> _updateProduct() async {
    print('🔄 بدء عملية تحديث المنتج...');
    print('📋 معرف المنتج: ${widget.productId}');
    print('📝 اسم المنتج: ${_nameController.text}');
    print('💰 السعر: ${_priceController.text}');
    print('📦 المخزون: ${_stockController.text}');
    
    if (!_formKey.currentState!.validate()) {
      print('❌ فشل في التحقق من صحة النموذج');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى التحقق من البيانات المدخلة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Show immediate feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('جاري حفظ التغييرات...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 10),
      ),
    );
    
    try {
      print('📝 بدء حفظ المنتج...');
      await _saveProduct(showSuccessMessage: false);
      print('✅ تم حفظ المنتج بنجاح');
      
      setState(() {
        _hasUnsavedChanges = false;
        _isLoading = false;
      });
      
      if (mounted) {
        print('🎉 عرض رسالة النجاح...');
        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        // Show success dialog with checkmark
        await _showSuccessDialog();
        
        // Also show a success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 16),
                Text('تم حفظ التغييرات بنجاح!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ خطأ في تحديث المنتج: $e');
      print('📊 تفاصيل الخطأ: ${e.runtimeType}');
      print('🔍 رسالة الخطأ الكاملة: ${e.toString()}');
      
      if (mounted) {
        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        String errorMessage = 'خطأ في تحديث المنتج';
        
        // Handle specific error types
        if (e.toString().contains('permission-denied')) {
          errorMessage = 'ليس لديك صلاحية لتحديث المنتجات. تأكد من تسجيل الدخول كمدير';
        } else if (e.toString().contains('network')) {
          errorMessage = 'خطأ في الاتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى';
        } else if (e.toString().contains('فشل في رفع الصورة')) {
          errorMessage = 'فشل في رفع الصور. تحقق من حجم الصور وحاول مرة أخرى';
        } else {
          errorMessage = 'خطأ غير متوقع: ${e.toString()}';
        }
        
        // Show error dialog instead of snackbar for better visibility
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('خطأ في الحفظ'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(errorMessage),
                  SizedBox(height: 8),
                  Text(
                    'تفاصيل تقنية: ${e.toString()}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('موافق'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _updateProduct(); // Retry
                  },
                  child: Text('إعادة المحاولة'),
                ),
              ],
            );
          },
        );
        
        // Also show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 16),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              textColor: Colors.white,
              onPressed: _updateProduct,
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success animation container
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '✅ تم الحفظ بنجاح!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'تم تحديث بيانات المنتج وحفظ جميع التغييرات بنجاح',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'المنتج: ${_nameController.text}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(true); // Close edit screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'موافق',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add a method to show loading dialog during save
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'جاري حفظ التغييرات...',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'تأكيد الحذف',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFB71C1C),
            ),
          ),
          content: const Text(
            'هل أنت متأكد من حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct();
              },
              child: const Text(
                'موافق',
                style: TextStyle(
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct() async {
    try {
      await ProductService.deleteProduct(widget.productId, context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Go back to previous screen
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

  Future<void> _saveProduct({bool showSuccessMessage = true}) async {
    print('💾 بدء دالة _saveProduct...');
    print('🔧 showSuccessMessage: $showSuccessMessage');
    
    try {
      print('📸 بدء رفع الصور الجديدة...');
      print('📊 عدد الصور الجديدة: ${_newImages.length}');
      
      // Upload new images
      List<String> newImageUrls = [];
      for (int i = 0; i < _newImages.length; i++) {
        print('📤 رفع الصورة ${i + 1}/${_newImages.length}...');
        try {
          String imageUrl = await ProductService.uploadProductImage(
            _newImages[i],
            widget.productId,
          );
          newImageUrls.add(imageUrl);
          print('✅ تم رفع الصورة ${i + 1} بنجاح: $imageUrl');
        } catch (e) {
          print('❌ فشل في رفع الصورة ${i + 1}: $e');
          throw Exception('فشل في رفع الصورة ${i + 1}: $e');
        }
      }
      
      print('🔗 دمج روابط الصور...');
      print('📋 الصور الموجودة: ${_imageUrls.length}');
      print('📋 الصور الجديدة: ${newImageUrls.length}');
      
      // Combine existing and new image URLs
      List<String> allImageUrls = [..._imageUrls, ...newImageUrls];
      print('📊 إجمالي الصور: ${allImageUrls.length}');
      
      print('🔢 تحويل البيانات الرقمية...');
      
      // Parse numeric values
      double price;
      try {
        price = double.parse(_priceController.text);
        print('💰 السعر المحول: $price');
      } catch (e) {
        print('❌ خطأ في تحويل السعر: ${_priceController.text}');
        throw Exception('السعر غير صحيح');
      }
      
      double discount;
      try {
        discount = _discountController.text.isEmpty ? 0.0 : double.parse(_discountController.text);
        print('🏷️ الخصم المحول: $discount');
      } catch (e) {
        print('❌ خطأ في تحويل الخصم: ${_discountController.text}');
        throw Exception('الخصم غير صحيح');
      }
      
      int stock;
      try {
        stock = int.parse(_stockController.text);
        print('📦 المخزون المحول: $stock');
      } catch (e) {
        print('❌ خطأ في تحويل المخزون: ${_stockController.text}');
        throw Exception('المخزون غير صحيح');
      }
      
      print('📋 إنشاء بيانات التحديث...');
      
      // Create update data
      Map<String, dynamic> updateData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': price,
        'discount': discount,
        'stock': stock,
        'category': _selectedCategory,
        'isFeatured': _isFeatured,
        'isAvailable': _isAvailable,
        'imageUrls': allImageUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      print('📊 بيانات التحديث:');
      updateData.forEach((key, value) {
        if (key != 'updatedAt') {
          print('  $key: $value');
        }
      });
      
      print('🏗️ إنشاء كائن المنتج...');
      
      // Create Product object
      Product updatedProduct = Product(
        id: widget.productId,
        name: updateData['name'],
        description: updateData['description'],
        price: updateData['price'],
        discount: updateData['discount'],
        stock: updateData['stock'],
        category: updateData['category'],
        images: updateData['imageUrls'],
        featured: updateData['isFeatured'],
        isAvailable: updateData['isAvailable'],
        createdAt: DateTime.now(), // This will be ignored in update
      );
      
      print('🔄 تحديث المنتج في قاعدة البيانات...');
      print('🆔 معرف المنتج: ${updatedProduct.id}');
      
      // Update product in database
      await ProductService.updateProduct(updatedProduct);
      print('✅ تم تحديث المنتج في قاعدة البيانات بنجاح');
      
      print('🗑️ حذف الصور المحذوفة...');
      print('📊 عدد الصور المراد حذفها: ${_imagesToDelete.length}');
      
      // Delete removed images
      for (String imageUrl in _imagesToDelete) {
        try {
          print('🗑️ حذف الصورة: $imageUrl');
          await ProductService.deleteProductImage(imageUrl);
          print('✅ تم حذف الصورة بنجاح');
        } catch (e) {
          print('⚠️ تحذير: فشل في حذف الصورة $imageUrl: $e');
          // Don't throw error for image deletion failure
        }
      }
      
      print('🧹 تنظيف البيانات المؤقتة...');
      
      // Clear temporary data
      _newImages.clear();
      _imagesToDelete.clear();
      
      print('✅ تم حفظ المنتج بنجاح!');
      
      if (showSuccessMessage && mounted) {
        print('🎉 عرض رسالة النجاح...');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 16),
                Text('تم حفظ المنتج بنجاح!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ خطأ في دالة _saveProduct: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      print('🔍 تفاصيل الخطأ: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('تغييرات غير محفوظة'),
              content: const Text('لديك تغييرات غير محفوظة. هل تريد المغادرة بدون حفظ؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('مغادرة', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل المنتج'),
          backgroundColor: const Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            // Auto-save indicator
            AnimatedBuilder(
              animation: _saveAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _saveAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text('محفوظ تلقائياً', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Save button
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            else
              IconButton(
                onPressed: _updateProduct,
                icon: Icon(
                  Icons.save,
                  color: _hasUnsavedChanges ? Colors.white : Colors.white70,
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status indicator
                if (_hasUnsavedChanges || _isAutoSaving)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: _isAutoSaving ? Colors.blue.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isAutoSaving ? Colors.blue.shade200 : Colors.orange.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isAutoSaving ? Icons.sync : Icons.edit,
                          color: _isAutoSaving ? Colors.blue : Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isAutoSaving ? 'جاري الحفظ التلقائي...' : 'لديك تغييرات غير محفوظة',
                          style: TextStyle(
                            color: _isAutoSaving ? Colors.blue.shade700 : Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Basic Information Section
                _buildSectionCard(
                  title: 'المعلومات الأساسية',
                  icon: Icons.info_outline,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'اسم المنتج',
                      icon: Icons.shopping_bag_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'وصف المنتج',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال وصف المنتج';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      value: _selectedCategory,
                      label: 'الفئة',
                      icon: Icons.category_outlined,
                      items: _categories,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Pricing Section
                _buildSectionCard(
                  title: 'التسعير والمخزون',
                  icon: Icons.attach_money,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _priceController,
                            label: 'السعر',
                            icon: Icons.local_offer_outlined,
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
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            value: _selectedCurrency,
                            label: 'العملة',
                            icon: Icons.currency_exchange,
                            items: const ['ج.س', 'USD', 'EUR'],
                            onChanged: (value) {
                              setState(() {
                                _selectedCurrency = value!;
                                _hasUnsavedChanges = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _discountController,
                            label: 'نسبة الخصم (%)',
                            icon: Icons.discount_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _stockController,
                            label: 'الكمية المتوفرة',
                            icon: Icons.inventory_outlined,
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
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Product Details Section
                _buildSectionCard(
                  title: 'تفاصيل المنتج',
                  icon: Icons.details_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _brandController,
                            label: 'العلامة التجارية',
                            icon: Icons.branding_watermark_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _modelController,
                            label: 'الموديل',
                            icon: Icons.model_training_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _colorController,
                            label: 'اللون',
                            icon: Icons.color_lens_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: 'الوزن',
                            icon: Icons.scale_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _dimensionsController,
                      label: 'الأبعاد',
                      icon: Icons.straighten_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _warrantyController,
                      label: 'الضمان',
                      icon: Icons.verified_user_outlined,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Images Section
                _buildSectionCard(
                  title: 'صور المنتج',
                  icon: Icons.photo_library_outlined,
                  children: [
                    // Existing images
                    if (_imageUrls.isNotEmpty) ...[
                      const Text(
                        'الصور الحالية:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageUrls.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildImageWidget(_imageUrls[index], 100, 100),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeExistingImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // New images
                    if (_newImages.isNotEmpty) ...[
                      const Text(
                        'الصور الجديدة:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _newImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildFileImageWidget(_newImages[index], 100, 100),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeNewImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Add images button
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text('إضافة صور'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Settings Section
                _buildSectionCard(
                  title: 'إعدادات المنتج',
                  icon: Icons.settings_outlined,
                  children: [
                    SwitchListTile(
                      title: const Text('منتج مميز'),
                      subtitle: const Text('عرض المنتج في قسم المنتجات المميزة'),
                      value: _isFeatured,
                      activeColor: const Color(0xFFB71C1C),
                      onChanged: (value) {
                        setState(() {
                          _isFeatured = value;
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('متوفر للبيع'),
                      subtitle: Text(
                        _isAvailable 
                          ? 'المنتج متوفر للعملاء' 
                          : 'المنتج غير متوفر للعملاء',
                      ),
                      value: _isAvailable,
                      activeColor: const Color(0xFFB71C1C),
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    if (!_isAvailable)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'المنتج غير متوفر حالياً للعملاء',
                                style: TextStyle(color: Colors.orange.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _updateProduct,
                    icon: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save),
                    label: Text(_isLoading ? 'جاري الحفظ...' : 'حفظ التغييرات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFB71C1C)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFB71C1C)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB71C1C)),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
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
        prefixIcon: Icon(icon, color: const Color(0xFFB71C1C)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB71C1C)),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى اختيار $label';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _saveAnimationController.dispose();
    
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _dimensionsController.dispose();
    _warrantyController.dispose();
    
    super.dispose();
  }
}
