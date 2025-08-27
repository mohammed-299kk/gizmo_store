import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../models/product.dart';

class DatabaseSetupService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize categories in Firestore
  static Future<void> setupCategories() async {
    try {
      final categories = [
        Category(
          name: 'هواتف ذكية',
          imageUrl: 'https://via.placeholder.com/300x300?text=Smartphones',
          order: 1,
          isActive: true,
        ),
        Category(
          name: 'لابتوبات',
          imageUrl: 'https://via.placeholder.com/300x300?text=Laptops',
          order: 2,
          isActive: true,
        ),
        Category(
          name: 'سماعات',
          imageUrl: 'https://via.placeholder.com/300x300?text=Headphones',
          order: 3,
          isActive: true,
        ),
        Category(
          name: 'ساعات ذكية',
          imageUrl: 'https://via.placeholder.com/300x300?text=Smartwatches',
          order: 4,
          isActive: true,
        ),
        Category(
          name: 'أجهزة لوحية',
          imageUrl: 'https://via.placeholder.com/300x300?text=Tablets',
          order: 5,
          isActive: true,
        ),
        Category(
          name: 'إكسسوارات',
          imageUrl: 'https://via.placeholder.com/300x300?text=Accessories',
          order: 6,
          isActive: true,
        ),
        Category(
          name: 'أجهزة كمبيوتر',
          imageUrl: 'https://via.placeholder.com/300x300?text=Computers',
          order: 7,
          isActive: true,
        ),
        Category(
          name: 'كاميرات',
          imageUrl: 'https://via.placeholder.com/300x300?text=Cameras',
          order: 8,
          isActive: true,
        ),
      ];

      // Check if categories already exist
      final existingCategories = await _firestore.collection('categories').get();
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
      throw e;
    }
  }

  /// Initialize sample products with proper categories
  static Future<void> setupSampleProducts() async {
    try {
      final products = [
        // Smartphones
        Product(
          id: '',
          name: 'iPhone 15 Pro',
          description: 'أحدث هاتف من Apple مع شريحة A17 Pro وكاميرا محسنة',
          price: 4999.0,
          originalPrice: 5499.0,
          image: 'https://via.placeholder.com/300x300?text=iPhone+15+Pro',
          category: 'هواتف ذكية',
          rating: 4.8,
          reviewsCount: 150,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy S24 Ultra',
          description: 'هاتف Samsung الرائد مع قلم S Pen وكاميرا 200 ميجابكسل',
          price: 4299.0,
          originalPrice: 4799.0,
          image: 'https://via.placeholder.com/300x300?text=Galaxy+S24',
          category: 'هواتف ذكية',
          rating: 4.7,
          reviewsCount: 120,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Google Pixel 8 Pro',
          description: 'هاتف Google مع ذكاء اصطناعي متقدم وكاميرا ممتازة',
          price: 3799.0,
          image: 'https://via.placeholder.com/300x300?text=Pixel+8',
          category: 'هواتف ذكية',
          rating: 4.6,
          reviewsCount: 89,
          featured: false,
        ),

        // Laptops
        Product(
          id: '',
          name: 'MacBook Pro 16"',
          description: 'لابتوب Apple مع شريحة M3 Pro وشاشة Retina',
          price: 8999.0,
          originalPrice: 9999.0,
          image: 'https://via.placeholder.com/300x300?text=MacBook+Pro',
          category: 'لابتوبات',
          rating: 4.9,
          reviewsCount: 200,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Dell XPS 13',
          description: 'لابتوب Dell خفيف الوزن مع معالج Intel Core i7',
          price: 4599.0,
          image: 'https://via.placeholder.com/300x300?text=Dell+XPS',
          category: 'لابتوبات',
          rating: 4.5,
          reviewsCount: 156,
          featured: false,
        ),

        // Headphones
        Product(
          id: '',
          name: 'AirPods Pro 2',
          description: 'سماعات Apple اللاسلكية مع إلغاء الضوضاء النشط',
          price: 899.0,
          originalPrice: 999.0,
          image: 'https://via.placeholder.com/300x300?text=AirPods+Pro',
          category: 'سماعات',
          rating: 4.7,
          reviewsCount: 300,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sony WH-1000XM5',
          description: 'سماعات Sony الرائدة مع إلغاء الضوضاء الممتاز',
          price: 1299.0,
          image: 'https://via.placeholder.com/300x300?text=Sony+WH1000XM5',
          category: 'سماعات',
          rating: 4.8,
          reviewsCount: 250,
          featured: false,
        ),

        // Smart Watches
        Product(
          id: '',
          name: 'Apple Watch Series 9',
          description: 'ساعة Apple الذكية مع مراقبة الصحة المتقدمة',
          price: 1599.0,
          image: 'https://via.placeholder.com/300x300?text=Apple+Watch',
          category: 'ساعات ذكية',
          rating: 4.6,
          reviewsCount: 180,
          featured: true,
        ),

        // Tablets
        Product(
          id: '',
          name: 'iPad Pro 12.9"',
          description: 'جهاز iPad Pro مع شريحة M2 وشاشة Liquid Retina',
          price: 3999.0,
          image: 'https://via.placeholder.com/300x300?text=iPad+Pro',
          category: 'أجهزة لوحية',
          rating: 4.8,
          reviewsCount: 145,
          featured: true,
        ),

        // Accessories
        Product(
          id: '',
          name: 'MagSafe Charger',
          description: 'شاحن Apple اللاسلكي المغناطيسي',
          price: 199.0,
          image: 'https://via.placeholder.com/300x300?text=MagSafe',
          category: 'إكسسوارات',
          rating: 4.4,
          reviewsCount: 89,
          featured: false,
        ),
      ];

      // Check if products already exist
      final existingProducts = await _firestore.collection('products').get();
      if (existingProducts.docs.isNotEmpty) {
        print('Products already exist. Skipping setup.');
        return;
      }

      // Add products to Firestore
      for (final product in products) {
        final productData = {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'originalPrice': product.originalPrice,
          'image': product.image,
          'category': product.category,
          'rating': product.rating,
          'reviewsCount': product.reviewsCount,
          'featured': product.featured,
          'isAvailable': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        await _firestore.collection('products').add(productData);
      }

      print('Sample products setup completed successfully!');
    } catch (e) {
      print('Error setting up sample products: $e');
      throw e;
    }
  }

  /// Complete database setup
  static Future<void> initializeDatabase() async {
    try {
      print('Starting database initialization...');
      
      await setupCategories();
      await setupSampleProducts();
      
      print('Database initialization completed successfully!');
    } catch (e) {
      print('Error during database initialization: $e');
      rethrow;
    }
  }

  /// Get all categories
  static Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('order')
          .get();

      return snapshot.docs.map((doc) {
        return Category.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  /// Get products by category
  static Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: categoryName)
          .where('isAvailable', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          originalPrice: data['originalPrice']?.toDouble(),
          image: data['image'],
          category: data['category'],
          rating: (data['rating'] ?? 0).toDouble(),
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
