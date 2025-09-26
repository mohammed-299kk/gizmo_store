import 'package:flutter/material.dart';
import 'lib/services/product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔍 فحص المنتجات...');
  
  try {
    final products = await ProductService.getAllProducts();
    print('📦 عدد المنتجات: ${products.length}');
    
    if (products.isNotEmpty) {
      print('\n📋 قائمة المنتجات:');
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        print('${i + 1}. ${product.name} - ${product.category} - ${product.price} ج.س');
      }
    } else {
      print('❌ لا توجد منتجات');
    }
    
    // فحص المنتجات المميزة
    final featured = await ProductService.getFeaturedProducts(null);
    print('\n⭐ المنتجات المميزة: ${featured.length}');
    
  } catch (e) {
    print('❌ خطأ: $e');
  }
}