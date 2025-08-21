import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class SampleDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // إضافة التصنيفات
  Future<void> addCategories() async {
    final categories = [
      {
        'name': 'الهواتف الذكية',
        'icon': 'smartphone',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop',
      },
      {
        'name': 'أجهزة الكمبيوتر',
        'icon': 'computer',
        'image':
            'https://images.unsplash.com/photo-1547082299-de196ea013d6?w=300&h=300&fit=crop',
      },
      {
        'name': 'الأجهزة اللوحية',
        'icon': 'tablet',
        'image':
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop',
      },
      {
        'name': 'الساعات الذكية',
        'icon': 'watch',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
      },
      {
        'name': 'السماعات',
        'icon': 'headphones',
        'image':
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
      },
      {
        'name': 'الكابلات والملحقات',
        'icon': 'cable',
        'image':
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
      },
    ];

    for (var category in categories) {
      await _db.collection('categories').add(category);
    }
  }

  // إضافة منتجات كثيرة مع صور حقيقية ومراجعات
  Future<void> addSampleProducts() async {
    final products = [
      // الهواتف الذكية - 15 منتج
      Product(
        id: '',
        name: 'iPhone 15 Pro Max',
        description:
            'أحدث هاتف من آبل مع معالج A17 Pro وكاميرا 48 ميجابكسل المتطورة، تصميم من التيتانيوم وأداء استثنائي',
        price: 2850000, // 2,850,000 جنيه سوداني
        originalPrice: 3200000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-max-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha&.v=1692845702708',
        category: 'الهواتف الذكية',
        featured: true,
        discount: 11,
        rating: 4.9,
        reviewsCount: 1247,
        specifications: [
          'شاشة 6.7 بوصة Super Retina XDR مع ProMotion',
          'معالج A17 Pro بتقنية 3 نانومتر',
          'كاميرا رئيسية 48 ميجابكسل مع تقريب بصري 5x',
          'ذاكرة تخزين 256 جيجابايت',
          'مقاوم للماء IP68',
          'شحن لاسلكي MagSafe',
          'بطارية تدوم طوال اليوم',
          'نظام iOS 17'
        ],
        reviews: [
          {
            'userName': 'أحمد محمد - الخرطوم',
            'rating': 5.0,
            'comment': 'هاتف رائع جداً، الكاميرا مذهلة والأداء سريع جداً',
            'date': '2024-12-15'
          },
          {
            'userName': 'فاطمة علي - الخرطوم بحري',
            'rating': 4.8,
            'comment': 'جودة البناء ممتازة، لكن السعر مرتفع قليلاً',
            'date': '2024-12-10'
          },
          {
            'userName': 'محمد عثمان - أم درمان',
            'rating': 5.0,
            'comment': 'أفضل هاتف استخدمته، يستحق كل قرش',
            'date': '2024-12-08'
          }
        ],
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy S24 Ultra',
        description: 'هاتف سامسونج الرائد مع قلم S Pen وكاميرا 200 ميجابكسل',
        price: 780000,
        originalPrice: 850000,
        image:
            'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&h=400&fit=crop',
        category: 'الهواتف الذكية',
        featured: true,
        discount: 8,
        rating: 4.7,
        reviewsCount: 189,
        specifications: [
          'شاشة 6.8 بوصة Dynamic AMOLED',
          'معالج Snapdragon 8 Gen 3',
          'كاميرا 200 ميجابكسل',
          'ذاكرة 512 جيجابايت',
          'قلم S Pen مدمج'
        ],
      ),
      Product(
        id: '',
        name: 'Google Pixel 8 Pro',
        description: 'هاتف جوجل مع أفضل كاميرا للتصوير الليلي وذكاء اصطناعي',
        price: 650000,
        originalPrice: 720000,
        image:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 10,
        rating: 4.6,
        reviewsCount: 156,
        specifications: [
          'شاشة 6.7 بوصة LTPO OLED',
          'معالج Google Tensor G3',
          'كاميرا 50 ميجابكسل',
          'ذاكرة 128 جيجابايت',
          'تصوير ليلي متطور'
        ],
      ),
      Product(
        id: '',
        name: 'OnePlus 12',
        description: 'هاتف ون بلس بشحن سريع 100 واط وأداء قوي',
        price: 520000,
        originalPrice: 580000,
        image:
            'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=400&h=400&fit=crop',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 10,
        rating: 4.5,
        reviewsCount: 134,
        specifications: [
          'شاشة 6.82 بوصة AMOLED',
          'معالج Snapdragon 8 Gen 3',
          'كاميرا 50 ميجابكسل',
          'ذاكرة 256 جيجابايت',
          'شحن سريع 100 واط'
        ],
      ),

      // أجهزة الكمبيوتر
      Product(
        id: '',
        name: 'MacBook Pro 16 بوصة M3 Max',
        description: 'لابتوب آبل الاحترافي مع معالج M3 Max للمصممين والمطورين',
        price: 1850000,
        originalPrice: 2000000,
        image:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop',
        category: 'أجهزة الكمبيوتر',
        featured: true,
        discount: 7,
        rating: 4.9,
        reviewsCount: 89,
        specifications: [
          'شاشة 16.2 بوصة Liquid Retina XDR',
          'معالج Apple M3 Max',
          'ذاكرة عشوائية 36 جيجابايت',
          'تخزين 1 تيرابايت SSD',
          'بطارية تدوم 22 ساعة'
        ],
      ),
      Product(
        id: '',
        name: 'Dell XPS 15',
        description: 'لابتوب ديل الاحترافي مع شاشة 4K وأداء قوي',
        price: 1200000,
        originalPrice: 1350000,
        image:
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop',
        category: 'أجهزة الكمبيوتر',
        featured: true,
        discount: 11,
        rating: 4.6,
        reviewsCount: 67,
        specifications: [
          'شاشة 15.6 بوصة 4K OLED',
          'معالج Intel Core i7-13700H',
          'ذاكرة عشوائية 32 جيجابايت',
          'تخزين 1 تيرابايت SSD',
          'كارت جرافيك RTX 4060'
        ],
      ),

      // الأجهزة اللوحية
      Product(
        id: '',
        name: 'iPad Pro 12.9 بوصة M2',
        description: 'جهاز آيباد الاحترافي مع معالج M2 وشاشة Liquid Retina XDR',
        price: 980000,
        originalPrice: 1100000,
        image:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&h=400&fit=crop',
        category: 'الأجهزة اللوحية',
        featured: true,
        discount: 11,
        rating: 4.8,
        reviewsCount: 156,
        specifications: [
          'شاشة 12.9 بوصة Liquid Retina XDR',
          'معالج Apple M2',
          'ذاكرة 256 جيجابايت',
          'دعم Apple Pencil 2',
          'كاميرا 12 ميجابكسل'
        ],
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy Tab S9 Ultra',
        description: 'جهاز لوحي من سامسونج بشاشة كبيرة وقلم S Pen',
        price: 850000,
        originalPrice: 950000,
        image:
            'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=400&h=400&fit=crop',
        category: 'الأجهزة اللوحية',
        featured: false,
        discount: 10,
        rating: 4.5,
        reviewsCount: 89,
        specifications: [
          'شاشة 14.6 بوصة Super AMOLED',
          'معالج Snapdragon 8 Gen 2',
          'ذاكرة 512 جيجابايت',
          'قلم S Pen مدمج',
          'مقاوم للماء IP68'
        ],
      ),

      // الساعات الذكية
      Product(
        id: '',
        name: 'Apple Watch Series 9',
        description: 'ساعة آبل الذكية مع مستشعرات صحية متطورة',
        price: 320000,
        originalPrice: 380000,
        image:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop',
        category: 'الساعات الذكية',
        featured: true,
        discount: 16,
        rating: 4.7,
        reviewsCount: 234,
        specifications: [
          'شاشة Always-On Retina',
          'معالج S9 SiP',
          'مقاوم للماء 50 متر',
          'مراقبة معدل ضربات القلب',
          'GPS مدمج'
        ],
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy Watch 6',
        description: 'ساعة سامسونج الذكية مع تتبع صحي شامل',
        price: 280000,
        originalPrice: 320000,
        image:
            'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400&h=400&fit=crop',
        category: 'الساعات الذكية',
        featured: false,
        discount: 12,
        rating: 4.4,
        reviewsCount: 167,
        specifications: [
          'شاشة 1.5 بوصة Super AMOLED',
          'معالج Exynos W930',
          'مقاوم للماء IP68',
          'تتبع النوم المتطور',
          'بطارية تدوم 40 ساعة'
        ],
      ),

      // السماعات
      Product(
        id: '',
        name: 'AirPods Pro 2',
        description: 'سماعات آبل اللاسلكية مع إلغاء الضوضاء النشط',
        price: 180000,
        originalPrice: 220000,
        image:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop',
        category: 'السماعات',
        featured: true,
        discount: 18,
        rating: 4.8,
        reviewsCount: 345,
        specifications: [
          'إلغاء الضوضاء النشط',
          'صوت مكاني',
          'مقاوم للماء IPX4',
          'بطارية تدوم 30 ساعة',
          'شحن لاسلكي'
        ],
      ),
      Product(
        id: '',
        name: 'Sony WH-1000XM5',
        description: 'سماعات سوني الاحترافية مع أفضل إلغاء ضوضاء',
        price: 250000,
        originalPrice: 290000,
        image:
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400&h=400&fit=crop',
        category: 'السماعات',
        featured: true,
        discount: 14,
        rating: 4.9,
        reviewsCount: 189,
        specifications: [
          'إلغاء ضوضاء رائد في الصناعة',
          'صوت عالي الدقة',
          'بطارية تدوم 30 ساعة',
          'شحن سريع',
          'تحكم باللمس'
        ],
      ),
    ];

    for (var product in products) {
      await _db.collection('products').add(product.toMap());
    }
  }

  // إضافة جميع البيانات التجريبية
  Future<void> addAllSampleData() async {
    try {
      await addCategories();
      await addSampleProducts();
      print('✅ تم إضافة جميع البيانات التجريبية بنجاح');
    } catch (e) {
      print('❌ خطأ في إضافة البيانات: $e');
      rethrow;
    }
  }
}
