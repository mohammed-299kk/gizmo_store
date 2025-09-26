import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../services/firebase_auth_service.dart';
import '../services/cart_service.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../screens/enhanced_cart_screen.dart';
import '../main.dart';
import 'cart/cart_screen.dart';
import 'settings_screen.dart';
import 'auth/auth_screen.dart';
import 'profile/profile_screen.dart';
import 'admin/add_sample_data_screen.dart';
import 'category_products_screen.dart';
import 'product/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userType;

  const HomeScreen({super.key, this.userType = 'user'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    await CartService.loadCart();
    setState(() {
      _cartItemCount = CartService.totalQuantity;
    });
  }

  // خريطة الصور من ملف figma-design
  Map<String, List<String>> _getProductImages() {
    return {
      'headphones': [
        'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61jLBqaAUPL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81Dm7eZw2KL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61EKOWP+AFL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61CBni+XbxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BVbdhqzxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81Dm7eZw2KL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61CBni+XbxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
      ],
      'laptops': [
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81bc8mS3nhL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71CmvZqujCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61Qe0euJJZL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81bc8mS3nhL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71CmvZqujCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61Qe0euJJZL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81bc8mS3nhL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71CmvZqujCL._AC_SL1500_.jpg',
      ],
      'phones': [
        'https://m.media-amazon.com/images/I/71xb2xkN5qL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81OS7lnaaIL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71GLMJ7TQiL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81OS7lnaaIL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71GLMJ7TQiL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81OS7lnaaIL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71GLMJ7TQiL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81OS7lnaaIL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
      ],
      'tablets': [
        'https://m.media-amazon.com/images/I/81NiQ+BrVBL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
      ],
      'smartwatches': [
        'https://m.media-amazon.com/images/I/71u1JbqAojL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BVbdhqzxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BVbdhqzxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BVbdhqzxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
      ],
      'tvs': [
        'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/nanocell/75nano766qa/75nano766qa-1.jpg',
        'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
      ],
    };
  }

  // دالة للحصول على صورة المنتج حسب الفئة والفهرس
  String _getProductImage(String category, int index) {
    final images = _getProductImages();
    if (images.containsKey(category) && images[category]!.isNotEmpty) {
      return images[category]![index % images[category]!.length];
    }
    return 'https://via.placeholder.com/300x300?text=No+Image';
  }

  List<Map<String, dynamic>> _getProducts(BuildContext context) {
    final products = [
      // سماعات
      {
        'name': 'Sony WH-1000XM5',
        'price': 350000,
        'originalPrice': 400000,
        'category': 'headphones',
        'description': 'سماعات سوني اللاسلكية مع إلغاء الضوضاء المتقدم',
        'rating': 4.8,
        'discount': 12,
        'currency': 'ج.س',
        'location': 'الخرطوم',
        'stock': 25,
      },
      {
        'name': 'Bose QuietComfort 45',
        'price': 320000,
        'originalPrice': 370000,
        'category': 'headphones',
        'description': 'سماعات بوز مع تقنية إلغاء الضوضاء الرائدة',
        'rating': 4.7,
        'discount': 13,
        'currency': 'ج.س',
        'location': 'الخرطوم',
        'stock': 20,
      },
      {
        'name': 'Apple AirPods Pro 2',
        'price': 280000,
        'originalPrice': 320000,
        'category': 'headphones',
        'description': 'سماعات آبل اللاسلكية مع إلغاء الضوضاء النشط',
        'rating': 4.9,
        'discount': 12,
        'currency': 'ج.س',
        'location': 'الخرطوم',
        'stock': 30,
      },
      {
        'name': 'Sennheiser Momentum 4',
        'price': 380000,
        'originalPrice': 430000,
        'category': 'headphones',
        'description': 'سماعات سينهايزر عالية الجودة مع عمر بطارية طويل',
        'rating': 4.6,
        'discount': 11,
        'currency': 'ج.س',
        'location': 'الخرطوم',
        'stock': 15,
      },
      {
        'name': 'Audio-Technica ATH-M50xBT2',
        'price': 200000,
        'originalPrice': 230000,
        'category': 'headphones',
        'description': 'سماعات أوديو تكنيكا المهنية اللاسلكية',
        'rating': 4.5,
        'discount': 13,
        'currency': 'ج.س',
        'location': 'الخرطوم',
        'stock': 18,
      },
      {
        'name': 'Beats Studio3 Wireless',
        'price': 250000,
        'originalPrice': 290000,
        'image': 'https://m.media-amazon.com/images/I/51jVs8p3cYL._AC_SL1500_.jpg',
        'category': 'headphones',
        'description': 'سماعات بيتس اللاسلكية مع معالج W1',
        'rating': 4.4,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 22,
      },
      {
        'name': 'JBL Live 660NC',
        'price': 150000,
        'originalPrice': 180000,
        'image': 'https://m.media-amazon.com/images/I/71QKqLqNVyL._AC_SL1500_.jpg',
        'category': 'headphones',
        'description': 'سماعات JBL مع إلغاء الضوضاء وصوت نقي',
        'rating': 4.3,
        'discount': 16,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 35,
      },
      {
        'name': 'Skullcandy Crusher Evo',
        'price': 180000,
        'originalPrice': 210000,
        'image': 'https://m.media-amazon.com/images/I/71rGGqjXzgL._AC_SL1500_.jpg',
        'category': 'headphones',
        'description': 'سماعات سكل كاندي مع باس قابل للتخصيص',
        'rating': 4.2,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 28,
      },
      {
        'name': 'Razer BlackShark V2 Pro',
        'price': 220000,
        'originalPrice': 260000,
        'image': 'https://m.media-amazon.com/images/I/61jVpV4LHOL._AC_SL1500_.jpg',
        'category': 'headphones',
        'description': 'سماعات رايزر للألعاب مع صوت محيطي',
        'rating': 4.6,
        'discount': 15,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'HyperX Cloud Alpha S',
        'price': 120000,
        'originalPrice': 140000,
        'image': 'https://m.media-amazon.com/images/I/71Qs7WKFVOL._AC_SL1500_.jpg',
        'category': 'headphones',
        'description': 'سماعات هايبر إكس للألعاب مع صوت 7.1',
        'rating': 4.5,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 40,
      },

      // لاب توب
      {
        'name': 'MacBook Pro 16" M3 Max',
        'price': 2800000,
        'originalPrice': 3200000,
        'image': 'https://m.media-amazon.com/images/I/61RJn0ofUsL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب آبل الاحترافي مع معالج M3 Max وشاشة Liquid Retina XDR',
        'rating': 4.9,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 8,
      },
      {
        'name': 'Dell XPS 15 OLED',
        'price': 1800000,
        'originalPrice': 2100000,
        'image': 'https://m.media-amazon.com/images/I/71wF7YDIQkL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب ديل XPS مع شاشة OLED 4K ومعالج Intel Core i7',
        'rating': 4.7,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'HP Spectre x360 16',
        'price': 1600000,
        'originalPrice': 1850000,
        'image': 'https://m.media-amazon.com/images/I/71Vw6qLKzBL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب HP قابل للتحويل مع شاشة لمس OLED',
        'rating': 4.6,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 10,
      },
      {
        'name': 'Lenovo ThinkPad X1 Carbon',
        'price': 1400000,
        'originalPrice': 1650000,
        'image': 'https://m.media-amazon.com/images/I/61vFO2rLBsL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب لينوفو الأعمال مع تصميم خفيف ومتين',
        'rating': 4.8,
        'discount': 15,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'ASUS ROG Zephyrus G16',
        'price': 2200000,
        'originalPrice': 2500000,
        'image': 'https://m.media-amazon.com/images/I/81AEmqydk8L._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب ألعاب أسوس مع RTX 4070 ومعالج Intel Core i9',
        'rating': 4.7,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 6,
      },
      {
        'name': 'Microsoft Surface Laptop 5',
        'price': 1200000,
        'originalPrice': 1400000,
        'image': 'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب مايكروسوفت سيرفس مع تصميم أنيق وأداء ممتاز',
        'rating': 4.5,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'Acer Predator Helios 16',
        'price': 1800000,
        'originalPrice': 2100000,
        'image': 'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب ألعاب أيسر مع RTX 4060 وشاشة 165Hz',
        'rating': 4.6,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 9,
      },
      {
        'name': 'Razer Blade 15',
        'price': 2400000,
        'originalPrice': 2800000,
        'image': 'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب رايزر للألعاب مع تصميم نحيف وأداء قوي',
        'rating': 4.8,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 5,
      },
      {
        'name': 'LG Gram 17',
        'price': 1300000,
        'originalPrice': 1500000,
        'image': 'https://m.media-amazon.com/images/I/71r1+2M0sDL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب LG خفيف الوزن مع شاشة 17 بوصة',
        'rating': 4.4,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 14,
      },
      {
        'name': 'MSI Creator Z16P',
        'price': 2000000,
        'originalPrice': 2300000,
        'image': 'https://m.media-amazon.com/images/I/71QKqLqNVyL._AC_SL1500_.jpg',
        'category': 'laptops',
        'description': 'لاب توب MSI للمبدعين مع RTX 4060 وشاشة QHD+',
        'rating': 4.7,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 7,
      },

      // هواتف
      {
        'name': 'iPhone 15 Pro Max',
        'price': 1450000,
        'originalPrice': 1650000,
        'image': 'https://m.media-amazon.com/images/I/81AEmqydk8L._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'أحدث هاتف من آبل بمعالج A17 Pro وكاميرا تيتانيوم',
        'rating': 4.9,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'Samsung Galaxy S24 Ultra',
        'price': 1200000,
        'originalPrice': 1400000,
        'image': 'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف سامسونج الرائد مع كاميرا 200MP وقلم S Pen',
        'rating': 4.8,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'Google Pixel 8 Pro',
        'price': 950000,
        'originalPrice': 1100000,
        'image': 'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف جوجل بكاميرا ذكية وذكاء اصطناعي متطور',
        'rating': 4.7,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'OnePlus 12',
        'price': 850000,
        'originalPrice': 980000,
        'image': 'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف ون بلس بشحن سريع 100W ومعالج Snapdragon 8 Gen 3',
        'rating': 4.6,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 20,
      },
      {
        'name': 'Xiaomi 14 Ultra',
        'price': 800000,
        'originalPrice': 920000,
        'image': 'https://m.media-amazon.com/images/I/71r1+2M0sDL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف شاومي الرائد مع كاميرا Leica وشحن سريع',
        'rating': 4.5,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 25,
      },
      {
        'name': 'Oppo Find X7 Ultra',
        'price': 750000,
        'originalPrice': 870000,
        'image': 'https://m.media-amazon.com/images/I/71QKqLqNVyL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف أوبو الرائد مع كاميرا Hasselblad وتصميم فاخر',
        'rating': 4.4,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 22,
      },
      {
        'name': 'Vivo X100 Pro',
        'price': 700000,
        'originalPrice': 800000,
        'image': 'https://m.media-amazon.com/images/I/71rGGqjXzgL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف فيفو مع كاميرا Zeiss وأداء متميز',
        'rating': 4.3,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 28,
      },
      {
        'name': 'Nothing Phone (2a)',
        'price': 450000,
        'originalPrice': 520000,
        'image': 'https://m.media-amazon.com/images/I/61jVpV4LHOL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف Nothing بتصميم شفاف مميز وأداء قوي',
        'rating': 4.2,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 30,
      },
      {
        'name': 'Realme GT 5 Pro',
        'price': 550000,
        'originalPrice': 630000,
        'image': 'https://m.media-amazon.com/images/I/71Qs7WKFVOL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف ريلمي للألعاب مع معالج قوي وشحن سريع',
        'rating': 4.1,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 35,
      },
      {
        'name': 'Honor Magic 6 Pro',
        'price': 650000,
        'originalPrice': 750000,
        'image': 'https://m.media-amazon.com/images/I/61+btTqf7tL._AC_SL1500_.jpg',
        'category': 'smartphones',
        'description': 'هاتف هونر الرائد مع كاميرا متطورة وبطارية كبيرة',
        'rating': 4.4,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },

      // تابلت
      {
        'name': 'iPad Pro 12.9" M2',
        'price': 1200000,
        'originalPrice': 1400000,
        'image': 'https://m.media-amazon.com/images/I/81AEmqydk8L._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'آيباد برو مع معالج M2 وشاشة Liquid Retina XDR',
        'rating': 4.9,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 10,
      },
      {
        'name': 'Samsung Galaxy Tab S9 Ultra',
        'price': 1000000,
        'originalPrice': 1150000,
        'image': 'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت سامسونج الكبير مع قلم S Pen وشاشة AMOLED',
        'rating': 4.7,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'Microsoft Surface Pro 9',
        'price': 900000,
        'originalPrice': 1050000,
        'image': 'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت مايكروسوفت سيرفس مع لوحة مفاتيح قابلة للفصل',
        'rating': 4.6,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'iPad Air 5th Gen',
        'price': 650000,
        'originalPrice': 750000,
        'image': 'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'آيباد إير مع معالج M1 وتصميم نحيف',
        'rating': 4.8,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 20,
      },
      {
        'name': 'Lenovo Tab P12 Pro',
        'price': 550000,
        'originalPrice': 630000,
        'image': 'https://m.media-amazon.com/images/I/71r1+2M0sDL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت لينوفو مع شاشة OLED وأداء ممتاز',
        'rating': 4.4,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'Huawei MatePad Pro 12.6',
        'price': 600000,
        'originalPrice': 700000,
        'image': 'https://m.media-amazon.com/images/I/71QKqLqNVyL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت هواوي مع قلم M-Pencil وشاشة عالية الدقة',
        'rating': 4.3,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 16,
      },
      {
        'name': 'Amazon Fire Max 11',
        'price': 200000,
        'originalPrice': 240000,
        'image': 'https://m.media-amazon.com/images/I/71rGGqjXzgL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت أمازون فاير بسعر اقتصادي وأداء جيد',
        'rating': 4.0,
        'discount': 16,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 30,
      },
      {
        'name': 'Xiaomi Pad 6',
        'price': 350000,
        'originalPrice': 400000,
        'image': 'https://m.media-amazon.com/images/I/61jVpV4LHOL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت شاومي مع شاشة 144Hz وأداء قوي',
        'rating': 4.2,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 25,
      },
      {
        'name': 'ASUS ZenPad 3S 10',
        'price': 300000,
        'originalPrice': 350000,
        'image': 'https://m.media-amazon.com/images/I/71Qs7WKFVOL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت أسوس مع تصميم معدني أنيق',
        'rating': 4.1,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 22,
      },
      {
        'name': 'TCL Tab 10s',
        'price': 180000,
        'originalPrice': 210000,
        'image': 'https://m.media-amazon.com/images/I/61+btTqf7tL._AC_SL1500_.jpg',
        'category': 'tablets',
        'description': 'تابلت TCL بسعر مناسب وأداء موثوق',
        'rating': 3.9,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 35,
      },

      // ساعات
      {
        'name': 'Apple Watch Series 9',
        'price': 450000,
        'originalPrice': 520000,
        'image': 'https://m.media-amazon.com/images/I/81AEmqydk8L._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة آبل الذكية مع معالج S9 ومراقبة صحية متقدمة',
        'rating': 4.8,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 22,
      },
      {
        'name': 'Samsung Galaxy Watch 6 Classic',
        'price': 380000,
        'originalPrice': 440000,
        'image': 'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة سامسونج الكلاسيكية مع إطار دوار وتتبع صحي',
        'rating': 4.6,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'Garmin Fenix 7X Solar',
        'price': 650000,
        'originalPrice': 750000,
        'image': 'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة رياضية متطورة بشحن شمسي ومقاومة عسكرية',
        'rating': 4.7,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'Fitbit Versa 4',
        'price': 250000,
        'originalPrice': 290000,
        'image': 'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة فيتبت للياقة البدنية مع GPS مدمج',
        'rating': 4.3,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 25,
      },
      {
        'name': 'Amazfit GTR 4',
        'price': 200000,
        'originalPrice': 230000,
        'image': 'https://m.media-amazon.com/images/I/71r1+2M0sDL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة أمازفيت مع عمر بطارية طويل ومراقبة صحية',
        'rating': 4.2,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 30,
      },
      {
        'name': 'Huawei Watch GT 4',
        'price': 280000,
        'originalPrice': 320000,
        'image': 'https://m.media-amazon.com/images/I/71QKqLqNVyL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة هواوي مع تصميم كلاسيكي ومراقبة صحية شاملة',
        'rating': 4.4,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 20,
      },
      {
        'name': 'Fossil Gen 6',
        'price': 320000,
        'originalPrice': 370000,
        'image': 'https://m.media-amazon.com/images/I/71rGGqjXzgL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة فوسيل الذكية مع Wear OS وتصميم أنيق',
        'rating': 4.1,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'TicWatch Pro 5',
        'price': 350000,
        'originalPrice': 400000,
        'image': 'https://m.media-amazon.com/images/I/61jVpV4LHOL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة تيك واتش مع شاشة مزدوجة وأداء قوي',
        'rating': 4.3,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'Polar Vantage V3',
        'price': 500000,
        'originalPrice': 580000,
        'image': 'https://m.media-amazon.com/images/I/71Qs7WKFVOL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة بولار الرياضية مع مراقبة متقدمة للأداء',
        'rating': 4.5,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 10,
      },
      {
        'name': 'Suunto 9 Peak Pro',
        'price': 600000,
        'originalPrice': 700000,
        'image': 'https://m.media-amazon.com/images/I/61+btTqf7tL._AC_SL1500_.jpg',
        'category': 'smartwatches',
        'description': 'ساعة سونتو للمغامرات مع GPS دقيق وعمر بطارية طويل',
        'rating': 4.6,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 8,
      },

      // أجهزة تلفاز
      {
        'name': 'Samsung Neo QLED QN95C 65"',
        'price': 2200000,
        'originalPrice': 2500000,
        'image': 'https://m.media-amazon.com/images/I/81AEmqydk8L._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز سامسونج Neo QLED مع تقنية Mini LED وجودة 4K',
        'rating': 4.8,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 5,
      },
      {
        'name': 'LG C3 OLED 55"',
        'price': 1800000,
        'originalPrice': 2100000,
        'image': 'https://m.media-amazon.com/images/I/91L9EFaFsZL._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز LG OLED مع ألوان مثالية وتباين لا نهائي',
        'rating': 4.9,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 8,
      },
      {
        'name': 'Sony X90L 65"',
        'price': 1600000,
        'originalPrice': 1850000,
        'image': 'https://m.media-amazon.com/images/I/81j0QXJLXsL._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز سوني مع معالج Cognitive Processor XR وجودة صورة ممتازة',
        'rating': 4.7,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 10,
      },
      {
        'name': 'TCL C845 Mini LED 55"',
        'price': 1200000,
        'originalPrice': 1400000,
        'image': 'https://www.tcl.com/content/dam/tcl/product/tv/2023/c845/c845-55/c845-55-product-image-1.jpg',
        'category': 'tvs',
        'description': 'تلفاز TCL مع تقنية Mini LED وألوان زاهية',
        'rating': 4.5,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'Hisense U8K 65"',
        'price': 1400000,
        'originalPrice': 1600000,
        'image': 'https://m.media-amazon.com/images/I/81ZVaRsFVyL._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز هايسنس مع تقنية ULED وأداء ألعاب ممتاز',
        'rating': 4.4,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'Philips OLED808 55"',
        'price': 1700000,
        'originalPrice': 1950000,
        'image': 'https://images.philips.com/is/image/philipsconsumer/55OLED808_12-FRT-GLOBAL-001?$jpglarge$&wid=960',
        'category': 'tvs',
        'description': 'تلفاز فيليبس OLED مع تقنية Ambilight الفريدة',
        'rating': 4.6,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 7,
      },
      {
        'name': 'Xiaomi TV A2 43"',
        'price': 450000,
        'originalPrice': 520000,
        'image': 'https://m.media-amazon.com/images/I/71r1+2M0sDL._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز شاومي بسعر اقتصادي وجودة جيدة',
        'rating': 4.2,
        'discount': 13,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 25,
      },
      {
        'name': 'LG NanoCell 75NANO76 75"',
        'price': 1100000,
        'originalPrice': 1300000,
        'image': 'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/nanocell/75nano766qa/75nano766qa-1.jpg',
        'category': 'tvs',
        'description': 'تلفاز LG NanoCell كبير الحجم مع ألوان نقية',
        'rating': 4.3,
        'discount': 15,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 6,
      },
      {
        'name': 'Samsung Frame TV 55"',
        'price': 1500000,
        'originalPrice': 1750000,
        'image': 'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز سامسونج Frame بتصميم لوحة فنية',
        'rating': 4.7,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 9,
      },
      {
        'name': 'Roku TV 50"',
        'price': 600000,
        'originalPrice': 700000,
        'image': 'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg',
        'category': 'tvs',
        'description': 'تلفاز روكو الذكي مع واجهة سهلة الاستخدام',
        'rating': 4.1,
        'discount': 14,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 20,
      },
      
      // أجهزة الكمبيوتر المحمولة
      {
        'name': 'MacBook Pro 16"',
        'price': 1850000,
        'originalPrice': 2000000,
        'image': Icons.laptop_mac,
        'category': 'laptops',
        'description': 'لابتوب آبل بمعالج M3 Pro وشاشة Liquid Retina XDR',
        'rating': 4.9,
        'discount': 7,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 6,
      },
      {
        'name': 'Dell XPS 15',
        'price': 1200000,
        'originalPrice': 1350000,
        'image': Icons.laptop_windows,
        'category': 'laptops',
        'description': 'لابتوب عالي الأداء مع معالج Intel i7 وكارت RTX 4060',
        'rating': 4.7,
        'discount': 11,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 8,
      },
      {
        'name': 'HP Spectre x360',
        'price': 950000,
        'originalPrice': 1050000,
        'image': Icons.laptop,
        'category': 'laptops',
        'description': 'لابتوب قابل للتحويل مع شاشة لمس OLED',
        'rating': 4.5,
        'discount': 9,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 10,
      },
      {
        'name': 'ASUS ROG Zephyrus G16',
        'price': 1400000,
        'originalPrice': 1550000,
        'image': Icons.laptop,
        'category': 'laptops',
        'description': 'لابتوب ألعاب متطور مع RTX 4070 ومعالج Intel i9',
        'rating': 4.6,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 5,
      },
      
      // السماعات
      {
        'name': 'AirPods Pro 2',
        'price': 280000,
        'originalPrice': 320000,
        'image': Icons.headphones,
        'category': 'headphones',
        'description': 'سماعات آبل اللاسلكية مع إلغاء الضوضاء التكيفي',
        'rating': 4.8,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 30,
      },
      {
        'name': 'Sony WH-1000XM5',
        'price': 350000,
        'originalPrice': 400000,
        'image': Icons.headset,
        'category': 'headphones',
        'description': 'سماعات لاسلكية بتقنية إلغاء الضوضاء المتطورة',
        'rating': 4.9,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 25,
      },
      {
        'name': 'Bose QuietComfort Ultra',
        'price': 420000,
        'originalPrice': 480000,
        'image': Icons.headphones_battery,
        'category': 'headphones',
        'description': 'سماعات بوز المتطورة مع صوت مكاني غامر',
        'rating': 4.7,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'Sennheiser Momentum 4',
        'price': 380000,
        'originalPrice': 430000,
        'image': Icons.headset_mic,
        'category': 'headphones',
        'description': 'سماعات سينهايزر بجودة صوت استوديو وبطارية 60 ساعة',
        'rating': 4.6,
        'discount': 11,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 20,
      },
      
      // الساعات الذكية
      {
        'name': 'Apple Watch Series 9',
        'price': 450000,
        'originalPrice': 500000,
        'image': Icons.watch,
        'category': 'smartwatches',
        'description': 'ساعة آبل الذكية مع مراقبة صحية متقدمة ومعالج S9',
        'rating': 4.8,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 22,
      },
      {
        'name': 'Samsung Galaxy Watch 6 Classic',
        'price': 380000,
        'originalPrice': 420000,
        'image': Icons.watch_later,
        'category': 'smartwatches',
        'description': 'ساعة سامسونج الكلاسيكية مع إطار دوار وتتبع صحي شامل',
        'rating': 4.6,
        'discount': 9,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'Garmin Fenix 7X Solar',
        'price': 650000,
        'originalPrice': 720000,
        'image': Icons.fitness_center,
        'category': 'smartwatches',
        'description': 'ساعة رياضية متطورة بشحن شمسي ومقاومة عسكرية',
        'rating': 4.7,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      
      // الأجهزة اللوحية
      {
        'name': 'iPad Pro 12.9" M2',
        'price': 1200000,
        'originalPrice': 1350000,
        'image': Icons.tablet_mac,
        'category': 'tablets',
        'description': 'تابلت آبل الاحترافي مع معالج M2 وشاشة Liquid Retina XDR',
        'rating': 4.8,
        'discount': 11,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 14,
      },
      {
        'name': 'Samsung Galaxy Tab S9 Ultra',
        'price': 950000,
        'originalPrice': 1050000,
        'image': Icons.tablet,
        'category': 'tablets',
        'description': 'تابلت سامسونج العملاق مع قلم S Pen وشاشة 14.6 بوصة',
        'rating': 4.7,
        'discount': 9,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 10,
      },
      {
        'name': 'Microsoft Surface Pro 9',
        'price': 1100000,
        'originalPrice': 1200000,
        'image': Icons.tablet_android,
        'category': 'tablets',
        'description': 'تابلت مايكروسوفت 2في1 مع معالج Intel i7 ونظام Windows 11',
        'rating': 4.5,
        'discount': 8,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 8,
      },
      
      // الكاميرات
      {
        'name': 'Canon EOS R5',
        'price': 3200000,
        'originalPrice': 3500000,
        'image': Icons.camera_alt,
        'category': 'cameras',
        'description': 'كاميرا كانون الاحترافية بدقة 45 ميجابكسل وتصوير 8K',
        'rating': 4.9,
        'discount': 8,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 4,
      },
      {
        'name': 'Sony Alpha A7 IV',
        'price': 2800000,
        'originalPrice': 3100000,
        'image': Icons.photo_camera,
        'category': 'cameras',
        'description': 'كاميرا سوني متعددة الاستخدامات بدقة 33 ميجابكسل',
        'rating': 4.8,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 6,
      },
      {
        'name': 'Nikon Z9',
        'price': 4200000,
        'originalPrice': 4600000,
        'image': Icons.camera,
        'category': 'cameras',
        'description': 'كاميرا نيكون الرائدة للمحترفين بدقة 45.7 ميجابكسل',
        'rating': 4.7,
        'discount': 9,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 3,
      },
      
      // أجهزة الألعاب
      {
        'name': 'PlayStation 5 Pro',
        'price': 850000,
        'originalPrice': 920000,
        'image': Icons.sports_esports,
        'category': 'gaming',
        'description': 'جهاز ألعاب سوني الجديد بأداء محسن وتقنية Ray Tracing',
        'rating': 4.8,
        'discount': 7,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 8,
      },
      {
        'name': 'Xbox Series X',
        'price': 720000,
        'originalPrice': 800000,
        'image': Icons.videogame_asset,
        'category': 'gaming',
        'description': 'جهاز ألعاب مايكروسوفت القوي مع Game Pass Ultimate',
        'rating': 4.7,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'Nintendo Switch OLED',
        'price': 480000,
        'originalPrice': 530000,
        'image': Icons.gamepad,
        'category': 'gaming',
        'description': 'جهاز ألعاب نينتندو مع شاشة OLED 7 بوصة',
        'rating': 4.6,
        'discount': 9,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'Steam Deck OLED',
        'price': 650000,
        'originalPrice': 720000,
        'image': Icons.gamepad,
        'category': 'gaming',
        'description': 'جهاز ألعاب محمول من Valve مع مكتبة Steam الكاملة',
        'rating': 4.5,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 6,
      },
      
      // الأجهزة المنزلية الذكية
      {
        'name': 'Samsung Neo QLED 75"',
        'price': 1800000,
        'originalPrice': 2000000,
        'image': Icons.tv,
        'category': 'tv',
        'description': 'تلفزيون سامسونج Neo QLED بدقة 4K وتقنية HDR10+',
        'rating': 4.7,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 5,
      },
      {
        'name': 'LG OLED C3 65"',
        'price': 2200000,
        'originalPrice': 2450000,
        'image': Icons.live_tv,
        'category': 'tv',
        'description': 'تلفزيون LG OLED بتقنية الذكاء الاصطناعي ومعالج α9 Gen6',
        'rating': 4.8,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 4,
      },
      {
        'name': 'Amazon Echo Studio',
        'price': 220000,
        'originalPrice': 250000,
        'image': Icons.speaker,
        'category': 'accessories',
        'description': 'مكبر صوت ذكي من أمازون بصوت محيطي ثلاثي الأبعاد',
        'rating': 4.4,
        'discount': 12,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 25,
      },
      {
         'name': 'Google Nest Hub Max',
         'price': 280000,
         'originalPrice': 320000,
         'image': Icons.smart_display,
         'category': 'أجهزة ذكية',
         'description': 'شاشة ذكية من جوجل بكاميرا وتحكم صوتي متطور',
         'rating': 4.3,
         'discount': 12,
         'currency': 'د.ع',
         'location': 'بغداد',
         'stock': 18,
       },
       
       // الإكسسوارات
       {
         'name': 'MagSafe Charger',
         'price': 85000,
         'originalPrice': 95000,
         'image': Icons.battery_charging_full,
         'category': 'إكسسوارات',
         'description': 'شاحن مغناطيسي لاسلكي من آبل بقوة 15 واط',
         'rating': 4.2,
         'discount': 10,
         'currency': 'د.ع',
         'location': 'بغداد',
         'stock': 50,
       },
       {
         'name': 'Anker PowerBank 20000mAh',
         'price': 120000,
         'originalPrice': 135000,
         'image': Icons.power_bank,
         'category': 'إكسسوارات',
         'description': 'بطارية محمولة عالية السعة مع شحن سريع 22.5 واط',
         'rating': 4.5,
         'discount': 11,
         'currency': 'د.ع',
         'location': 'بغداد',
         'stock': 40,
       },
       {
         'name': 'Logitech MX Master 3S',
         'price': 180000,
         'originalPrice': 200000,
         'image': Icons.mouse,
         'category': 'إكسسوارات',
         'description': 'فأرة لاسلكية احترافية صامتة للمصممين والمطورين',
         'rating': 4.7,
         'discount': 10,
         'currency': 'د.ع',
         'location': 'بغداد',
         'stock': 30,
       },
       {
         'name': 'Apple Magic Keyboard',
         'price': 220000,
         'originalPrice': 250000,
         'image': Icons.keyboard,
         'category': 'إكسسوارات',
         'description': 'لوحة مفاتيح آبل اللاسلكية مع Touch ID',
         'rating': 4.4,
         'discount': 12,
         'currency': 'د.ع',
         'location': 'بغداد',
         'stock': 25,
       },
        
        // منتجات إضافية
        {
          'name': 'Kindle Oasis',
          'price': 320000,
          'originalPrice': 360000,
          'image': Icons.menu_book,
          'category': 'كتب إلكترونية',
          'description': 'قارئ كتب إلكتروني متطور مع إضاءة قابلة للتعديل وشاشة 7 بوصة',
          'rating': 4.3,
          'discount': 11,
          'currency': 'د.ع',
          'location': 'بغداد',
          'stock': 15,
        },
        {
          'name': 'JBL Charge 5',
          'price': 180000,
          'originalPrice': 200000,
          'image': Icons.speaker,
          'category': 'صوتيات',
          'description': 'سماعة بلوتوث مقاومة للماء مع بطارية 20 ساعة',
          'rating': 4.6,
          'discount': 10,
          'currency': 'د.ع',
          'location': 'بغداد',
          'stock': 35,
        },
        {
          'name': 'Dyson V15 Detect',
          'price': 850000,
          'originalPrice': 950000,
          'image': Icons.cleaning_services,
          'category': 'أجهزة منزلية',
          'description': 'مكنسة كهربائية لاسلكية ذكية مع كشف الليزر للغبار',
          'rating': 4.5,
          'discount': 10,
          'currency': 'د.ع',
          'location': 'بغداد',
          'stock': 8,
        },
        {
          'name': 'Philips Hue Starter Kit',
          'price': 220000,
          'originalPrice': 250000,
          'image': Icons.lightbulb,
          'category': 'أجهزة ذكية',
          'description': 'نظام إضاءة ذكي قابل للتحكم مع 16 مليون لون',
          'rating': 4.4,
          'discount': 12,
          'currency': 'ج.س',
          'location': 'الخرطوم',
          'stock': 20,
        },
    ];

    // إضافة الصور للمنتجات حسب الفئة
    Map<String, int> categoryCounters = {};
    
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final category = product['category'] as String;
      
      // تحديث العملة لجميع المنتجات
      product['currency'] = 'ج.س';
      product['location'] = 'الخرطوم';
      
      // إضافة الصورة حسب الفئة
      if (!categoryCounters.containsKey(category)) {
        categoryCounters[category] = 0;
      }
      
      product['image'] = _getProductImage(category, categoryCounters[category]!);
      categoryCounters[category] = categoryCounters[category]! + 1;
    }
    
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text('متجر جيزمو'),
        backgroundColor: Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  ).then((_) => _loadCartData());
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF2A2A2A),
        selectedItemColor:
            Color(0xFFB71C1C),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: AppLocalizations.of(context)!.categories,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: AppLocalizations.of(context)!.wishlist,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildCategoriesTab();
      case 2:
        return _buildFavoritesTab();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFB71C1C),
                  const Color(0xFF8B0000),
                  const Color(0xFFB71C1C).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB71C1C).withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -10,
                  right: -10,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.userType == 'guest' ? Icons.waving_hand : Icons.home,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.userType == 'guest'
                                ? AppLocalizations.of(context)!.welcomeGuest
                                : AppLocalizations.of(context)!.welcome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.discoverLatestProducts,
                      style: const TextStyle(
                        color: Colors.white90,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      children: [
                        _buildStatItem('12+', 'منتج جديد', Icons.new_releases),
                        const SizedBox(width: 20),
                        _buildStatItem('4.8', 'تقييم عالي', Icons.star),
                        const SizedBox(width: 20),
                        _buildStatItem('24/7', 'دعم فني', Icons.support_agent),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Featured products title
          Text(
            AppLocalizations.of(context)!.featuredProducts,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // شبكة المنتجات
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: _getProducts(context).length,
            itemBuilder: (context, index) {
              final product = _getProducts(context)[index];
              return _buildProductCard(product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    String priceStr = price.toString();
    
    // Split into integer and decimal parts
    List<String> parts = priceStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';
    
    // Add thousand separators to integer part
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    
    // Return formatted price
    if (decimalPart.isNotEmpty && decimalPart != '0') {
      return '$formattedInteger.$decimalPart';
    } else {
      return formattedInteger;
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: Product(
                id: product['name'],
                name: product['name'],
                price: product['price'].toDouble(),
                image: 'https://via.placeholder.com/300x300?text=${Uri.encodeComponent(product['name'])}',
                description: product['description'],
                category: product['category'],
                rating: product['rating'].toDouble(),
                reviewsCount: 100,
                featured: false,
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2A2A2A),
              const Color(0xFF1E1E1E),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFB71C1C).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image section
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFB71C1C).withOpacity(0.15),
                    const Color(0xFFB71C1C).withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      product['image'],
                      size: 70,
                      color: const Color(0xFFB71C1C),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${product['rating']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product information section
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['description'],
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product['category'],
                    style: TextStyle(
                      color: const Color(0xFFB71C1C).withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${_formatPrice(product['price'])} ${product['currency'] ?? AppLocalizations.of(context)!.currency}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFB71C1C),
                                const Color(0xFF8B0000),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFB71C1C).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final categories = [
      'الهواتف الذكية',
      'اللابتوبات',
      'السماعات',
      'الأجهزة اللوحية',
      'الساعات الذكية',
      'التلفزيونات'
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفئات',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsScreen(
                          category: categories[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFFB71C1C).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_outline,
            size: 80,
            color: Colors.white54,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.noFavoriteProducts,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(Map<String, dynamic> productData) async {
    // Convert data to Product with safe type conversion
    final product = Product(
      id: productData['name'].toString().replaceAll(' ', '_').toLowerCase(),
      name: productData['name'] ?? '',
      description: 'منتج عالي الجودة من ${productData['category'] ?? ''}',
      price: (productData['price'] ?? 0).toDouble(),
      category: productData['category'] ?? '',
    );

    // Validate product data
    if (product.name.isEmpty || product.price <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalidProductData ??
                'بيانات المنتج غير صحيحة'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Add product to cart
    final cartItem = CartItem(product: product, quantity: 1);
    CartService.addItem(cartItem);

    // Update cart counter
    setState(() {
      _cartItemCount = CartService.totalQuantity;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    '${AppLocalizations.of(context)!.addedToCart} ${product.name}!'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.viewCart,
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnhancedCartScreen(),
                ),
              ).then((_) => _loadCartData());
            },
          ),
        ),
      );
    }
  }

  void _showUserMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person,
                    color: Colors
                        .orange), // Changed from Color(0xFFB71C1C) to orange
                title: Text(
                  widget.userType == 'guest'
                      ? AppLocalizations.of(context)!.guest
                      : AppLocalizations.of(context)!.profile,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings,
                    color: Colors
                        .orange), // Changed from Color(0xFFB71C1C) to orange
                title: Text(
                  AppLocalizations.of(context)!.settings,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.data_usage,
                    color: Colors.orange),
                title: const Text(
                  'إضافة البيانات النموذجية',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSampleDataScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout,
                    color: Colors
                        .orange), // Changed from Color(0xFFB71C1C) to orange
                title: Text(
                  AppLocalizations.of(context)!.logout,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  // Sign out and delete saved data
                  await FirebaseAuthService.signOut(context);

                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on AppLocalizations {
  get invalidProductData => null;
}
