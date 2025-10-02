import 'package:flutter/material.dart';
import '../services/product_management_service.dart';
import '../constants/app_colors.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _deleteAllProducts() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'جاري حذف المنتجات الحالية...';
    });

    try {
      await ProductManagementService.deleteAllProducts();
      setState(() {
        _statusMessage = 'تم حذف جميع المنتجات بنجاح!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'خطأ في حذف المنتجات: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _add50NewProducts() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'جاري إضافة 50 منتج جديد...';
    });

    try {
      await ProductManagementService.add50NewProducts();
      setState(() {
        _statusMessage = 'تم إضافة 50 منتج جديد بنجاح!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'خطأ في إضافة المنتجات: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'إدارة المنتجات المتقدمة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة المعلومات
              Card(
                color: AppColors.surface,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'إدارة المنتجات',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'يمكنك حذف المنتجات الحالية وإضافة 50 منتج جديد بصور عالية الجودة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // أزرار العمليات
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _deleteAllProducts,
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text(
                  'حذف جميع المنتجات الحالية',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _add50NewProducts,
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: const Text(
                  'إضافة 50 منتج جديد',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // رسالة الحالة
              if (_statusMessage.isNotEmpty)
                Card(
                  color: AppColors.surface,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (_isLoading)
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}