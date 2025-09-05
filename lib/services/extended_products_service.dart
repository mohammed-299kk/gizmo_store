import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../models/product.dart';

class ExtendedProductsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add extended products to each category (50 products per category)
  static Future<void> addExtendedProducts(BuildContext context) async {
    try {
      final localizations = AppLocalizations.of(context)!;
      
      // Check if extended products already exist
      final existingProducts = await _firestore.collection('products').get();
      if (existingProducts.docs.length > 20) {
        print('Extended products already exist. Skipping setup.');
        return;
      }

      final List<Product> allProducts = [];

      // Smartphones (50 products)
      final smartphoneProducts = [
        // Premium Smartphones
        Product(
          id: '',
          name: 'iPhone 15 Pro Max',
          description: 'أحدث هاتف من آبل بشاشة 6.7 بوصة وكاميرا احترافية',
          price: 5499.0,
          originalPrice: 5999.0,
          image: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.9,
          reviewsCount: 250,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy S24 Plus',
          description: 'هاتف سامسونج الرائد بمعالج قوي وكاميرا متطورة',
          price: 3999.0,
          originalPrice: 4499.0,
          image: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.7,
          reviewsCount: 180,
          featured: true,
        ),
        Product(
          id: '',
          name: 'OnePlus 12',
          description: 'هاتف ون بلس بأداء سريع وشحن فائق السرعة',
          price: 2999.0,
          image: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.6,
          reviewsCount: 145,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Xiaomi 14 Ultra',
          description: 'هاتف شاومي بكاميرا ليكا وأداء متميز',
          price: 2799.0,
          originalPrice: 3199.0,
          image: 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.5,
          reviewsCount: 120,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Huawei P60 Pro',
          description: 'هاتف هواوي بتصميم أنيق وكاميرا احترافية',
          price: 3299.0,
          image: 'https://images.unsplash.com/photo-1567581935884-3349723552ca?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.4,
          reviewsCount: 98,
          featured: false,
        ),
        // Mid-range Smartphones
        Product(
          id: '',
          name: 'iPhone 14',
          description: 'هاتف آيفون 14 بأداء ممتاز وكاميرا متقدمة',
          price: 3499.0,
          originalPrice: 3999.0,
          image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.6,
          reviewsCount: 200,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy A54',
          description: 'هاتف سامسونج متوسط الفئة بمواصفات ممتازة',
          price: 1599.0,
          image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.3,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Oppo Find X6 Pro',
          description: 'هاتف أوبو بتصميم متميز وكاميرا عالية الجودة',
          price: 2899.0,
          image: 'https://images.unsplash.com/photo-1580910051074-3eb694886505?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.4,
          reviewsCount: 89,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Vivo X90 Pro',
          description: 'هاتف فيفو بكاميرا زايس وأداء قوي',
          price: 2699.0,
          originalPrice: 2999.0,
          image: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.3,
          reviewsCount: 76,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Realme GT 5',
          description: 'هاتف ريلمي للألعاب بمعالج قوي وشاشة سريعة',
          price: 1899.0,
          image: 'https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartphones,
          rating: 4.2,
          reviewsCount: 134,
          featured: false,
        ),
      ];

      // Add more smartphones to reach 50
      for (int i = 11; i <= 50; i++) {
        smartphoneProducts.add(
          Product(
            id: '',
            name: 'هاتف ذكي موديل $i',
            description: 'هاتف ذكي متطور بمواصفات عالية الجودة وتصميم أنيق',
            price: 800.0 + (i * 50),
            originalPrice: i % 3 == 0 ? 900.0 + (i * 50) : null,
            image: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            category: localizations.categorySmartphones,
            rating: 3.8 + (i % 10) * 0.1,
            reviewsCount: 20 + (i * 3),
            featured: i % 10 == 0,
          ),
        );
      }

      // Laptops (50 products)
      final laptopProducts = [
        Product(
          id: '',
          name: 'MacBook Air M3',
          description: 'لابتوب آبل الجديد بمعالج M3 وبطارية طويلة المدى',
          price: 4999.0,
          originalPrice: 5499.0,
          image: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryLaptops,
          rating: 4.8,
          reviewsCount: 189,
          featured: true,
        ),
        Product(
          id: '',
          name: 'ThinkPad X1 Carbon',
          description: 'لابتوب لينوفو للأعمال بتصميم نحيف ومتين',
          price: 6999.0,
          image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryLaptops,
          rating: 4.7,
          reviewsCount: 156,
          featured: true,
        ),
        Product(
          id: '',
          name: 'HP Spectre x360',
          description: 'لابتوب HP قابل للتحويل بشاشة لمس عالية الدقة',
          price: 4599.0,
          originalPrice: 5199.0,
          image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryLaptops,
          rating: 4.5,
          reviewsCount: 134,
          featured: false,
        ),
        Product(
          id: '',
          name: 'ASUS ROG Strix',
          description: 'لابتوب ألعاب قوي بكارت رسومات متطور',
          price: 7999.0,
          image: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=400',
          category: localizations.categoryLaptops,
          rating: 4.6,
          reviewsCount: 98,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Surface Laptop 5',
          description: 'لابتوب مايكروسوفت بتصميم أنيق وأداء ممتاز',
          price: 3999.0,
          originalPrice: 4499.0,
          image: 'https://images.unsplash.com/photo-1484788984921-03950022c9ef?w=400',
          category: localizations.categoryLaptops,
          rating: 4.4,
          reviewsCount: 167,
          featured: false,
        ),
      ];

        // Additional premium laptops
        laptopProducts.add(
          Product(
            id: '',
            name: 'Dell XPS 13',
            description: 'لابتوب ديل بشاشة InfinityEdge وأداء استثنائي',
            price: 5299.0,
            image: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            category: localizations.categoryLaptops,
            rating: 4.6,
            reviewsCount: 198,
            featured: true,
          ),
        );
        laptopProducts.add(
          Product(
            id: '',
            name: 'Acer Predator Helios',
            description: 'لابتوب ألعاب من أيسر بمعالج رسومات قوي',
            price: 6799.0,
            originalPrice: 7299.0,
            image: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            category: localizations.categoryLaptops,
            rating: 4.5,
            reviewsCount: 167,
            featured: false,
          ),
        );
        laptopProducts.add(
          Product(
            id: '',
            name: 'MSI Creator 15',
            description: 'لابتوب MSI للمبدعين والمصممين',
            price: 5899.0,
            image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            category: localizations.categoryLaptops,
            rating: 4.4,
            reviewsCount: 143,
            featured: false,
          ),
        );

      // Add more laptops to reach 50
      for (int i = 9; i <= 50; i++) {
        laptopProducts.add(
          Product(
            id: '',
            name: 'لابتوب موديل $i',
            description: 'لابتوب عالي الأداء مناسب للعمل والدراسة والترفيه',
            price: 2000.0 + (i * 100),
            originalPrice: i % 4 == 0 ? 2200.0 + (i * 100) : null,
            image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
            category: localizations.categoryLaptops,
            rating: 3.9 + (i % 8) * 0.1,
            reviewsCount: 15 + (i * 2),
            featured: i % 15 == 0,
          ),
        );
      }

      // Headphones (50 products)
      final headphoneProducts = [
        Product(
          id: '',
          name: 'Bose QuietComfort 45',
          description: 'سماعات بوز بتقنية إلغاء الضوضاء المتطورة',
          price: 1299.0,
          originalPrice: 1499.0,
          image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.7,
          reviewsCount: 234,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sennheiser HD 660S',
          description: 'سماعات سينهايزر عالية الجودة للاستوديو',
          price: 1899.0,
          image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.8,
          reviewsCount: 189,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Audio-Technica ATH-M50x',
          description: 'سماعات أوديو تكنيكا للمحترفين',
          price: 699.0,
          originalPrice: 799.0,
          image: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.6,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Beats Studio3 Wireless',
          description: 'سماعات بيتس لاسلكية بصوت قوي ونقي',
          price: 999.0,
          image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.4,
          reviewsCount: 198,
          featured: false,
        ),
        Product(
          id: '',
          name: 'JBL Live 660NC',
          description: 'سماعات JBL بتقنية إلغاء الضوضاء وصوت متوازن',
          price: 599.0,
          originalPrice: 699.0,
          image: 'https://images.unsplash.com/photo-1558756520-22cfe5d382ca?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.3,
          reviewsCount: 123,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Sony WH-1000XM5',
          description: 'سماعات سوني الرائدة بتقنية إلغاء الضوضاء الذكية',
          price: 1599.0,
          originalPrice: 1799.0,
          image: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.8,
          reviewsCount: 312,
          featured: true,
        ),
        Product(
          id: '',
          name: 'AirPods Pro 2',
          description: 'سماعات آبل اللاسلكية بتقنية إلغاء الضوضاء النشطة',
          price: 1099.0,
          image: 'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryHeadphones,
          rating: 4.6,
          reviewsCount: 287,
          featured: true,
        ),
      ];

      // Add more headphones to reach 50
      for (int i = 6; i <= 50; i++) {
        headphoneProducts.add(
          Product(
            id: '',
            name: 'سماعات موديل $i',
            description: 'سماعات عالية الجودة بصوت نقي وتصميم مريح',
            price: 200.0 + (i * 25),
            originalPrice: i % 3 == 0 ? 250.0 + (i * 25) : null,
            image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
            category: localizations.categoryHeadphones,
            rating: 3.7 + (i % 12) * 0.1,
            reviewsCount: 10 + (i * 2),
            featured: i % 12 == 0,
          ),
        );
      }

      // Smart Watches (50 products)
      final smartWatchProducts = [
        Product(
          id: '',
          name: 'Apple Watch Ultra 2',
          description: 'ساعة آبل الرياضية المتطورة للمغامرات',
          price: 2999.0,
          image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartWatches,
          rating: 4.8,
          reviewsCount: 167,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy Watch 6',
          description: 'ساعة سامسونج الذكية بمراقبة صحية متقدمة',
          price: 1299.0,
          originalPrice: 1499.0,
          image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartWatches,
          rating: 4.6,
          reviewsCount: 134,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Garmin Fenix 7',
          description: 'ساعة جارمين للرياضيين والمغامرين',
          price: 2199.0,
          image: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartWatches,
          rating: 4.7,
          reviewsCount: 98,
        ),
        Product(
          id: '',
          name: 'Fitbit Versa 4',
          description: 'ساعة فيتبت الذكية لتتبع اللياقة البدنية',
          price: 899.0,
          originalPrice: 1099.0,
          image: 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartWatches,
          rating: 4.4,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Huawei Watch GT 4',
          description: 'ساعة هواوي الذكية ببطارية طويلة المدى',
          price: 1099.0,
          image: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categorySmartWatches,
          rating: 4.5,
          reviewsCount: 123,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Fitbit Versa 4',
          description: 'ساعة فيتبت لمراقبة اللياقة البدنية والصحة',
          price: 899.0,
          originalPrice: 999.0,
          image: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=400',
          category: localizations.categorySmartWatches,
          rating: 4.4,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Huawei Watch GT 4',
          description: 'ساعة هواوي الذكية ببطارية طويلة المدى',
          price: 799.0,
          image: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
          category: localizations.categorySmartWatches,
          rating: 4.3,
          reviewsCount: 89,
          featured: false,
        ),
      ];

      // Add more smart watches to reach 50
      for (int i = 6; i <= 50; i++) {
        smartWatchProducts.add(
          Product(
            id: '',
            name: 'ساعة ذكية موديل $i',
            description: 'ساعة ذكية متطورة بمراقبة صحية وتصميم عصري',
            price: 300.0 + (i * 30),
            originalPrice: i % 4 == 0 ? 350.0 + (i * 30) : null,
            image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400',
            category: localizations.categorySmartWatches,
            rating: 3.6 + (i % 15) * 0.1,
            reviewsCount: 8 + (i * 2),
            featured: i % 20 == 0,
          ),
        );
      }

      // Tablets (50 products)
      final tabletProducts = [
        Product(
          id: '',
          name: 'iPad Air 5',
          description: 'آيباد إير بمعالج M1 وشاشة عالية الدقة',
          price: 2299.0,
          originalPrice: 2599.0,
          image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryTablets,
          rating: 4.7,
          reviewsCount: 189,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy Tab S9',
          description: 'جهاز لوحي سامسونج بشاشة AMOLED وقلم S Pen',
          price: 1899.0,
          originalPrice: 2199.0,
          image: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryTablets,
          rating: 4.6,
          reviewsCount: 156,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Microsoft Surface Pro 9',
          description: 'جهاز لوحي مايكروسوفت بنظام Windows 11',
          price: 3299.0,
          image: 'https://images.unsplash.com/photo-1585792180666-f7347c490ee2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryTablets,
          rating: 4.5,
          reviewsCount: 134,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Samsung Galaxy Tab S9',
          description: 'تابلت سامسونج بقلم S Pen وشاشة AMOLED',
          price: 1999.0,
          image: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=400',
          category: localizations.categoryTablets,
          rating: 4.5,
          reviewsCount: 134,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Microsoft Surface Pro 9',
          description: 'تابلت مايكروسوفت بنظام ويندوز وأداء لابتوب',
          price: 3499.0,
          originalPrice: 3999.0,
          image: 'https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=400',
          category: localizations.categoryTablets,
          rating: 4.6,
          reviewsCount: 98,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Lenovo Tab P12 Pro',
          description: 'تابلت لينوفو للإنتاجية والترفيه',
          price: 1599.0,
          image: 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400',
          category: localizations.categoryTablets,
          rating: 4.3,
          reviewsCount: 76,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Huawei MatePad Pro',
          description: 'تابلت هواوي بتصميم نحيف وأداء قوي',
          price: 1299.0,
          originalPrice: 1499.0,
          image: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=400',
          category: localizations.categoryTablets,
          rating: 4.4,
          reviewsCount: 112,
          featured: false,
        ),
      ];

      // Add more tablets to reach 50
      for (int i = 6; i <= 50; i++) {
        tabletProducts.add(
          Product(
            id: '',
            name: 'تابلت موديل $i',
            description: 'تابلت متطور للعمل والترفيه بشاشة عالية الدقة',
            price: 500.0 + (i * 40),
            originalPrice: i % 5 == 0 ? 600.0 + (i * 40) : null,
            image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
            category: localizations.categoryTablets,
            rating: 3.8 + (i % 10) * 0.1,
            reviewsCount: 12 + (i * 2),
            featured: i % 18 == 0,
          ),
        );
      }

      // Accessories (50 products)
      final accessoryProducts = [
        Product(
          id: '',
          name: 'MagSafe Battery Pack',
          description: 'بطارية آبل المغناطيسية للآيفون',
          price: 399.0,
          image: 'https://images.unsplash.com/photo-1609592806787-3d9c5b8e8b8e?w=400',
          category: localizations.categoryAccessories,
          rating: 4.3,
          reviewsCount: 156,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Anker PowerCore 10000',
          description: 'بطارية محمولة من أنكر بسعة عالية',
          price: 199.0,
          originalPrice: 249.0,
          image: 'https://images.unsplash.com/photo-1609592806787-3d9c5b8e8b8e?w=400',
          category: localizations.categoryAccessories,
          rating: 4.5,
          reviewsCount: 234,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Logitech MX Master 3S',
          description: 'ماوس لوجيتك للمحترفين بدقة عالية',
          price: 449.0,
          image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
          category: localizations.categoryAccessories,
          rating: 4.7,
          reviewsCount: 189,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Apple Magic Keyboard',
          description: 'لوحة مفاتيح آبل اللاسلكية',
          price: 599.0,
          originalPrice: 699.0,
          image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400',
          category: localizations.categoryAccessories,
          rating: 4.4,
          reviewsCount: 167,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Samsung 65W Fast Charger',
          description: 'شاحن سامسونج السريع بقوة 65 واط',
          price: 149.0,
          image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
          category: localizations.categoryAccessories,
          rating: 4.2,
          reviewsCount: 98,
          featured: false,
        ),
      ];

      // Add more accessories to reach 50
      for (int i = 6; i <= 50; i++) {
        accessoryProducts.add(
          Product(
            id: '',
            name: 'إكسسوار موديل $i',
            description: 'إكسسوار عالي الجودة لتحسين تجربة استخدام أجهزتك',
            price: 50.0 + (i * 15),
            originalPrice: i % 6 == 0 ? 70.0 + (i * 15) : null,
            image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
            category: localizations.categoryAccessories,
            rating: 3.5 + (i % 20) * 0.1,
            reviewsCount: 5 + i,
            featured: i % 25 == 0,
          ),
        );
      }

      // Computers (50 products)
      final computerProducts = [
        Product(
          id: '',
          name: 'iMac 24" M3',
          description: 'كمبيوتر آبل المكتبي بمعالج M3 وشاشة 4.5K',
          price: 6999.0,
          originalPrice: 7499.0,
          image: 'https://images.unsplash.com/photo-1547082299-de196ea013d6?w=400',
          category: localizations.categoryComputers,
          rating: 4.8,
          reviewsCount: 145,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Dell OptiPlex 7000',
          description: 'كمبيوتر ديل للأعمال بأداء عالي',
          price: 3999.0,
          image: 'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=400',
          category: localizations.categoryComputers,
          rating: 4.5,
          reviewsCount: 98,
          featured: false,
        ),
        Product(
          id: '',
          name: 'HP Pavilion Desktop',
          description: 'كمبيوتر HP مكتبي للاستخدام المنزلي',
          price: 2799.0,
          originalPrice: 3199.0,
          image: 'https://images.unsplash.com/photo-1587831990711-23ca6441447b?w=400',
          category: localizations.categoryComputers,
          rating: 4.3,
          reviewsCount: 76,
          featured: false,
        ),
        Product(
          id: '',
          name: 'ASUS ROG Desktop',
          description: 'كمبيوتر ألعاب قوي من أسوس',
          price: 8999.0,
          image: 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=400',
          category: localizations.categoryComputers,
          rating: 4.7,
          reviewsCount: 134,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Lenovo ThinkCentre',
          description: 'كمبيوتر لينوفو للأعمال والمكاتب',
          price: 2299.0,
          originalPrice: 2599.0,
          image: 'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?w=400',
          category: localizations.categoryComputers,
          rating: 4.4,
          reviewsCount: 89,
          featured: false,
        ),
      ];

      // Add more computers to reach 50
      for (int i = 6; i <= 50; i++) {
        computerProducts.add(
          Product(
            id: '',
            name: 'كمبيوتر موديل $i',
            description: 'كمبيوتر مكتبي عالي الأداء للعمل والترفيه',
            price: 1500.0 + (i * 80),
            originalPrice: i % 7 == 0 ? 1700.0 + (i * 80) : null,
            image: 'https://images.unsplash.com/photo-1547082299-de196ea013d6?w=400',
            category: localizations.categoryComputers,
            rating: 3.9 + (i % 8) * 0.1,
            reviewsCount: 10 + (i * 2),
            featured: i % 22 == 0,
          ),
        );
      }

      // Cameras (50 products)
      final cameraProducts = [
        Product(
          id: '',
          name: 'Canon EOS R5',
          description: 'كاميرا كانون احترافية بدقة 45 ميجابكسل وتصوير فيديو 8K',
          price: 12999.0,
          originalPrice: 14999.0,
          image: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.9,
          reviewsCount: 167,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sony Alpha A7 IV',
          description: 'كاميرا سوني بدون مرآة للمحترفين مع استقرار الصورة',
          price: 9999.0,
          image: 'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.8,
          reviewsCount: 134,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Nikon Z9',
          description: 'كاميرا نيكون الرائدة للتصوير الاحترافي والرياضي',
          price: 15999.0,
          originalPrice: 17999.0,
          image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.7,
          reviewsCount: 98,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Fujifilm X-T5',
          description: 'كاميرا فوجي فيلم بتصميم كلاسيكي وجودة ألوان استثنائية',
          price: 6999.0,
          image: 'https://images.unsplash.com/photo-1495121553079-4c61bcce1894?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.6,
          reviewsCount: 89,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Panasonic Lumix GH6',
          description: 'كاميرا باناسونيك للفيديو الاحترافي والتصوير السينمائي',
          price: 7999.0,
          originalPrice: 8999.0,
          image: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.5,
          reviewsCount: 76,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Canon EOS R6 Mark II',
          description: 'كاميرا كانون متوسطة المدى بأداء احترافي',
          price: 8999.0,
          originalPrice: 9999.0,
          image: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.7,
          reviewsCount: 145,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Sony FX30',
          description: 'كاميرا سوني للفيديو الاحترافي والمحتوى الرقمي',
          price: 7499.0,
          image: 'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: localizations.categoryCameras,
          rating: 4.6,
          reviewsCount: 112,
          featured: false,
        ),
      ];

      // Add more cameras to reach 50
      for (int i = 8; i <= 50; i++) {
        cameraProducts.add(
          Product(
            id: '',
            name: 'كاميرا موديل $i',
            description: 'كاميرا رقمية متطورة للتصوير الاحترافي والهواة',
            price: 2000.0 + (i * 150),
            originalPrice: i % 8 == 0 ? 2300.0 + (i * 150) : null,
            image: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            category: localizations.categoryCameras,
            rating: 4.0 + (i % 6) * 0.1,
            reviewsCount: 15 + (i * 2),
            featured: i % 28 == 0,
          ),
        );
      }

      // Gaming & Entertainment (50 products)
      final gamingProducts = [
        Product(
          id: '',
          name: 'PlayStation 5',
          description: 'جهاز ألعاب سوني الجيل الخامس مع تقنية Ray Tracing',
          price: 2299.0,
          originalPrice: 2499.0,
          image: 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.8,
          reviewsCount: 234,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Xbox Series X',
          description: 'جهاز ألعاب مايكروسوفت بأداء 4K وسرعة تحميل فائقة',
          price: 2199.0,
          image: 'https://images.unsplash.com/photo-1621259182978-fbf93132d53d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.7,
          reviewsCount: 198,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Nintendo Switch OLED',
          description: 'جهاز ألعاب نينتندو المحمول بشاشة OLED',
          price: 1499.0,
          originalPrice: 1699.0,
          image: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.6,
          reviewsCount: 167,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Steam Deck',
          description: 'جهاز ألعاب محمول من Valve لألعاب PC',
          price: 1899.0,
          image: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.5,
          reviewsCount: 134,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Meta Quest 3',
          description: 'نظارة واقع افتراضي من Meta للألعاب والتطبيقات',
          price: 2799.0,
          originalPrice: 2999.0,
          image: 'https://images.unsplash.com/photo-1593508512255-86ab42a8e620?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.4,
          reviewsCount: 89,
          featured: true,
        ),
        Product(
          id: '',
          name: 'Razer DeathAdder V3',
          description: 'ماوس ألعاب احترافي من Razer بدقة عالية',
          price: 299.0,
          image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.6,
          reviewsCount: 156,
          featured: false,
        ),
        Product(
          id: '',
          name: 'Corsair K95 RGB',
          description: 'لوحة مفاتيح ألعاب ميكانيكية مع إضاءة RGB',
          price: 799.0,
          originalPrice: 899.0,
          image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          category: 'الألعاب والترفيه',
          rating: 4.5,
          reviewsCount: 123,
          featured: false,
        ),
      ];

      // Add more gaming products to reach 50
      for (int i = 8; i <= 50; i++) {
        gamingProducts.add(
          Product(
            id: '',
            name: 'منتج ألعاب $i',
            description: 'إكسسوار ألعاب عالي الجودة لتحسين تجربة اللعب',
            price: 100.0 + (i * 25),
            originalPrice: i % 9 == 0 ? 130.0 + (i * 25) : null,
            image: 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            category: 'الألعاب والترفيه',
            rating: 4.0 + (i % 7) * 0.1,
            reviewsCount: 20 + (i * 3),
            featured: i % 30 == 0,
          ),
        );
      }

      // Combine all products
      allProducts.addAll(smartphoneProducts);
      allProducts.addAll(laptopProducts);
      allProducts.addAll(headphoneProducts);
      allProducts.addAll(smartWatchProducts);
      allProducts.addAll(tabletProducts);
      allProducts.addAll(accessoryProducts);
      allProducts.addAll(computerProducts);
      allProducts.addAll(cameraProducts);
      allProducts.addAll(gamingProducts);

      print('Adding ${allProducts.length} extended products to Firestore...');

      // Add all products to Firestore in batches
      const batchSize = 500; // Firestore batch limit
      for (int i = 0; i < allProducts.length; i += batchSize) {
        final batch = _firestore.batch();
        final endIndex = (i + batchSize < allProducts.length) ? i + batchSize : allProducts.length;
        
        for (int j = i; j < endIndex; j++) {
          final product = allProducts[j];
          final productRef = _firestore.collection('products').doc();
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
          batch.set(productRef, productData);
        }
        
        await batch.commit();
        print('Added batch ${(i ~/ batchSize) + 1} of ${(allProducts.length / batchSize).ceil()}');
      }

      print('Extended products setup completed successfully!');
      print('Total products added: ${allProducts.length}');
      
    } catch (e) {
      print('Error setting up extended products: $e');
      rethrow;
    }
  }

  /// Clear all products from Firestore (for testing purposes)
  static Future<void> clearAllProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final batch = _firestore.batch();
      
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print('All products cleared successfully!');
    } catch (e) {
      print('Error clearing products: $e');
      rethrow;
    }
  }
}