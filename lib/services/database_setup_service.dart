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

  /// Initialize sample products with proper categories
  static Future<void> setupSampleProducts(BuildContext context) async {
    try {
      final localizations = AppLocalizations.of(context)!;
      final products = [
        // Smartphones
        Product(
          id: '',
          name: 'iPhone 15 Pro',
          description: localizations.productIphone15ProDesc,
          price: 4999.0,
          originalPrice: 5499.0,
          image: 'https://via.placeholder.com/300x300?text=iPhone+15+Pro',
          category: localizations.categorySmartphones,
          rating: 4.8,
          reviewsCount: 150,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy S24 Ultra',
          description: localizations.productGalaxyS24UltraDesc,
          price: 4299.0,
          originalPrice: 4799.0,
          image: 'https://via.placeholder.com/300x300?text=Galaxy+S24',
          category: localizations.categorySmartphones,
          rating: 4.7,
          reviewsCount: 120,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Google Pixel 8 Pro',
          description: localizations.productPixel8ProDesc,
          price: 3799.0,
          image: 'https://via.placeholder.com/300x300?text=Pixel+8',
          category: localizations.categorySmartphones,
          rating: 4.6,
          reviewsCount: 89,
          featured: false,
        ),

        // Laptops
        Product(
          id: '',
          name: 'MacBook Pro 16"',
          description: localizations.productMacBookProDesc,
          price: 8999.0,
          originalPrice: 9999.0,
          image: 'https://via.placeholder.com/300x300?text=MacBook+Pro',
          category: localizations.categoryLaptops,
          rating: 4.9,
          reviewsCount: 200,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Dell XPS 13',
          description: localizations.productDellXpsDesc,
          price: 4599.0,
          image: 'https://via.placeholder.com/300x300?text=Dell+XPS',
          category: localizations.categoryLaptops,
          rating: 4.5,
          reviewsCount: 156,
          featured: false,
        ),

        // Headphones
        Product(
          id: '',
          name: 'AirPods Pro 2',
          description: localizations.productAirPodsProDesc,
          price: 899.0,
          originalPrice: 999.0,
          image: 'https://via.placeholder.com/300x300?text=AirPods+Pro',
          category: localizations.categoryHeadphones,
          rating: 4.7,
          reviewsCount: 300,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sony WH-1000XM5',
          description: localizations.productSonyWHDesc,
          price: 1299.0,
          image: 'https://via.placeholder.com/300x300?text=Sony+WH1000XM5',
          category: localizations.categoryHeadphones,
          rating: 4.8,
          reviewsCount: 250,
          featured: false,
        ),

        // Smart Watches
        Product(
          id: '',
          name: 'Apple Watch Series 9',
          description: localizations.productAppleWatchDesc,
          price: 1599.0,
          image: 'https://via.placeholder.com/300x300?text=Apple+Watch',
          category: localizations.categorySmartWatches,
          rating: 4.6,
          reviewsCount: 180,
          featured: true,
        ),

        // Tablets
        Product(
          id: '',
          name: 'iPad Pro 12.9"',
          description: localizations.productIpadProDesc,
          price: 3999.0,
          image: 'https://via.placeholder.com/300x300?text=iPad+Pro',
          category: localizations.categoryTablets,
          rating: 4.8,
          reviewsCount: 145,
          featured: true,
        ),

        // Accessories
        Product(
          id: '',
          name: 'MagSafe Charger',
          description: localizations.productMagSafeDesc,
          price: 199.0,
          image: 'https://via.placeholder.com/300x300?text=MagSafe',
          category: localizations.categoryAccessories,
          rating: 4.4,
          reviewsCount: 89,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Wireless Charging Pad',
          description: 'شاحن لاسلكي سريع متوافق مع جميع الأجهزة',
          price: 149.0,
          image: 'https://via.placeholder.com/300x300?text=Wireless+Charger',
          category: localizations.categoryAccessories,
          rating: 4.3,
          reviewsCount: 67,
          featured: false,
        ),

        // More Smartphones
        Product(
          id: '',
          name: 'OnePlus 12',
          description: 'هاتف ذكي بأداء عالي وتصميم أنيق',
          price: 3299.0,
          originalPrice: 3599.0,
          image: 'https://via.placeholder.com/300x300?text=OnePlus+12',
          category: localizations.categorySmartphones,
          rating: 4.5,
          reviewsCount: 95,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Xiaomi 14 Ultra',
          description: 'هاتف ذكي بكاميرا احترافية وأداء متميز',
          price: 2899.0,
          image: 'https://via.placeholder.com/300x300?text=Xiaomi+14',
          category: localizations.categorySmartphones,
          rating: 4.4,
          reviewsCount: 78,
          featured: false,
        ),

        // More Laptops
        Product(
          id: '',
          name: 'HP Spectre x360',
          description: 'لابتوب قابل للتحويل بشاشة لمس عالية الدقة',
          price: 5299.0,
          originalPrice: 5799.0,
          image: 'https://via.placeholder.com/300x300?text=HP+Spectre',
          category: localizations.categoryLaptops,
          rating: 4.6,
          reviewsCount: 134,
          featured: false,
        ),
        Product(
          id: '',
          name: 'ASUS ROG Zephyrus',
          description: 'لابتوب ألعاب بأداء عالي ومعالج رسومات قوي',
          price: 6799.0,
          image: 'https://via.placeholder.com/300x300?text=ASUS+ROG',
          category: localizations.categoryLaptops,
          rating: 4.7,
          reviewsCount: 167,
          featured: true,
        ),

        // More Headphones
        Product(
          id: '',
          name: 'Bose QuietComfort 45',
          description: 'سماعات بإلغاء الضوضاء وجودة صوت استثنائية',
          price: 1199.0,
          originalPrice: 1399.0,
          image: 'https://via.placeholder.com/300x300?text=Bose+QC45',
          category: localizations.categoryHeadphones,
          rating: 4.6,
          reviewsCount: 189,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Sennheiser Momentum 4',
          description: 'سماعات لاسلكية بجودة صوت عالية وتصميم أنيق',
          price: 1099.0,
          image: 'https://via.placeholder.com/300x300?text=Sennheiser',
          category: localizations.categoryHeadphones,
          rating: 4.5,
          reviewsCount: 145,
          featured: false,
        ),

        // More Smart Watches
        Product(
          id: '',
          name: 'Samsung Galaxy Watch 6',
          description: 'ساعة ذكية بمراقبة صحية متقدمة وتصميم عصري',
          price: 1299.0,
          image: 'https://via.placeholder.com/300x300?text=Galaxy+Watch',
          category: localizations.categorySmartWatches,
          rating: 4.4,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Garmin Fenix 7',
          description: 'ساعة رياضية متقدمة مع GPS ومقاومة للماء',
          price: 2199.0,
          originalPrice: 2499.0,
          image: 'https://via.placeholder.com/300x300?text=Garmin+Fenix',
          category: localizations.categorySmartWatches,
          rating: 4.7,
          reviewsCount: 123,
          featured: true,
        ),

        // More Tablets
        Product(
          id: '',
          name: 'Samsung Galaxy Tab S9',
          description: 'تابلت بشاشة AMOLED وقلم S Pen متضمن',
          price: 2799.0,
          image: 'https://via.placeholder.com/300x300?text=Galaxy+Tab',
          category: localizations.categoryTablets,
          rating: 4.5,
          reviewsCount: 98,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Microsoft Surface Pro 9',
          description: 'تابلت بنظام Windows وإمكانيات لابتوب كاملة',
          price: 4299.0,
          originalPrice: 4699.0,
          image: 'https://via.placeholder.com/300x300?text=Surface+Pro',
          category: localizations.categoryTablets,
          rating: 4.6,
          reviewsCount: 112,
          featured: true,
        ),

        // Computers
        Product(
          id: '',
          name: 'iMac 24" M3',
          description: 'كمبيوتر مكتبي بشاشة Retina ومعالج M3 قوي',
          price: 6999.0,
          originalPrice: 7499.0,
          image: 'https://via.placeholder.com/300x300?text=iMac+24',
          category: localizations.categoryComputers,
          rating: 4.8,
          reviewsCount: 87,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Gaming PC RTX 4080',
          description: 'كمبيوتر ألعاب بمعالج رسومات RTX 4080 وأداء عالي',
          price: 8999.0,
          image: 'https://via.placeholder.com/300x300?text=Gaming+PC',
          category: localizations.categoryComputers,
          rating: 4.7,
          reviewsCount: 156,
          featured: false,
        ),

        // Cameras
        Product(
          id: '',
          name: 'Canon EOS R6 Mark II',
          description: 'كاميرا احترافية بدقة عالية وتصوير فيديو 4K',
          price: 9999.0,
          originalPrice: 10999.0,
          image: 'https://via.placeholder.com/300x300?text=Canon+R6',
          category: localizations.categoryCameras,
          rating: 4.9,
          reviewsCount: 234,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sony Alpha A7 IV',
          description: 'كاميرا مرآة بدون مرآة بجودة تصوير استثنائية',
          price: 8799.0,
          image: 'https://via.placeholder.com/300x300?text=Sony+A7IV',
          category: localizations.categoryCameras,
          rating: 4.8,
          reviewsCount: 198,
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
      rethrow;
    }
  }

  /// Complete database setup
  static Future<void> initializeDatabase(BuildContext context) async {
    try {
      print('Starting database initialization...');

      await setupCategories(context);
      await setupSampleProducts(context);

      print('Database initialization completed successfully!');
    } catch (e) {
      print('Error during database initialization: $e');
      rethrow;
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
