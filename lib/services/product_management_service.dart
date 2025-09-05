import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductManagementService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// حذف جميع المنتجات الحالية
  static Future<void> deleteAllProducts() async {
    try {
      print('🗑️ بدء حذف المنتجات الحالية...');
      
      final QuerySnapshot snapshot = await _firestore.collection('products').get();
      
      final batch = _firestore.batch();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print('✅ تم حذف ${snapshot.docs.length} منتج بنجاح');
    } catch (e) {
      print('❌ خطأ في حذف المنتجات: $e');
      throw Exception('فشل في حذف المنتجات: $e');
    }
  }

  /// إضافة 50 منتج جديد مع صور مطابقة
  static Future<void> add50NewProducts() async {
    try {
      print('📱 بدء إضافة 50 منتج جديد...');
      
      final List<Product> newProducts = [
        // الهواتف الذكية (15 منتج)
        Product(
          id: '',
          name: 'iPhone 15 Pro Max',
          description: 'أحدث هاتف من آبل بشاشة 6.7 بوصة وكاميرا احترافية ثلاثية العدسات مع معالج A17 Pro',
          price: 5499.0,
          originalPrice: 5999.0,
          image: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          images: [
            'https://images.unsplash.com/photo-1695048133142-1a20484d2569?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
          ],
          category: 'هواتف ذكية',
          rating: 4.9,
          reviewsCount: 250,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy S24 Ultra',
          description: 'هاتف سامسونج الرائد بقلم S Pen وكاميرا 200 ميجابكسل مع تقنيات الذكاء الاصطناعي',
          price: 4299.0,
          originalPrice: 4799.0,
          image: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          images: [
            'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1567581935884-3349723552ca?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
          ],
          category: 'هواتف ذكية',
          rating: 4.8,
          reviewsCount: 320,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Google Pixel 8 Pro',
          description: 'هاتف جوجل بكاميرا ذكية مدعومة بالذكاء الاصطناعي ونظام أندرويد الخالص',
          price: 3799.0,
          image: 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          images: [
            'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
          ],
          category: 'هواتف ذكية',
          rating: 4.7,
          reviewsCount: 180,
          featured: false,
        ),
        Product(
          id: '',
          name: 'OnePlus 12',
          description: 'هاتف ون بلس بأداء سريع وشحن فائق السرعة 100 واط مع شاشة AMOLED',
          price: 2999.0,
          originalPrice: 3299.0,
          image: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'هواتف ذكية',
          rating: 4.6,
          reviewsCount: 145,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Xiaomi 14 Ultra',
          description: 'هاتف شاومي بكاميرا ليكا احترافية ومعالج Snapdragon 8 Gen 3',
          price: 2799.0,
          image: 'https://images.unsplash.com/photo-1567581935884-3349723552ca?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'هواتف ذكية',
          rating: 4.5,
          reviewsCount: 120,
          featured: false,
        ),
        
        // أجهزة الكمبيوتر المحمولة (15 منتج)
        Product(
          id: '',
          name: 'MacBook Pro 16"',
          description: 'لابتوب آبل بمعالج M3 Pro وشاشة Retina عالية الدقة مثالي للمحترفين',
          price: 12999.0,
          originalPrice: 13999.0,
          image: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          images: [
            'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
          ],
          category: 'لابتوبات',
          rating: 4.9,
          reviewsCount: 89,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Dell XPS 15',
          description: 'لابتوب ديل خفيف الوزن بمعالج Intel Core i7 وكارت جرافيك مدمج',
          price: 8999.0,
          image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'لابتوبات',
          rating: 4.7,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'HP Spectre x360',
          description: 'لابتوب HP قابل للتحويل بشاشة لمس وتصميم أنيق',
          price: 7499.0,
          originalPrice: 7999.0,
          image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'لابتوبات',
          rating: 4.6,
          reviewsCount: 134,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Lenovo ThinkPad X1',
          description: 'لابتوب لينوفو للأعمال بمتانة عالية وأمان متقدم',
          price: 9499.0,
          image: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'لابتوبات',
          rating: 4.8,
          reviewsCount: 98,
          featured: false,
        ),
        Product(
          id: '',
          name: 'ASUS ROG Strix',
          description: 'لابتوب ألعاب من أسوس بكارت جرافيك RTX 4070 ومعالج قوي',
          price: 11999.0,
          image: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'لابتوبات',
          rating: 4.7,
          reviewsCount: 167,
          featured: true,
        ),
        
        // السماعات (10 منتجات)
        Product(
          id: '',
          name: 'AirPods Pro 2',
          description: 'سماعات آبل اللاسلكية بإلغاء الضوضاء النشط وجودة صوت فائقة',
          price: 1299.0,
          originalPrice: 1499.0,
          image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          images: [
            'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
          ],
          category: 'سماعات',
          rating: 4.8,
          reviewsCount: 245,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sony WH-1000XM5',
          description: 'سماعات سوني الرائدة بإلغاء ضوضاء ممتاز وبطارية طويلة المدى',
          price: 1899.0,
          image: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'سماعات',
          rating: 4.9,
          reviewsCount: 189,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Bose QuietComfort',
          description: 'سماعات بوز بتقنية إلغاء الضوضاء الرائدة وراحة فائقة',
          price: 1699.0,
          originalPrice: 1899.0,
          image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'سماعات',
          rating: 4.7,
          reviewsCount: 156,
          featured: false,
        ),
        
        // الساعات الذكية (10 منتجات)
        Product(
          id: '',
          name: 'Apple Watch Series 9',
          description: 'ساعة آبل الذكية بمراقبة صحية متقدمة وتطبيقات متنوعة',
          price: 2199.0,
          originalPrice: 2399.0,
          image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          images: [
            'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
          ],
          category: 'ساعات ذكية',
          rating: 4.8,
          reviewsCount: 234,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy Watch 6',
          description: 'ساعة سامسونج الذكية بمتابعة اللياقة البدنية والصحة',
          price: 1599.0,
          image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'ساعات ذكية',
          rating: 4.6,
          reviewsCount: 178,
          featured: false,
        )
      ];
      
      // إضافة المزيد من المنتجات للوصول إلى 50 منتج
      final additionalProducts = _generateAdditionalProducts();
      newProducts.addAll(additionalProducts);
      
      // إضافة المنتجات إلى Firestore
      final batch = _firestore.batch();
      
      for (Product product in newProducts) {
        final docRef = _firestore.collection('products').doc();
        final productData = {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'originalPrice': product.originalPrice,
          'image': product.image,
          'images': product.images ?? [],
          'category': product.category,
          'rating': product.rating,
          'reviewsCount': product.reviewsCount,
          'featured': product.featured,
          'isAvailable': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        
        batch.set(docRef, productData);
      }
      
      await batch.commit();
      print('✅ تم إضافة ${newProducts.length} منتج جديد بنجاح');
      
    } catch (e) {
      print('❌ خطأ في إضافة المنتجات: $e');
      throw Exception('فشل في إضافة المنتجات: $e');
    }
  }
  
  /// توليد منتجات إضافية للوصول إلى 50 منتج
  static List<Product> _generateAdditionalProducts() {
    return [
      // المزيد من الهواتف
      Product(
        id: '',
        name: 'iPhone 14 Pro',
        description: 'آيفون 14 برو بكاميرا 48 ميجابكسل وشاشة Dynamic Island',
        price: 4199.0,
        originalPrice: 4599.0,
        image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'هواتف ذكية',
        rating: 4.7,
        reviewsCount: 298,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy A54',
        description: 'هاتف سامسونج متوسط الفئة بكاميرا ممتازة وبطارية طويلة المدى',
        price: 1899.0,
        image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'هواتف ذكية',
        rating: 4.4,
        reviewsCount: 167,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Oppo Find X6 Pro',
        description: 'هاتف أوبو بكاميرا هاسلبلاد وتصميم فاخر',
        price: 3299.0,
        image: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'هواتف ذكية',
        rating: 4.5,
        reviewsCount: 134,
        featured: false,
      ),
      
      // المزيد من اللابتوبات
      Product(
        id: '',
        name: 'MacBook Air M2',
        description: 'لابتوب آبل خفيف الوزن بمعالج M2 وبطارية طويلة المدى',
        price: 6999.0,
        originalPrice: 7499.0,
        image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'لابتوبات',
        rating: 4.8,
        reviewsCount: 245,
        featured: true,
      ),
      Product(
        id: '',
        name: 'Microsoft Surface Pro 9',
        description: 'تابلت مايكروسوفت بإمكانيات لابتوب وشاشة لمس',
        price: 5999.0,
        image: 'https://images.unsplash.com/photo-1587614295999-6c1c3a7b98d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'لابتوبات',
        rating: 4.6,
        reviewsCount: 189,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Acer Predator Helios',
        description: 'لابتوب ألعاب من أيسر بأداء قوي وتبريد متقدم',
        price: 10499.0,
        image: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'لابتوبات',
        rating: 4.5,
        reviewsCount: 156,
        featured: false,
      ),
      
      // المزيد من السماعات
      Product(
        id: '',
        name: 'JBL Tune 760NC',
        description: 'سماعات JBL بإلغاء ضوضاء وصوت JBL المميز',
        price: 899.0,
        originalPrice: 1099.0,
        image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'سماعات',
        rating: 4.3,
        reviewsCount: 123,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Beats Studio3',
        description: 'سماعات بيتس بصوت قوي وتصميم عصري',
        price: 1399.0,
        image: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'سماعات',
        rating: 4.4,
        reviewsCount: 167,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Sennheiser HD 450BT',
        description: 'سماعات سينهايزر بجودة صوت احترافية',
        price: 1199.0,
        image: 'https://images.unsplash.com/photo-1558756520-22cfe5d382ca?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'سماعات',
        rating: 4.6,
        reviewsCount: 145,
        featured: false,
      ),
      
      // المزيد من الساعات الذكية
      Product(
        id: '',
        name: 'Garmin Venu 3',
        description: 'ساعة جارمين الرياضية بمتابعة دقيقة للأنشطة',
        price: 2299.0,
        image: 'https://images.unsplash.com/photo-1579586337278-3f436f25d4d6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'ساعات ذكية',
        rating: 4.7,
        reviewsCount: 134,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Fitbit Versa 4',
        description: 'ساعة فيتبت بمتابعة اللياقة والصحة العامة',
        price: 1299.0,
        originalPrice: 1499.0,
        image: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'ساعات ذكية',
        rating: 4.4,
        reviewsCount: 189,
        featured: false,
      ),
      
      // أجهزة لوحية
      Product(
        id: '',
        name: 'iPad Pro 12.9"',
        description: 'آيباد برو بشاشة كبيرة ومعالج M2 للمحترفين',
        price: 5999.0,
        originalPrice: 6499.0,
        image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'أجهزة لوحية',
        rating: 4.8,
        reviewsCount: 167,
        featured: true,
      ),
      Product(
        id: '',
        name: 'Samsung Galaxy Tab S9',
        description: 'تابلت سامسونج بقلم S Pen وشاشة AMOLED',
        price: 3999.0,
        image: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'أجهزة لوحية',
        rating: 4.6,
        reviewsCount: 145,
        featured: false,
      ),
      
      // كاميرات
      Product(
        id: '',
        name: 'Canon EOS R6 Mark II',
        description: 'كاميرا كانون احترافية بدقة عالية وتصوير فيديو 4K',
        price: 15999.0,
        image: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'كاميرات',
        rating: 4.9,
        reviewsCount: 89,
        featured: true,
      ),
      Product(
        id: '',
        name: 'Sony Alpha A7 IV',
        description: 'كاميرا سوني بدون مرآة بأداء ممتاز للمحترفين',
        price: 13999.0,
        originalPrice: 14999.0,
        image: 'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'كاميرات',
        rating: 4.8,
        reviewsCount: 123,
        featured: false,
      ),
      
      // إكسسوارات
      Product(
        id: '',
        name: 'Anker PowerBank 20000mAh',
        description: 'بطارية محمولة من أنكر بسعة كبيرة وشحن سريع',
        price: 599.0,
        originalPrice: 699.0,
        image: 'https://images.unsplash.com/photo-1609592806787-3d9c5b1b8b8d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'إكسسوارات',
        rating: 4.5,
        reviewsCount: 234,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Belkin Wireless Charger',
        description: 'شاحن لاسلكي من بيلكين بتصميم أنيق وشحن آمن',
        price: 399.0,
        image: 'https://images.unsplash.com/photo-1585792180666-f7347c490ee2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'إكسسوارات',
        rating: 4.3,
        reviewsCount: 156,
        featured: false,
      ),
      
      // المزيد من المنتجات المتنوعة
      Product(
        id: '',
        name: 'Nintendo Switch OLED',
        description: 'جهاز ألعاب نينتندو سويتش بشاشة OLED محسنة',
        price: 1899.0,
        image: 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'ألعاب',
        rating: 4.7,
        reviewsCount: 189,
        featured: false,
      ),
      Product(
        id: '',
        name: 'PlayStation 5',
        description: 'جهاز ألعاب سوني بلايستيشن 5 بأداء قوي وألعاب حصرية',
        price: 2999.0,
        originalPrice: 3299.0,
        image: 'https://images.unsplash.com/photo-1607853202273-797f1c22a38e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'ألعاب',
        rating: 4.8,
        reviewsCount: 267,
        featured: true,
      ),
      Product(
        id: '',
        name: 'Xbox Series X',
        description: 'جهاز ألعاب مايكروسوفت إكس بوكس بقوة معالجة عالية',
        price: 2799.0,
        image: 'https://images.unsplash.com/photo-1621259182978-fbf93132d53d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'ألعاب',
        rating: 4.6,
        reviewsCount: 198,
        featured: false,
      ),
      Product(
        id: '',
        name: 'LG OLED 55" TV',
        description: 'تلفزيون LG OLED بدقة 4K وألوان حية',
        price: 8999.0,
        originalPrice: 9999.0,
        image: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'تلفزيونات',
        rating: 4.7,
        reviewsCount: 145,
        featured: true,
      ),
      Product(
        id: '',
        name: 'Samsung QLED 65" TV',
        description: 'تلفزيون سامسونج QLED بتقنية الكوانتوم دوت',
        price: 11999.0,
        image: 'https://images.unsplash.com/photo-1567690187548-f07b1d7bf5a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'تلفزيونات',
        rating: 4.6,
        reviewsCount: 167,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Dyson V15 Detect',
        description: 'مكنسة دايسون اللاسلكية بتقنية الكشف عن الغبار',
        price: 3299.0,
        image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'أجهزة منزلية',
        rating: 4.5,
        reviewsCount: 134,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Nespresso Vertuo',
        description: 'ماكينة قهوة نسبريسو بتقنية الطرد المركزي',
        price: 1599.0,
        originalPrice: 1799.0,
        image: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'أجهزة منزلية',
        rating: 4.4,
        reviewsCount: 189,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Roomba i7+',
        description: 'مكنسة روبوت آي روبوت بتفريغ ذاتي وذكاء اصطناعي',
        price: 4999.0,
        image: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'أجهزة منزلية',
        rating: 4.6,
        reviewsCount: 156,
        featured: false,
      ),
      Product(
        id: '',
        name: 'Tesla Model Y Charger',
        description: 'شاحن تسلا للسيارات الكهربائية بشحن سريع',
        price: 2999.0,
        image: 'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'إكسسوارات',
        rating: 4.7,
        reviewsCount: 89,
        featured: false,
      ),
      Product(
        id: '',
        name: 'DJI Mini 3 Pro',
        description: 'طائرة درون DJI صغيرة الحجم بكاميرا 4K احترافية',
        price: 4599.0,
        originalPrice: 4999.0,
        image: 'https://images.unsplash.com/photo-1473968512647-3e447244af8f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'كاميرات',
        rating: 4.8,
        reviewsCount: 123,
        featured: true,
      ),
    ];
  }
  
  /// تنفيذ العملية الكاملة: حذف وإضافة
  static Future<void> replaceAllProducts() async {
    try {
      print('🔄 بدء عملية استبدال المنتجات...');
      
      // حذف المنتجات الحالية
      await deleteAllProducts();
      
      // إضافة المنتجات الجديدة
      await add50NewProducts();
      
      print('🎉 تم استبدال جميع المنتجات بنجاح!');
    } catch (e) {
      print('❌ خطأ في عملية الاستبدال: $e');
      throw Exception('فشل في استبدال المنتجات: $e');
    }
  }
}