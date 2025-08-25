import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'products';

  // جلب جميع المنتجات
  static Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('خطأ في جلب المنتجات: $e');
      // In a real app, you might want to throw an exception or return a custom error object.
      // For now, we return an empty list.
      return [];
    }
  }

  // جلب المنتجات المميزة
  static Future<List<Product>> getFeaturedProducts() async {
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
      print('خطأ في جلب المنتجات المميزة: $e');
      return [];
    }
  }

  // جلب المنتجات حسب الفئة
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('خطأ في جلب منتجات الفئة: $e');
      return [];
    }
  }

  // البحث في المنتجات
  static Future<List<Product>> searchProducts(String query) async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (product.category?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    } catch (e) {
      print('خطأ في البحث: $e');
      return [];
    }
  }

  // إضافة منتج جديد
  static Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection(_collection).add(product.toMap());
    } catch (e) {
      print('خطأ في إضافة المنتج: $e');
      throw Exception('فشل في إضافة المنتج');
    }
  }

  // تحديث منتج
  static Future<void> updateProduct(String id, Product product) async {
    try {
      await _firestore.collection(_collection).doc(id).update(product.toMap());
    } catch (e) {
      print('خطأ في تحديث المنتج: $e');
      throw Exception('فشل في تحديث المنتج');
    }
  }

  // حذف منتج
  static Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('خطأ في حذف المنتج: $e');
      throw Exception('فشل في حذف المنتج');
    }
  }

  // إنشاء بيانات تجريبية
  static Future<void> _createSampleProducts() async {
    final sampleProducts = [
      Product(
        id: 'iphone_15_pro',
        name: 'iPhone 15 Pro',
        description: 'أحدث هاتف من آبل مع معالج A17 Pro وكاميرا متطورة',
        price: 4999.0,
        originalPrice: 5499.0,
        image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
        category: 'هواتف',
        rating: 4.8,
        reviewsCount: 1250,
        featured: true,
        specifications: [
          'معالج A17 Pro',
          'ذاكرة 128GB',
          'كاميرا 48MP',
          'شاشة 6.1 بوصة',
          'مقاوم للماء IP68'
        ],
      ),
      Product(
        id: 'macbook_pro_m3',
        name: 'MacBook Pro M3',
        description: 'لابتوب احترافي بمعالج M3 للمطورين والمصممين',
        price: 8999.0,
        originalPrice: 9999.0,
        image: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400',
        category: 'حاسوب',
        rating: 4.9,
        reviewsCount: 890,
        featured: true,
        specifications: [
          'معالج Apple M3',
          'ذاكرة 16GB RAM',
          'تخزين 512GB SSD',
          'شاشة Retina 14 بوصة',
          'بطارية تدوم 18 ساعة'
        ],
      ),
      Product(
        id: 'airpods_pro_2',
        name: 'AirPods Pro الجيل الثاني',
        description: 'سماعات لاسلكية مع إلغاء الضوضاء النشط',
        price: 899.0,
        originalPrice: 999.0,
        image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
        category: 'سماعات',
        rating: 4.7,
        reviewsCount: 2100,
        featured: true,
        specifications: [
          'إلغاء الضوضاء النشط',
          'شريحة H2',
          'مقاومة للماء IPX4',
          'بطارية تدوم 30 ساعة',
          'شحن لاسلكي'
        ],
      ),
      Product(
        id: 'ipad_air_5',
        name: 'iPad Air الجيل الخامس',
        description: 'تابلت قوي ومتعدد الاستخدامات للعمل والترفيه',
        price: 2499.0,
        image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        category: 'تابلت',
        rating: 4.6,
        reviewsCount: 750,
        featured: false,
        specifications: [
          'معالج M1',
          'شاشة Liquid Retina 10.9 بوصة',
          'كاميرا 12MP',
          'دعم Apple Pencil',
          'متوفر بألوان متعددة'
        ],
      ),
      Product(
        id: 'apple_watch_9',
        name: 'Apple Watch Series 9',
        description: 'ساعة ذكية متطورة لتتبع الصحة واللياقة',
        price: 1599.0,
        image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400',
        category: 'ساعات',
        rating: 4.5,
        reviewsCount: 1800,
        featured: false,
        specifications: [
          'معالج S9 SiP',
          'شاشة Always-On Retina',
          'مقاومة للماء 50 متر',
          'تتبع معدل ضربات القلب',
          'GPS مدمج'
        ],
      ),
      Product(
        id: 'samsung_tv_75',
        name: 'Samsung QLED 75 بوصة',
        description: 'تلفزيون ذكي بدقة 4K وتقنية QLED',
        price: 3299.0,
        originalPrice: 3799.0,
        image: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400',
        category: 'تلفزيون',
        rating: 4.4,
        reviewsCount: 650,
        featured: false,
        specifications: [
          'دقة 4K UHD',
          'تقنية QLED',
          'نظام Tizen الذكي',
          'HDR10+',
          'أربعة منافذ HDMI'
        ],
      ),
      Product(
        id: 'sony_headphones',
        name: 'Sony WH-1000XM5',
        description: 'سماعات رأس لاسلكية مع إلغاء الضوضاء الرائد في الصناعة',
        price: 1299.0,
        image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
        category: 'سماعات',
        rating: 4.8,
        reviewsCount: 920,
        featured: true,
        specifications: [
          'إلغاء الضوضاء الرائد',
          'بطارية 30 ساعة',
          'شحن سريع',
          'صوت عالي الدقة',
          'مكالمات واضحة'
        ],
      ),
      Product(
        id: 'dell_laptop',
        name: 'Dell XPS 13',
        description: 'لابتوب نحيف وخفيف مثالي للأعمال والدراسة',
        price: 4599.0,
        image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
        category: 'حاسوب',
        rating: 4.3,
        reviewsCount: 540,
        featured: false,
        specifications: [
          'معالج Intel Core i7',
          'ذاكرة 16GB RAM',
          'تخزين 512GB SSD',
          'شاشة InfinityEdge 13.3 بوصة',
          'وزن 1.2 كيلو فقط'
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
      print('✅ تم إنشاء البيانات التجريبية بنجاح');
    } catch (e) {
      print('❌ خطأ في إنشاء البيانات التجريبية: $e');
    }
  }

  // بيانات افتراضية في حالة عدم توفر الاتصال
  static List<Product> _getDefaultProducts() {
    return [
      Product(
        id: 'default_1',
        name: 'iPhone 15 Pro',
        description: 'أحدث هاتف من آبل',
        price: 4999.0,
        category: 'هواتف',
        featured: true,
      ),
      Product(
        id: 'default_2',
        name: 'MacBook Pro',
        description: 'لابتوب احترافي',
        price: 8999.0,
        category: 'حاسوب',
        featured: true,
      ),
      Product(
        id: 'default_3',
        name: 'AirPods Pro',
        description: 'سماعات لاسلكية',
        price: 899.0,
        category: 'سماعات',
        featured: false,
      ),
    ];
  }

  // التحقق من الاتصال بـ Firestore
  static Future<bool> checkConnection() async {
    try {
      await _firestore.collection('test').doc('connection').get();
      return true;
    } catch (e) {
      return false;
    }
  }
}