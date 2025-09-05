import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../models/product.dart';

class SampleDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add categories
  Future<void> addCategories(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final categories = [
      {
        'name': localizations.categorySmartphones,
        'icon': 'smartphone',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop',
      },
      {
        'name': localizations.categoryComputers,
        'icon': 'computer',
        'image':
            'https://images.unsplash.com/photo-1547082299-de196ea013d6?w=300&h=300&fit=crop',
      },
      {
        'name': localizations.categoryTablets,
        'icon': 'tablet',
        'image':
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop',
      },
      {
        'name': localizations.categorySmartWatches,
        'icon': 'watch',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
      },
      {
        'name': localizations.categoryHeadphones,
        'icon': 'headphones',
        'image':
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
      },
      {
        'name': localizations.categoryAccessories,
        'icon': 'cable',
        'image':
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
      },
    ];

    for (var category in categories) {
      await _db.collection('categories').add(category);
    }
  }

  // Add many products with real images and reviews
  Future<void> addSampleProducts(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final products = [
      // Smartphones - 15 products
      Product(
        id: '',
        name: 'iPhone 15 Pro Max',
        description: localizations.productIphone15ProDesc,
        price: 2850000, // 2,850,000 Sudanese Pound
        originalPrice: 3200000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-max-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha&.v=1692845702708',
        category: localizations.categorySmartphones,
        featured: true,
        discount: 11,
        rating: 4.9,
        reviewsCount: 1247,
        specifications: [
          '6.7-inch Super Retina XDR display with ProMotion',
          'A17 Pro chip with 3nm technology',
          '48MP main camera with 5x optical zoom',
          '256GB storage',
          'IP68 water resistant',
          'MagSafe wireless charging',
          'All-day battery life',
          'iOS 17 system'
        ],
        reviews: [
          {
            'userName': 'Ahmed Mohamed - Khartoum',
            'rating': 5.0,
            'comment': 'Amazing phone, the camera is incredible and performance is very fast',
            'date': '2024-12-15'
          },
          {
            'userName': 'Fatima Ali - Khartoum North',
            'rating': 4.8,
            'comment': 'Excellent build quality, but the price is a bit high',
            'date': '2024-12-10'
          },
          {
            'userName': 'Mohamed Osman - Omdurman',
            'rating': 5.0,
            'comment': 'Best phone I have used, worth every penny',
            'date': '2024-12-08'
          }
        ],
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy S24 Ultra',
        description: localizations.productGalaxyS24UltraDesc,
        price: 780000,
        originalPrice: 850000,
        image:
            'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&h=400&fit=crop',
        category: localizations.categorySmartphones,
        featured: true,
        discount: 8,
        rating: 4.7,
        reviewsCount: 189,
        specifications: [
          '6.8-inch Dynamic AMOLED display',
          'Snapdragon 8 Gen 3 processor',
          '200MP camera',
          '512GB storage',
          'Built-in S Pen'
        ],
      ),
      Product(
        id: '',
        name: 'Google Pixel 8 Pro',
        description: localizations.productPixel8ProDesc,
        price: 650000,
        originalPrice: 720000,
        image:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop',
        category: localizations.categorySmartphones,
        featured: false,
        discount: 10,
        rating: 4.6,
        reviewsCount: 156,
        specifications: [
          '6.7-inch LTPO OLED display',
          'Google Tensor G3 processor',
          '50MP camera',
          '128GB storage',
          'Advanced night photography'
        ],
      ),
      Product(
        id: '',
        name: 'OnePlus 12',
        description: localizations.productOnePlus12Desc,
        price: 520000,
        originalPrice: 580000,
        image:
            'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=400&h=400&fit=crop',
        category: localizations.categorySmartphones,
        featured: false,
        discount: 10,
        rating: 4.5,
        reviewsCount: 134,
        specifications: [
          '6.82-inch AMOLED display',
          'Snapdragon 8 Gen 3 processor',
          '50MP camera',
          '256GB storage',
          '100W fast charging'
        ],
      ),

      // Computers
      Product(
        id: '',
        name: 'MacBook Pro 16 بوصة M3 Max',
        description: localizations.productMacBookPro16M3MaxDesc,
        price: 1850000,
        originalPrice: 2000000,
        image:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop',
        category: localizations.categoryComputers,
        featured: true,
        discount: 7,
        rating: 4.9,
        reviewsCount: 89,
        specifications: [
          '16.2-inch Liquid Retina XDR display',
          'Apple M3 Max processor',
          '36GB RAM',
          '1TB SSD storage',
          '22-hour battery life'
        ],
      ),
      Product(
        id: '',
        name: 'Dell XPS 15',
        description: localizations.productDellXps15Desc,
        price: 1200000,
        originalPrice: 1350000,
        image:
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop',
        category: localizations.categoryComputers,
        featured: true,
        discount: 11,
        rating: 4.6,
        reviewsCount: 67,
        specifications: [
          '15.6-inch 4K OLED display',
          'Intel Core i7-13700H processor',
          '32GB RAM',
          '1TB SSD storage',
          'RTX 4060 graphics card'
        ],
      ),

      // Tablets
      Product(
        id: '',
        name: 'iPad Pro 12.9 بوصة M2',
        description: localizations.productIpadProM2Desc,
        price: 980000,
        originalPrice: 1100000,
        image:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&h=400&fit=crop',
        category: localizations.categoryTablets,
        featured: true,
        discount: 11,
        rating: 4.8,
        reviewsCount: 156,
        specifications: [
          '12.9-inch Liquid Retina XDR display',
          'Apple M2 processor',
          '256GB storage',
          'Apple Pencil 2 support',
          '12MP camera'
        ],
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy Tab S9 Ultra',
        description: localizations.productGalaxyTabS9UltraDesc,
        price: 850000,
        originalPrice: 950000,
        image:
            'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=400&h=400&fit=crop',
        category: localizations.categoryTablets,
        featured: false,
        discount: 10,
        rating: 4.5,
        reviewsCount: 89,
        specifications: [
          '14.6-inch Super AMOLED display',
          'Snapdragon 8 Gen 2 processor',
          '512GB storage',
          'Built-in S Pen',
          'IP68 water resistant'
        ],
      ),

      // Smart watches
      Product(
        id: '',
        name: 'Apple Watch Series 9',
        description: localizations.productAppleWatchSeries9Desc,
        price: 320000,
        originalPrice: 380000,
        image:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop',
        category: localizations.categorySmartWatches,
        featured: true,
        discount: 16,
        rating: 4.7,
        reviewsCount: 234,
        specifications: [
          'Always-On Retina display',
          'S9 SiP processor',
          '50m water resistant',
          'Heart rate monitoring',
          'Built-in GPS'
        ],
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy Watch 6',
        description: localizations.productGalaxyWatch6Desc,
        price: 280000,
        originalPrice: 320000,
        image:
            'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400&h=400&fit=crop',
        category: localizations.categorySmartWatches,
        featured: false,
        discount: 12,
        rating: 4.4,
        reviewsCount: 167,
        specifications: [
          '1.5-inch Super AMOLED display',
          'Exynos W930 processor',
          'IP68 water resistant',
          'Advanced sleep tracking',
          '40-hour battery life'
        ],
      ),

      // Headphones
      Product(
        id: '',
        name: 'AirPods Pro 2',
        description: localizations.productAirPodsPro2Desc,
        price: 180000,
        originalPrice: 220000,
        image:
            'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=400&h=400&fit=crop',
        category: localizations.categoryHeadphones,
        featured: true,
        discount: 18,
        rating: 4.8,
        reviewsCount: 345,
        specifications: [
          'Active noise cancellation',
          'Spatial audio',
          'IPX4 water resistant',
          '30-hour battery life',
          'Wireless charging'
        ],
      ),
      Product(
        id: '',
        name: 'Sony WH-1000XM5',
        description: localizations.productSonyWH1000XM5Desc,
        price: 280000,
        originalPrice: 320000,
        image:
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400&h=400&fit=crop',
        category: localizations.categoryHeadphones,
        featured: true,
        discount: 14,
        rating: 4.9,
        reviewsCount: 189,
        specifications: [
          'Industry-leading noise cancellation',
          'High-resolution audio',
          '30-hour battery life',
          'Quick charging',
          'Touch controls'
        ],
      ),
    ];

    for (var product in products) {
      await _db.collection('products').add(product.toMap());
    }
  }

  // Add all sample data
  Future<void> addAllSampleData(BuildContext context) async {
    try {
      await addCategories(context);
      await addSampleProducts(context);
      print('✅ Sample data added successfully');
    } catch (e) {
      print('❌ Error adding sample data: $e');
      rethrow;
    }
  }
}
