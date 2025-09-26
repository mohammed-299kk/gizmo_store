import 'package:flutter/material.dart';
import 'lib/services/product_service.dart';
import 'lib/services/database_setup_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔍 Testing product loading...');
  
  try {
    // Test getting all products
    final products = await ProductService.getAllProducts();
    print('📦 Found ${products.length} products');
    
    if (products.isNotEmpty) {
      print('First 3 products:');
      for (int i = 0; i < products.length && i < 3; i++) {
        final product = products[i];
        print('- ${product.name} (${product.category}) - ${product.price} ج.س');
        print('  Image: ${product.imageUrl ?? 'No image'}');
        print('  Featured: ${product.featured}');
      }
    } else {
      print('❌ No products found!');
      print('🔄 Trying to initialize database...');
      
      // Try to initialize database
      await DatabaseSetupService.initializeDatabase(null);
      
      // Try again
      final newProducts = await ProductService.getAllProducts();
      print('📦 After initialization: Found ${newProducts.length} products');
    }
    
  } catch (e) {
    print('❌ Error: $e');
  }
}