import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../models/product.dart';
import 'image_upload_service.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'products';

  // Fetch all products
  static Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      // In a real app, you might want to throw an exception or return a custom error object.
      // For now, we return an empty list.
      return [];
    }
  }

  // Get all products as Stream for management
  static Stream<QuerySnapshot> getAllProductsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .snapshots();
  }

  // Search products as Stream
  static Stream<QuerySnapshot> searchProductsStream(String searchTerm) {
    if (searchTerm.isEmpty) {
      return getAllProductsStream();
    }
    
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
        .snapshots();
  }

  // Get featured products
  static Future<List<Product>> getFeaturedProducts(BuildContext context) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('featured', isEqualTo: true)
          .limit(20)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorFetchingFeaturedProducts}: $e');
      return [];
    }
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(String category, BuildContext context) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .limit(100)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorFetchingCategoryProducts}: $e');
      return [];
    }
  }

  // Search products
  static Future<List<Product>> searchProducts(String query, BuildContext context) async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              (product.description.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (product.category?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorSearching}: $e');
      return [];
    }
  }

  // Add new product
  static Future<void> addProduct(Product product, BuildContext context) async {
    try {
      await _firestore.collection(_collection).add(product.toMap());
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorAddingProduct}: $e');
      throw Exception(localizations.failedToAddProduct);
    }
  }



  // Delete product
  static Future<void> deleteProduct(String id, BuildContext context) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorDeletingProduct}: $e');
      throw Exception(localizations.failedToDeleteProduct);
    }
  }

  // Upload image using Cloudinary
  static Future<String> uploadProductImage(File imageFile, String productId) async {
    print('📤 ProductService.uploadProductImage - بدء رفع الصورة...');
    print('🆔 معرف المنتج: $productId');
    print('📁 مسار الملف: ${imageFile.path}');
    
    try {
      print('☁️ رفع الصورة إلى Cloudinary...');
      final urls = await ImageUploadService.uploadProductImages([imageFile]);
      
      if (urls.isEmpty) {
        print('❌ لم يتم إرجاع أي URLs من خدمة رفع الصور');
        throw Exception('فشل في رفع الصورة إلى Cloudinary - لم يتم إرجاع أي URLs');
      }
      
      // التحقق من أن القائمة تحتوي على عناصر قبل استخدام .first
      if (urls.isNotEmpty) {
        final imageUrl = urls.first;
        print('✅ تم رفع الصورة بنجاح: $imageUrl');
        return imageUrl;
      } else {
        print('❌ القائمة فارغة رغم التحقق السابق');
        throw Exception('خطأ غير متوقع: القائمة فارغة');
      }
    } catch (e) {
      print('❌ خطأ في رفع الصورة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في رفع الصورة: ${e.toString()}');
    }
  }

  // Delete image (Cloudinary images don't need manual deletion)
  static Future<void> deleteProductImage(String imageUrl) async {
    print('🗑️ ProductService.deleteProductImage - بدء حذف الصورة...');
    print('🔗 رابط الصورة: $imageUrl');
    
    try {
      // Cloudinary images are managed automatically
      // No manual deletion needed for basic usage
      print('☁️ حذف الصورة من Cloudinary غير مطلوب للاستخدام الأساسي');
      print('✅ تم تجاهل حذف الصورة بنجاح');
    } catch (e) {
      print('❌ خطأ في حذف الصورة: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      throw Exception('فشل في حذف الصورة: ${e.toString()}');
    }
  }

  // Toggle product availability status
  static Future<void> toggleProductAvailability(String id, bool isAvailable, BuildContext context) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isAvailable': isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorUpdatingProductStatus}: $e');
      throw Exception(localizations.failedToUpdateProductStatus);
    }
  }

  // Get single product by ID
  static Future<Product?> getProductById(String id, BuildContext context) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Product.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorFetchingProduct}: $e');
      return null;
    }
  }



  // Default data in case of no connection
  static List<Product> _getDefaultProducts() {
    return [
      Product(
        id: 'default_1',
        name: 'iPhone 15 Pro',
        description: 'Latest iPhone from Apple',
        price: 4999.0,
        category: 'Phones',
        featured: true,
      ),
      Product(
        id: 'default_2',
        name: 'MacBook Pro',
        description: 'Professional laptop',
        price: 8999.0,
        category: 'Computer',
        featured: true,
      ),
      Product(
        id: 'default_3',
        name: 'AirPods Pro',
        description: 'Wireless earphones',
        price: 899.0,
        category: 'Headphones',
        featured: false,
      ),
    ];
  }

  // Check Firestore connection
  static Future<bool> checkConnection() async {
    try {
      await _firestore.collection('test').doc('connection').get();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> updateProduct(Product product) async {
    print('🔄 ProductService.updateProduct - بدء تحديث المنتج...');
    print('🆔 معرف المنتج: ${product.id}');
    print('📝 اسم المنتج: ${product.name}');
    print('💰 السعر: ${product.price}');
    print('📦 المخزون: ${product.stock}');
    print('🏷️ الفئة: ${product.category}');
    print('📸 عدد الصور: ${product.images?.length ?? 0}');
    print('⭐ مميز: ${product.featured}');
    print('✅ متوفر: ${product.isAvailable}');
    
    try {
      print('🔗 الاتصال بـ Firestore...');
      
      // Convert Product to Map for Firestore
      Map<String, dynamic> productData = {
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'discount': product.discount,
        'stock': product.stock,
        'category': product.category,
        'imageUrls': product.images ?? [],
        'isFeatured': product.featured,
        'isAvailable': product.isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      print('📊 بيانات المنتج للحفظ:');
      productData.forEach((key, value) {
        if (key != 'updatedAt') {
          print('  $key: $value');
        }
      });
      
      print('💾 تحديث المستند في Firestore...');
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(productData);
      
      print('✅ تم تحديث المنتج في Firestore بنجاح!');
      print('🎉 ProductService.updateProduct - اكتمل بنجاح');
      
    } catch (e) {
      print('❌ خطأ في ProductService.updateProduct: $e');
      print('📊 نوع الخطأ: ${e.runtimeType}');
      print('🔍 تفاصيل الخطأ الكاملة: ${e.toString()}');
      
      // Check for specific Firebase errors
      if (e.toString().contains('permission-denied')) {
        print('🚫 خطأ في الصلاحيات - المستخدم ليس لديه صلاحية للتحديث');
        throw Exception('ليس لديك صلاحية لتحديث المنتجات. تأكد من تسجيل الدخول كمدير.');
      } else if (e.toString().contains('not-found')) {
        print('🔍 المنتج غير موجود');
        throw Exception('المنتج غير موجود في قاعدة البيانات.');
      } else if (e.toString().contains('network')) {
        print('🌐 خطأ في الشبكة');
        throw Exception('خطأ في الاتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى.');
      } else {
        print('❓ خطأ غير معروف');
        throw Exception('حدث خطأ أثناء تحديث المنتج: ${e.toString()}');
      }
    }
  }
}
