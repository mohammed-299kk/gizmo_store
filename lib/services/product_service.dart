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
          .limit(5)
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

  // Update product
  static Future<void> updateProduct(String id, Product product, BuildContext context) async {
    try {
      await _firestore.collection(_collection).doc(id).update(product.toMap());
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorUpdatingProduct}: $e');
      throw Exception(localizations.failedToUpdateProduct);
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
  static Future<String> uploadProductImage(File imageFile, String productId, BuildContext context) async {
    try {
      final urls = await ImageUploadService.uploadProductImages([imageFile]);
      return urls.first;
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorUploadingImage}: $e');
      throw Exception(localizations.failedToUploadImage);
    }
  }

  // Delete image (Cloudinary images don't need manual deletion)
  static Future<void> deleteProductImage(String imageUrl, BuildContext context) async {
    try {
      // Cloudinary images are managed automatically
      // No manual deletion needed for basic usage
      print('Image deletion not required for Cloudinary: $imageUrl');
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('${localizations.errorDeletingImage}: $e');
      throw Exception(localizations.failedToDeleteImage);
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

  // Create sample data
  static Future<void> _createSampleProducts() async {
    final sampleProducts = [
      Product(
        id: 'iphone_15_pro',
        name: 'iPhone 15 Pro',
        description: 'Latest iPhone from Apple with A17 Pro processor and advanced camera',
        price: 4999.0,
        originalPrice: 5499.0,
        image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
        category: 'Phones',
        rating: 4.8,
        reviewsCount: 1250,
        featured: true,
        specifications: [
          'A17 Pro processor',
          '128GB storage',
          '48MP camera',
          '6.1-inch display',
          'IP68 water resistant'
        ],
      ),
      Product(
        id: 'macbook_pro_m3',
        name: 'MacBook Pro M3',
        description: 'Professional laptop with M3 processor for developers and designers',
        price: 8999.0,
        originalPrice: 9999.0,
        image: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400',
        category: 'Computer',
        rating: 4.9,
        reviewsCount: 890,
        featured: true,
        specifications: [
          'Apple M3 processor',
          '16GB RAM',
          '512GB SSD storage',
          '14-inch Retina display',
          '18-hour battery life'
        ],
      ),
      Product(
        id: 'airpods_pro_2',
        name: 'AirPods Pro 2nd Generation',
        description: 'Wireless earphones with active noise cancellation',
        price: 899.0,
        originalPrice: 999.0,
        image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
        category: 'Headphones',
        rating: 4.7,
        reviewsCount: 2100,
        featured: true,
        specifications: [
          'Active noise cancellation',
          'H2 chip',
          'IPX4 water resistant',
          '30-hour battery life',
          'Wireless charging'
        ],
      ),
      Product(
        id: 'ipad_air_5',
        name: 'iPad Air 5th Generation',
        description: 'Powerful and versatile tablet for work and entertainment',
        price: 2499.0,
        image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        category: 'Tablet',
        rating: 4.6,
        reviewsCount: 750,
        featured: false,
        specifications: [
          'M1 processor',
          '10.9-inch Liquid Retina display',
          '12MP camera',
          'Apple Pencil support',
          'Available in multiple colors'
        ],
      ),
      Product(
        id: 'apple_watch_9',
        name: 'Apple Watch Series 9',
        description: 'Advanced smartwatch for health and fitness tracking',
        price: 1599.0,
        image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400',
        category: 'Watches',
        rating: 4.5,
        reviewsCount: 1800,
        featured: false,
        specifications: [
          'S9 SiP processor',
          'Always-On Retina display',
          '50-meter water resistant',
          'Heart rate tracking',
          'Built-in GPS'
        ],
      ),
      Product(
        id: 'samsung_tv_75',
        name: 'Samsung QLED 75-inch',
        description: 'Smart TV with 4K resolution and QLED technology',
        price: 3299.0,
        originalPrice: 3799.0,
        image: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400',
        category: 'Television',
        rating: 4.4,
        reviewsCount: 650,
        featured: false,
        specifications: [
          '4K UHD resolution',
          'QLED technology',
          'Tizen smart system',
          'HDR10+',
          'Four HDMI ports'
        ],
      ),
      Product(
        id: 'sony_headphones',
        name: 'Sony WH-1000XM5',
        description: 'Wireless headphones with industry-leading noise cancellation',
        price: 1299.0,
        image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
        category: 'Headphones',
        rating: 4.8,
        reviewsCount: 920,
        featured: true,
        specifications: [
          'Industry-leading noise cancellation',
          '30-hour battery',
          'Quick charge',
          'High-resolution audio',
          'Clear calls'
        ],
      ),
      Product(
        id: 'dell_laptop',
        name: 'Dell XPS 13',
        description: 'Slim and lightweight laptop perfect for business and study',
        price: 4599.0,
        image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
        category: 'Computer',
        rating: 4.3,
        reviewsCount: 540,
        featured: false,
        specifications: [
          'Intel Core i7 processor',
          '16GB RAM',
          '512GB SSD storage',
          '13.3-inch InfinityEdge display',
          'Only 1.2kg weight'
        ],
      ),
    ];

    try {
      final batch = _firestore.batch();
      
      for (final product in sampleProducts) {
        final docRef = _firestore.collection(_collection).doc(product.id);
        batch.set(docRef, product.toMap());
      }
      
      await batch.commit();
      print('✅ Sample data created successfully');
    } catch (e) {
      print('❌ Error creating sample data: $e');
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
}
