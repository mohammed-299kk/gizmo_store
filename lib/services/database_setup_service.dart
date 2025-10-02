import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/product.dart';

class DatabaseSetupService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Safe conversion to double with error handling
  static double _safeToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  /// Initialize categories in Firestore
  static Future<void> setupCategories(BuildContext context) async {
    try {
      final localizations = AppLocalizations.of(context)!;
      final categories = [
        Category(
          name: localizations.categorySmartphones,
          imageUrl: 'https://via.placeholder.com/300x300?text=Smartphones',
          order: 1,
          isActive: true,
        ),
        Category(
          name: localizations.categoryLaptops,
          imageUrl: 'https://via.placeholder.com/300x300?text=Laptops',
          order: 2,
          isActive: true,
        ),
        Category(
          name: localizations.categoryHeadphones,
          imageUrl: 'https://via.placeholder.com/300x300?text=Headphones',
          order: 3,
          isActive: true,
        ),
        Category(
          name: localizations.categorySmartWatches,
          imageUrl: 'https://via.placeholder.com/300x300?text=Smartwatches',
          order: 4,
          isActive: true,
        ),
        Category(
          name: localizations.categoryTablets,
          imageUrl: 'https://via.placeholder.com/300x300?text=Tablets',
          order: 5,
          isActive: true,
        ),
        Category(
          name: localizations.categoryAccessories,
          imageUrl: 'https://via.placeholder.com/300x300?text=Accessories',
          order: 6,
          isActive: true,
        ),
        Category(
          name: localizations.categoryComputers,
          imageUrl: 'https://via.placeholder.com/300x300?text=Computers',
          order: 7,
          isActive: true,
        ),
        Category(
          name: localizations.categoryCameras,
          imageUrl: 'https://via.placeholder.com/300x300?text=Cameras',
          order: 8,
          isActive: true,
        ),
      ];

      // Check if categories already exist
      final existingCategories =
          await _firestore.collection('categories').get();
      if (existingCategories.docs.isNotEmpty) {
        print('Categories already exist. Skipping setup.');
        return;
      }

      // Add categories to Firestore
      for (final category in categories) {
        await _firestore.collection('categories').add(category.toMap());
      }

      print('Categories setup completed successfully!');
    } catch (e) {
      print('Error setting up categories: $e');
      rethrow;
    }
  }



  /// Complete database setup
  static Future<void> initializeDatabase(BuildContext context) async {
    try {
      print('Starting database initialization...');

      await setupCategories(context);
      
      // Check if products exist
      final existingProducts = await _firestore.collection('products').get();
      if (existingProducts.docs.isEmpty) {
        print('No products found in database.');
      } else {
        print('Products already exist in database (${existingProducts.docs.length} products found).');
        // Ensure all existing products have required fields
        await _validateAndFixExistingProducts();
      }

      print('Database initialization completed successfully!');
    } catch (e) {
      print('Error during database initialization: $e');
      rethrow;
    }
  }

  /// Validates and fixes existing products to ensure they have all required fields
  static Future<void> _validateAndFixExistingProducts() async {
    try {
      final productsSnapshot = await _firestore.collection('products').get();
      
      for (final doc in productsSnapshot.docs) {
        final data = doc.data();
        bool needsUpdate = false;
        Map<String, dynamic> updates = {};
        
        // Ensure isAvailable field exists
        if (!data.containsKey('isAvailable')) {
          updates['isAvailable'] = true;
          needsUpdate = true;
        }
        
        // Ensure createdAt field exists
        if (!data.containsKey('createdAt')) {
          updates['createdAt'] = FieldValue.serverTimestamp();
          needsUpdate = true;
        }
        
        // Ensure updatedAt field exists
        if (!data.containsKey('updatedAt')) {
          updates['updatedAt'] = FieldValue.serverTimestamp();
          needsUpdate = true;
        }
        
        // Ensure featured field exists
        if (!data.containsKey('featured')) {
          updates['featured'] = false;
          needsUpdate = true;
        }
        
        // Ensure rating field exists and is valid
        if (!data.containsKey('rating') || data['rating'] == null) {
          updates['rating'] = 4.0;
          needsUpdate = true;
        }
        
        // Ensure reviewsCount field exists
        if (!data.containsKey('reviewsCount') || data['reviewsCount'] == null) {
          updates['reviewsCount'] = 0;
          needsUpdate = true;
        }
        
        // Update document if needed
        if (needsUpdate) {
          await doc.reference.update(updates);
          print('Updated product ${doc.id} with missing fields');
        }
      }
      
      print('Product validation completed successfully!');
    } catch (e) {
      print('Error validating existing products: $e');
      // Don't rethrow here to avoid breaking the app
    }
  }

  /// Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final snapshot =
          await _firestore.collection('categories').orderBy('order').get();

      return snapshot.docs.map((doc) {
        return Category.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  /// Get products by category
  static Future<List<Product>> getProductsByCategory(
      String categoryName) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: categoryName)
          .where('isAvailable', isEqualTo: true)
          .limit(100)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: _safeToDouble(data['price']),
          originalPrice: data['originalPrice'] != null
              ? _safeToDouble(data['originalPrice'])
              : null,
          image: data['image'],
          category: data['category'],
          rating: _safeToDouble(data['rating']),
          reviewsCount: data['reviewsCount'] ?? 0,
          featured: data['featured'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }
}
