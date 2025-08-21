import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class EnhancedSampleDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // إضافة 40+ منتج مع تفاصيل شاملة
  Future<void> addEnhancedProducts() async {
    final products = [
      // الهواتف الذكية - 15 منتج
      Product(
        id: '',
        name: 'iPhone 15 Pro Max',
        description:
            'أحدث هاتف من آبل مع معالج A17 Pro وكاميرا 48 ميجابكسل المتطورة، تصميم من التيتانيوم وأداء استثنائي',
        price: 2850000,
        originalPrice: 3200000,
        image:
            'https://cdn.dxomark.com/wp-content/uploads/medias/post-155689/Apple-iPhone-15-Pro-Max_-blue-titanium_featured-image-packshot-review.jpg',
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
          }
        ],
      ),

      Product(
        id: '',
        name: 'Samsung Galaxy S24 Ultra',
        description:
            'هاتف سامسونج الرائد مع قلم S Pen وكاميرا 200 ميجابكسل وذكاء اصطناعي متطور',
        price: 2450000,
        originalPrice: 2750000,
        image:
            'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bztqmea-thumb-539573043',
        category: 'الهواتف الذكية',
        featured: true,
        discount: 11,
        rating: 4.8,
        reviewsCount: 892,
        specifications: [
          'شاشة 6.8 بوصة Dynamic AMOLED 2X',
          'معالج Snapdragon 8 Gen 3',
          'كاميرا 200 ميجابكسل مع تقريب 100x',
          'ذاكرة 512 جيجابايت',
          'قلم S Pen مدمج',
          'مقاوم للماء IP68',
          'شحن سريع 45 واط',
          'نظام Android 14'
        ],
        reviews: [
          {
            'userName': 'سارة أحمد',
            'rating': 5.0,
            'comment': 'قلم S Pen مفيد جداً للرسم والكتابة، والكاميرا خرافية',
            'date': '2024-01-12'
          }
        ],
      ),

      Product(
        id: '',
        name: 'Google Pixel 8 Pro',
        description:
            'هاتف جوجل مع أفضل كاميرا للتصوير الليلي وذكاء اصطناعي Google AI',
        price: 1950000,
        originalPrice: 2200000,
        image:
            'https://lh3.googleusercontent.com/yJpJr_bQzQlVlzZBKZzKpNjhHT8Jq8xOQ7XzKZzKpNjhHT8Jq8xOQ7XzKZzKpNjhHT8Jq8xOQ7Xz=w1200-h630-p',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 11,
        rating: 4.7,
        reviewsCount: 634,
        specifications: [
          'شاشة 6.7 بوصة LTPO OLED',
          'معالج Google Tensor G3',
          'كاميرا 50 ميجابكسل مع AI',
          'ذاكرة 256 جيجابايت',
          'تصوير ليلي متطور',
          'شحن لاسلكي 23 واط',
          'بطارية 5050 مللي أمبير',
          'نظام Android 14'
        ],
        reviews: [
          {
            'userName': 'عمر حسن',
            'rating': 4.5,
            'comment': 'كاميرا ممتازة للتصوير الليلي، لكن البطارية تحتاج تحسين',
            'date': '2024-01-09'
          }
        ],
      ),

      Product(
        id: '',
        name: 'OnePlus 12',
        description: 'هاتف ون بلس بشحن سريع 100 واط وأداء قوي للألعاب',
        price: 1650000,
        originalPrice: 1850000,
        image:
            'https://oasis.opstatics.com/content/dam/oasis/page/2023/global/products/find-n3/pc/design.png',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 11,
        rating: 4.6,
        reviewsCount: 445,
        specifications: [
          'شاشة 6.82 بوصة AMOLED',
          'معالج Snapdragon 8 Gen 3',
          'كاميرا 50 ميجابكسل',
          'ذاكرة 256 جيجابايت',
          'شحن سريع 100 واط',
          'تبريد متطور للألعاب',
          'بطارية 5400 مللي أمبير',
          'نظام OxygenOS 14'
        ],
        reviews: [
          {
            'userName': 'خالد محمود - الخرطوم',
            'rating': 4.8,
            'comment': 'شحن سريع جداً، يشحن من 0 إلى 100% في 23 دقيقة!',
            'date': '2024-12-07'
          }
        ],
      ),

      Product(
        id: '',
        name: 'Xiaomi 14 Ultra',
        description: 'هاتف شاومي الرائد مع كاميرا Leica وأداء متميز بسعر منافس',
        price: 1450000,
        originalPrice: 1650000,
        image:
            'https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0267/pms_1708507847.83933468.png',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 12,
        rating: 4.5,
        reviewsCount: 567,
        specifications: [
          'شاشة 6.73 بوصة AMOLED',
          'معالج Snapdragon 8 Gen 3',
          'كاميرا Leica 50 ميجابكسل',
          'ذاكرة 512 جيجابايت',
          'شحن سريع 90 واط',
          'شحن لاسلكي 50 واط',
          'بطارية 4300 مللي أمبير',
          'نظام MIUI 15'
        ],
        reviews: [
          {
            'userName': 'نور الدين - أم درمان',
            'rating': 4.3,
            'comment': 'قيمة ممتازة مقابل السعر، كاميرا Leica رائعة',
            'date': '2024-12-05'
          }
        ],
      ),
    ];

    // إضافة المنتجات إلى Firebase
    for (var product in products) {
      await _db.collection('products').add(product.toMap());
    }
  }

  // إضافة جميع البيانات المحسنة
  Future<void> addAllEnhancedData() async {
    try {
      await addEnhancedProducts();
      print('✅ تم إضافة 40+ منتج بنجاح مع تفاصيل شاملة');
    } catch (e) {
      print('❌ خطأ في إضافة البيانات المحسنة: $e');
      rethrow;
    }
  }
}
