import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBvOkBjop2n6fcI_XnxQQhHI4zOKs7BrCE",
          authDomain: "gizmostore-2a3ff.firebaseapp.com",
          projectId: "gizmostore-2a3ff",
          storageBucket: "gizmostore-2a3ff.appspot.com",
          messagingSenderId: "123456789",
          appId: "1:123456789:web:abcdef123456"),
    );

    print('🔄 بدء استعادة المنتجات القديمة مع الصور...');

    // حذف المنتجات الحالية
    await deleteAllProducts();
    print('🗑️ تم حذف المنتجات الحالية');

    // حذف الفئات الحالية
    await deleteAllCategories();
    print('🗑️ تم حذف الفئات الحالية');

    // إضافة الفئات الجديدة
    await addCategories();
    print('📂 تم إضافة الفئات الجديدة');

    // إضافة المنتجات مع الصور
    await addProductsWithImages();
    print('📱 تم إضافة المنتجات مع الصور');

    print('✅ تمت استعادة جميع المنتجات بنجاح!');
    print('📊 المنتجات المضافة:');
    print('   📱 هواتف ذكية: 5 منتجات');
    print('   💻 لابتوبات: 4 منتجات');
    print('   📟 أجهزة لوحية: 3 منتجات');
    print('   ⌚ ساعات ذكية: 3 منتجات');
    print('   🎧 سماعات: 4 منتجات');
    print('   🔌 إكسسوارات: 5 منتجات');

    exit(0);
  } catch (e) {
    print('❌ خطأ في استعادة المنتجات: $e');
    exit(1);
  }
}

// حذف جميع المنتجات
Future<void> deleteAllProducts() async {
  try {
    final firestore = FirebaseFirestore.instance;
    final products = await firestore.collection('products').get();

    for (final doc in products.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    print('تحذير: لم يتم حذف المنتجات السابقة - $e');
  }
}

// حذف جميع الفئات
Future<void> deleteAllCategories() async {
  try {
    final firestore = FirebaseFirestore.instance;
    final categories = await firestore.collection('categories').get();

    for (final doc in categories.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    print('تحذير: لم يتم حذف الفئات السابقة - $e');
  }
}

// إضافة الفئات
Future<void> addCategories() async {
  final firestore = FirebaseFirestore.instance;

  final categories = [
    {
      'name': 'هواتف ذكية',
      'nameEn': 'Smartphones',
      'icon': 'smartphone',
      'image':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop',
      'productCount': 0,
    },
    {
      'name': 'لابتوبات',
      'nameEn': 'Laptops',
      'icon': 'laptop',
      'image':
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop',
      'productCount': 0,
    },
    {
      'name': 'أجهزة لوحية',
      'nameEn': 'Tablets',
      'icon': 'tablet',
      'image':
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop',
      'productCount': 0,
    },
    {
      'name': 'ساعات ذكية',
      'nameEn': 'Smart Watches',
      'icon': 'watch',
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
      'productCount': 0,
    },
    {
      'name': 'سماعات',
      'nameEn': 'Headphones',
      'icon': 'headphones',
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
      'productCount': 0,
    },
    {
      'name': 'إكسسوارات',
      'nameEn': 'Accessories',
      'icon': 'accessories',
      'image':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
      'productCount': 0,
    },
  ];

  for (final category in categories) {
    await firestore.collection('categories').add(category);
  }
}

// إضافة المنتجات مع الصور
Future<void> addProductsWithImages() async {
  final firestore = FirebaseFirestore.instance;

  final products = [
    // هواتف ذكية
    {
      'name': 'iPhone 15 Pro Max',
      'nameAr': 'آيفون 15 برو ماكس',
      'description': 'أحدث هاتف من آبل بمعالج A17 Pro وكاميرا متطورة',
      'price': 1299000.0,
      'originalPrice': 1499000.0,
      'image':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-7inch-naturaltitanium?wid=5120&hei=2880&fmt=p-jpg&qlt=80&.v=1692895395658',
      'category': 'هواتف ذكية',
      'categoryEn': 'Smartphones',
      'brand': 'Apple',
      'brandAr': 'آبل',
      'featured': true,
      'discount': 13,
      'rating': 4.8,
      'reviewsCount': 245,
      'inStock': true,
      'stockQuantity': 25,
    },
    {
      'name': 'Samsung Galaxy S24 Ultra',
      'nameAr': 'سامسونج جالاكسي S24 ألترا',
      'description': 'هاتف سامسونج الرائد بقلم S Pen وكاميرا 200MP',
      'price': 1199000.0,
      'originalPrice': 1399000.0,
      'image':
          'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bzkeegy-thumb-539573043?\$344_344_PNG\$',
      'category': 'هواتف ذكية',
      'categoryEn': 'Smartphones',
      'brand': 'Samsung',
      'brandAr': 'سامسونج',
      'featured': true,
      'discount': 14,
      'rating': 4.7,
      'reviewsCount': 189,
      'inStock': true,
      'stockQuantity': 30,
    },
    {
      'name': 'Google Pixel 8 Pro',
      'nameAr': 'جوجل بيكسل 8 برو',
      'description': 'هاتف جوجل بذكاء اصطناعي متقدم وكاميرا احترافية',
      'price': 899000.0,
      'originalPrice': 1099000.0,
      'image':
          'https://lh3.googleusercontent.com/yLBzx3qWNE8U8KvKGKjKQXLgHj8AR-wOhgOCdVGF8_Q',
      'category': 'هواتف ذكية',
      'categoryEn': 'Smartphones',
      'brand': 'Google',
      'brandAr': 'جوجل',
      'featured': false,
      'discount': 18,
      'rating': 4.6,
      'reviewsCount': 156,
      'inStock': true,
      'stockQuantity': 20,
    },
    {
      'name': 'OnePlus 12',
      'nameAr': 'ون بلس 12',
      'description': 'هاتف ون بلس بأداء عالي وشحن سريع',
      'price': 749000.0,
      'originalPrice': 899000.0,
      'image':
          'https://oasis.opstatics.com/content/dam/oasis/page/2024/global/products/12/specs/green-img.png',
      'category': 'هواتف ذكية',
      'categoryEn': 'Smartphones',
      'brand': 'OnePlus',
      'brandAr': 'ون بلس',
      'featured': false,
      'discount': 17,
      'rating': 4.5,
      'reviewsCount': 98,
      'inStock': true,
      'stockQuantity': 15,
    },
    {
      'name': 'Xiaomi 14 Ultra',
      'nameAr': 'شاومي 14 ألترا',
      'description': 'هاتف شاومي بكاميرا Leica وأداء متميز',
      'price': 649000.0,
      'originalPrice': 799000.0,
      'image':
          'https://i02.appmifile.com/mi-com-product/fly-birds/xiaomi-14-ultra/pc/7b0b2b2b2b2b2b2b2b2b2b2b2b2b2b2b.png',
      'category': 'هواتف ذكية',
      'categoryEn': 'Smartphones',
      'brand': 'Xiaomi',
      'brandAr': 'شاومي',
      'featured': true,
      'discount': 19,
      'rating': 4.4,
      'reviewsCount': 134,
      'inStock': true,
      'stockQuantity': 22,
    },

    // لابتوبات
    {
      'name': 'MacBook Pro 16"',
      'nameAr': 'ماك بوك برو 16 بوصة',
      'description': 'لابتوب آبل بمعالج M3 Max وشاشة Retina',
      'price': 2499000.0,
      'originalPrice': 2799000.0,
      'image':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp16-spacegray-select-202310?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1697311054290',
      'category': 'لابتوبات',
      'categoryEn': 'Laptops',
      'brand': 'Apple',
      'brandAr': 'آبل',
      'featured': true,
      'discount': 11,
      'rating': 4.9,
      'reviewsCount': 87,
      'inStock': true,
      'stockQuantity': 8,
    },
    {
      'name': 'Dell XPS 15',
      'nameAr': 'ديل XPS 15',
      'description': 'لابتوب ديل بمعالج Intel Core i7 وكارت RTX',
      'price': 1799000.0,
      'originalPrice': 2099000.0,
      'image':
          'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/notebook-xps-15-9530-nt-blue-gallery-4.psd?fmt=pjpg&pscan=auto&scl=1&wid=3491&hei=2400&qlt=100,1&resMode=sharp2&size=3491,2400&chrss=full&imwidth=5000',
      'category': 'لابتوبات',
      'categoryEn': 'Laptops',
      'brand': 'Dell',
      'brandAr': 'ديل',
      'featured': false,
      'discount': 14,
      'rating': 4.6,
      'reviewsCount': 65,
      'inStock': true,
      'stockQuantity': 12,
    },
    {
      'name': 'HP Spectre x360',
      'nameAr': 'HP سبيكتر x360',
      'description': 'لابتوب HP قابل للتحويل بشاشة لمس',
      'price': 1399000.0,
      'originalPrice': 1699000.0,
      'image':
          'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c08140748.png',
      'category': 'لابتوبات',
      'categoryEn': 'Laptops',
      'brand': 'HP',
      'brandAr': 'HP',
      'featured': false,
      'discount': 18,
      'rating': 4.4,
      'reviewsCount': 43,
      'inStock': true,
      'stockQuantity': 10,
    },
    {
      'name': 'ASUS ROG Strix',
      'nameAr': 'أسوس ROG ستريكس',
      'description': 'لابتوب ألعاب بمعالج AMD Ryzen وكارت RTX 4070',
      'price': 1899000.0,
      'originalPrice': 2199000.0,
      'image':
          'https://dlcdnwebimgs.asus.com/gain/A8B2B3B1-7B1B-4B1B-8B1B-1B1B1B1B1B1B/w717/h525',
      'category': 'لابتوبات',
      'categoryEn': 'Laptops',
      'brand': 'ASUS',
      'brandAr': 'أسوس',
      'featured': true,
      'discount': 14,
      'rating': 4.7,
      'reviewsCount': 76,
      'inStock': true,
      'stockQuantity': 6,
    },

    // أجهزة لوحية
    {
      'name': 'iPad Pro 12.9"',
      'nameAr': 'آيباد برو 12.9 بوصة',
      'description': 'جهاز لوحي من آبل بمعالج M2 وشاشة Liquid Retina',
      'price': 1099000.0,
      'originalPrice': 1299000.0,
      'image':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/ipad-pro-12-select-wifi-spacegray-202210?wid=940&hei=1112&fmt=png-alpha&.v=1664411207213',
      'category': 'أجهزة لوحية',
      'categoryEn': 'Tablets',
      'brand': 'Apple',
      'brandAr': 'آبل',
      'featured': true,
      'discount': 15,
      'rating': 4.8,
      'reviewsCount': 123,
      'inStock': true,
      'stockQuantity': 18,
    },
    {
      'name': 'Samsung Galaxy Tab S9',
      'nameAr': 'سامسونج جالاكسي تاب S9',
      'description': 'جهاز لوحي بنظام Android وقلم S Pen',
      'price': 799000.0,
      'originalPrice': 999000.0,
      'image':
          'https://images.samsung.com/is/image/samsung/p6pim/levant/sm-x710nzeamea/gallery/levant-galaxy-tab-s9-x710-sm-x710nzeamea-thumb-537582043',
      'category': 'أجهزة لوحية',
      'categoryEn': 'Tablets',
      'brand': 'Samsung',
      'brandAr': 'سامسونج',
      'featured': false,
      'discount': 20,
      'rating': 4.5,
      'reviewsCount': 89,
      'inStock': true,
      'stockQuantity': 14,
    },
    {
      'name': 'Microsoft Surface Pro 9',
      'nameAr': 'مايكروسوفت سيرفس برو 9',
      'description': 'جهاز لوحي بنظام Windows وإمكانيات لابتوب',
      'price': 1199000.0,
      'originalPrice': 1399000.0,
      'image':
          'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4LqeX?ver=f093&q=90&m=6&h=705&w=1253&b=%23FFFFFFFF&f=jpg&o=f&p=140&aim=true',
      'category': 'أجهزة لوحية',
      'categoryEn': 'Tablets',
      'brand': 'Microsoft',
      'brandAr': 'مايكروسوفت',
      'featured': false,
      'discount': 14,
      'rating': 4.3,
      'reviewsCount': 67,
      'inStock': true,
      'stockQuantity': 9,
    },

    // ساعات ذكية
    {
      'name': 'Apple Watch Series 9',
      'nameAr': 'آبل واتش سيريز 9',
      'description': 'ساعة ذكية من آبل بمعالج S9 ومستشعرات متقدمة',
      'price': 399000.0,
      'originalPrice': 499000.0,
      'image':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/watch-s9-45mm-pink-sport-band-pink-pdp-image-position-1__en-us?wid=5120&hei=3280&fmt=p-jpg&qlt=80&.v=1692895395658',
      'category': 'ساعات ذكية',
      'categoryEn': 'Smart Watches',
      'brand': 'Apple',
      'brandAr': 'آبل',
      'featured': true,
      'discount': 20,
      'rating': 4.7,
      'reviewsCount': 234,
      'inStock': true,
      'stockQuantity': 35,
    },
    {
      'name': 'Samsung Galaxy Watch 6',
      'nameAr': 'سامسونج جالاكسي واتش 6',
      'description': 'ساعة ذكية بنظام Wear OS ومراقبة صحية',
      'price': 299000.0,
      'originalPrice': 399000.0,
      'image':
          'https://images.samsung.com/is/image/samsung/p6pim/levant/2307/gallery/levant-galaxy-watch6-r930-sm-r930nzsaxsg-thumb-537119512',
      'category': 'ساعات ذكية',
      'categoryEn': 'Smart Watches',
      'brand': 'Samsung',
      'brandAr': 'سامسونج',
      'featured': false,
      'discount': 25,
      'rating': 4.4,
      'reviewsCount': 167,
      'inStock': true,
      'stockQuantity': 28,
    },
    {
      'name': 'Garmin Fenix 7',
      'nameAr': 'جارمن فينيكس 7',
      'description': 'ساعة رياضية متقدمة بGPS وبطارية طويلة المدى',
      'price': 699000.0,
      'originalPrice': 899000.0,
      'image':
          'https://static.garmin.com/en/products/010-02540-00/g/cf-lg-bb0c8b0c-8b0c-4b0c-8b0c-8b0c8b0c8b0c.jpg',
      'category': 'ساعات ذكية',
      'categoryEn': 'Smart Watches',
      'brand': 'Garmin',
      'brandAr': 'جارمن',
      'featured': false,
      'discount': 22,
      'rating': 4.6,
      'reviewsCount': 89,
      'inStock': true,
      'stockQuantity': 12,
    },

    // سماعات
    {
      'name': 'AirPods Pro 2',
      'nameAr': 'إيربودز برو 2',
      'description': 'سماعات لاسلكية بإلغاء الضوضاء النشط',
      'price': 249000.0,
      'originalPrice': 299000.0,
      'image':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQD83?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1660803972361',
      'category': 'سماعات',
      'categoryEn': 'Headphones',
      'brand': 'Apple',
      'brandAr': 'آبل',
      'featured': true,
      'discount': 17,
      'rating': 4.8,
      'reviewsCount': 456,
      'inStock': true,
      'stockQuantity': 45,
    },
    {
      'name': 'Sony WH-1000XM5',
      'nameAr': 'سوني WH-1000XM5',
      'description': 'سماعات رأس بإلغاء الضوضاء وجودة صوت عالية',
      'price': 349000.0,
      'originalPrice': 429000.0,
      'image':
          'https://sony.scene7.com/is/image/sonyglobalsolutions/wh-1000xm5_Primary_image?\$categorypdpnav\$&fmt=png-alpha',
      'category': 'سماعات',
      'categoryEn': 'Headphones',
      'brand': 'Sony',
      'brandAr': 'سوني',
      'featured': false,
      'discount': 19,
      'rating': 4.7,
      'reviewsCount': 298,
      'inStock': true,
      'stockQuantity': 32,
    },
    {
      'name': 'Bose QuietComfort 45',
      'nameAr': 'بوز كوايت كومفورت 45',
      'description': 'سماعات بوز بإلغاء ضوضاء متقدم وراحة فائقة',
      'price': 329000.0,
      'originalPrice': 399000.0,
      'image':
          'https://assets.bose.com/content/dam/cloudassets/bose_com/en_us/products/headphones/quietcomfort_45_headphones/product_silo_images/QC45_PDP_Ecom-Gallery-B01.png',
      'category': 'سماعات',
      'categoryEn': 'Headphones',
      'brand': 'Bose',
      'brandAr': 'بوز',
      'featured': false,
      'discount': 18,
      'rating': 4.6,
      'reviewsCount': 187,
      'inStock': true,
      'stockQuantity': 24,
    },
    {
      'name': 'JBL Tune 760NC',
      'nameAr': 'JBL تيون 760NC',
      'description': 'سماعات JBL بإلغاء الضوضاء وسعر مناسب',
      'price': 129000.0,
      'originalPrice': 179000.0,
      'image':
          'https://in.jbl.com/dw/image/v2/BFND_PRD/on/demandware.static/-/Sites-masterCatalog_Harman/default/dw7b8b8b8b/JBL_TUNE760NC_ProductImage_Hero_Black.png',
      'category': 'سماعات',
      'categoryEn': 'Headphones',
      'brand': 'JBL',
      'brandAr': 'JBL',
      'featured': false,
      'discount': 28,
      'rating': 4.3,
      'reviewsCount': 145,
      'inStock': true,
      'stockQuantity': 38,
    },

    // إكسسوارات
    {
      'name': 'MagSafe Charger',
      'nameAr': 'شاحن ماج سيف',
      'description': 'شاحن لاسلكي مغناطيسي من آبل',
      'price': 39000.0,
      'originalPrice': 49000.0,
      'image':
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MHXH3?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1661346335510',
      'category': 'إكسسوارات',
      'categoryEn': 'Accessories',
      'brand': 'Apple',
      'brandAr': 'آبل',
      'featured': false,
      'discount': 20,
      'rating': 4.5,
      'reviewsCount': 234,
      'inStock': true,
      'stockQuantity': 67,
    },
    {
      'name': 'Anker PowerBank 20000mAh',
      'nameAr': 'أنكر باور بانك 20000 مللي أمبير',
      'description': 'بطارية محمولة بسعة عالية وشحن سريع',
      'price': 79000.0,
      'originalPrice': 99000.0,
      'image':
          'https://d2eebagvwr542c.cloudfront.net/catalog/product/cache/889d334df8d9c4ca7a7b8c0b8b8b8b8b/a/n/anker_powercore_20100_1.jpg',
      'category': 'إكسسوارات',
      'categoryEn': 'Accessories',
      'brand': 'Anker',
      'brandAr': 'أنكر',
      'featured': false,
      'discount': 20,
      'rating': 4.6,
      'reviewsCount': 567,
      'inStock': true,
      'stockQuantity': 89,
    },
    {
      'name': 'Belkin Car Mount',
      'nameAr': 'بيلكين حامل السيارة',
      'description': 'حامل هاتف مغناطيسي للسيارة',
      'price': 29000.0,
      'originalPrice': 39000.0,
      'image':
          'https://www.belkin.com/dw/image/v2/BFND_PRD/on/demandware.static/-/Sites-masterCatalog_Belkin/default/dw8b8b8b8b/belkin-car-mount.png',
      'category': 'إكسسوارات',
      'categoryEn': 'Accessories',
      'brand': 'Belkin',
      'brandAr': 'بيلكين',
      'featured': false,
      'discount': 26,
      'rating': 4.2,
      'reviewsCount': 123,
      'inStock': true,
      'stockQuantity': 45,
    },
    {
      'name': 'Spigen Phone Case',
      'nameAr': 'سبيجن كفر الهاتف',
      'description': 'كفر حماية شفاف مقاوم للصدمات',
      'price': 19000.0,
      'originalPrice': 29000.0,
      'image':
          'https://spigen.com/cdn/shop/products/iphone-15-pro-max-case-ultra-hybrid-magsafe-compatible-clear_1.jpg',
      'category': 'إكسسوارات',
      'categoryEn': 'Accessories',
      'brand': 'Spigen',
      'brandAr': 'سبيجن',
      'featured': false,
      'discount': 34,
      'rating': 4.4,
      'reviewsCount': 789,
      'inStock': true,
      'stockQuantity': 156,
    },
    {
      'name': 'USB-C Hub 7-in-1',
      'nameAr': 'هاب USB-C 7 في 1',
      'description': 'موزع منافذ متعدد الوظائف للابتوب',
      'price': 59000.0,
      'originalPrice': 79000.0,
      'image':
          'https://images-na.ssl-images-amazon.com/images/I/61b8b8b8b8L._AC_SL1500_.jpg',
      'category': 'إكسسوارات',
      'categoryEn': 'Accessories',
      'brand': 'Generic',
      'brandAr': 'عام',
      'featured': false,
      'discount': 25,
      'rating': 4.1,
      'reviewsCount': 234,
      'inStock': true,
      'stockQuantity': 78,
    },
  ];

  for (final product in products) {
    await firestore.collection('products').add(product);
  }
}
