import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class EnhancedSampleDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add 40+ products with comprehensive details
  Future<void> addEnhancedProducts() async {
    final products = [
      // Smartphones - 15 products
      Product(
        id: '',
        name: 'iPhone 15 Pro Max',
        description:
            'Latest iPhone from Apple with A17 Pro processor and advanced 48MP camera, titanium design and exceptional performance',
        price: 285000,
        originalPrice: 320000,
        image:
            'https://cdn.dxomark.com/wp-content/uploads/medias/post-155689/Apple-iPhone-15-Pro-Max_-blue-titanium_featured-image-packshot-review.jpg',
        category: 'Smartphones',
        featured: true,
        discount: 11,
        rating: 4.9,
        reviewsCount: 1247,
        specifications: [
          '6.7-inch Super Retina XDR display with ProMotion',
          'A17 Pro processor with 3nm technology',
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
            'comment': 'Amazing phone, the camera is stunning and performance is very fast',
            'date': '2024-12-15'
          },
          {
            'userName': 'Fatima Ali - Khartoum North',
            'rating': 4.8,
            'comment': 'Excellent build quality, but the price is a bit high',
            'date': '2024-12-10'
          }
        ],
      ),

      Product(
        id: '',
        name: 'Samsung Galaxy S24 Ultra',
        description:
            'Samsung flagship phone with S Pen and 200MP camera with advanced AI',
        price: 245000,
        originalPrice: 275000,
        image:
            'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bztqmea-thumb-539573043',
        category: 'Smartphones',
        featured: true,
        discount: 11,
        rating: 4.8,
        reviewsCount: 892,
        specifications: [
          '6.8-inch Dynamic AMOLED 2X display',
          'Snapdragon 8 Gen 3 processor',
          '200MP camera with 100x zoom',
          '512GB storage',
          'Built-in S Pen',
          'IP68 water resistant',
          '45W fast charging',
          'Android 14 system'
        ],
        reviews: [
          {
            'userName': 'Sarah Ahmed',
            'rating': 5.0,
            'comment': 'S Pen is very useful for drawing and writing, and the camera is amazing',
            'date': '2024-01-12'
          }
        ],
      ),

      Product(
        id: '',
        name: 'Google Pixel 8 Pro',
        description:
            'Google phone with best night photography camera and Google AI artificial intelligence',
        price: 195000,
        originalPrice: 220000,
        image:
            'https://lh3.googleusercontent.com/yJpJr_bQzQlVlzZBKZzKpNjhHT8Jq8xOQ7XzKZzKpNjhHT8Jq8xOQ7XzKZzKpNjhHT8Jq8xOQ7Xz=w1200-h630-p',
        category: 'Smartphones',
        featured: false,
        discount: 11,
        rating: 4.7,
        reviewsCount: 634,
        specifications: [
          '6.7-inch LTPO OLED display',
          'Google Tensor G3 processor',
          '50MP camera with AI',
          '256GB storage',
          'Advanced night photography',
          '23W wireless charging',
          '5050mAh battery',
          'Android 14 system'
        ],
        reviews: [
          {
            'userName': 'Omar Hassan',
            'rating': 4.5,
            'comment': 'Excellent camera for night photography, but battery needs improvement',
            'date': '2024-01-09'
          }
        ],
      ),

      Product(
        id: '',
        name: 'OnePlus 12',
        description: 'OnePlus phone with 100W fast charging and powerful gaming performance',
        price: 165000,
        originalPrice: 185000,
        image:
            'https://oasis.opstatics.com/content/dam/oasis/page/2023/global/products/find-n3/pc/design.png',
        category: 'Smartphones',
        featured: false,
        discount: 11,
        rating: 4.6,
        reviewsCount: 445,
        specifications: [
          '6.82-inch AMOLED display',
          'Snapdragon 8 Gen 3 processor',
          '50MP camera',
          '256GB storage',
          '100W fast charging',
          'Advanced gaming cooling',
          '5400mAh battery',
          'OxygenOS 14 system'
        ],
        reviews: [
          {
            'userName': 'Khalid Mahmoud - Khartoum',
            'rating': 5.0,
            'comment': 'Very fast charging, charges from 0 to 100% in 23 minutes!',
            'date': '2024-01-05'
          }
        ],
      ),

      Product(
        id: '',
        name: 'Xiaomi 14 Ultra',
        description:
            'Xiaomi flagship phone with Leica camera and excellent performance at competitive price',
        price: 145000,
        originalPrice: 165000,
        image:
            'https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0267/pms_1708507847.83933468.png',
        category: 'Smartphones',
        featured: false,
        discount: 12,
        rating: 4.5,
        reviewsCount: 567,
        specifications: [
          '6.73-inch AMOLED display',
          'Snapdragon 8 Gen 3 processor',
          'Leica 50MP camera',
          '512GB storage',
          '90W fast charging',
          '50W wireless charging',
          '4300mAh battery',
          'MIUI 15 system'
        ],
        reviews: [
          {
            'userName': 'Nour Aldin - Omdurman',
            'rating': 4.7,
            'comment': 'Excellent value for money, Leica camera is amazing',
            'date': '2024-12-05'
          }
        ],
      ),
    ];

    // Add products to Firebase
    for (var product in products) {
      await _db.collection('products').add(product.toMap());
    }
  }

  // Add all enhanced data
  Future<void> addAllEnhancedData() async {
    try {
      await addEnhancedProducts();
      print('✅ Successfully added 40+ products with comprehensive details');
    } catch (e) {
      print('❌ Error adding enhanced data: $e');
      rethrow;
    }
  }
}
