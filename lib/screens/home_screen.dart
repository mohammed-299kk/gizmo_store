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

  List<Map<String, dynamic>> _getProducts(BuildContext context) {
    return [
      // الهواتف الذكية
      {
        'name': 'iPhone 15 Pro Max',
        'price': 1450000,
        'originalPrice': 1550000,
        'image': Icons.phone_iphone,
        'category': AppLocalizations.of(context)!.categoryPhones,
        'description': 'أحدث هاتف من آبل بمعالج A17 Pro وكاميرا تيتانيوم',
        'rating': 4.9,
        'discount': 6,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 12,
      },
      {
        'name': 'Samsung Galaxy S24 Ultra',
        'price': 780000,
        'originalPrice': 850000,
        'image': Icons.smartphone,
        'category': AppLocalizations.of(context)!.categoryPhones,
        'description': 'هاتف ذكي متطور مع كاميرا 200 ميجابكسل وقلم S Pen',
        'rating': 4.8,
        'discount': 8,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 15,
      },
      {
        'name': 'Google Pixel 8 Pro',
        'price': 650000,
        'originalPrice': 720000,
        'image': Icons.phone_android,
        'category': AppLocalizations.of(context)!.categoryPhones,
        'description': 'هاتف جوجل بكاميرا ذكية وذكاء اصطناعي متطور',
        'rating': 4.7,
        'discount': 10,
        'currency': 'د.ع',
        'location': 'بغداد',
        'stock': 18,
      },
      {
        'name': 'OnePlus 12',
        'price': 580000,
        'originalPrice': 630000,
        'image': Icons.smartphone,
        'category': AppLocalizations.of(context)!.categoryPhones,
        'description': 'هاتف ون بلس بشحن سريع 100 واط ومعالج Snapdragon 8 Gen 3',
        'rating': 4.6,
        'discount': 8,
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
        'category': AppLocalizations.of(context)!.categoryComputers,
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
        'category': AppLocalizations.of(context)!.categoryComputers,
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
        'category': AppLocalizations.of(context)!.categoryComputers,
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
        'category': AppLocalizations.of(context)!.categoryComputers,
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
        'category': AppLocalizations.of(context)!.categoryHeadphones,
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
        'category': AppLocalizations.of(context)!.categoryHeadphones,
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
        'category': AppLocalizations.of(context)!.categoryHeadphones,
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
        'category': AppLocalizations.of(context)!.categoryHeadphones,
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
        'category': AppLocalizations.of(context)!.categoryWatches,
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
        'category': AppLocalizations.of(context)!.categoryWatches,
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
        'category': AppLocalizations.of(context)!.categoryWatches,
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
        'category': AppLocalizations.of(context)!.categoryTablets,
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
        'category': AppLocalizations.of(context)!.categoryTablets,
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
        'category': AppLocalizations.of(context)!.categoryTablets,
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
        'category': 'كاميرات',
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
        'category': 'كاميرات',
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
        'category': 'كاميرات',
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
        'category': 'ألعاب',
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
        'category': 'ألعاب',
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
        'category': 'ألعاب',
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
        'category': 'ألعاب',
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
        'category': AppLocalizations.of(context)!.categoryTv,
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
        'category': AppLocalizations.of(context)!.categoryTv,
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
        'category': 'أجهزة ذكية',
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
          'currency': 'د.ع',
          'location': 'بغداد',
          'stock': 20,
        },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor:
            Color(0xFFB71C1C),
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
                      builder: (context) => const EnhancedCartScreen(),
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
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              _showUserMenu();
            },
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
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
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
    return Container(
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
    );
  }

  Widget _buildCategoriesTab() {
    final categories = [
      AppLocalizations.of(context)!.phones,
      AppLocalizations.of(context)!.computers,
      AppLocalizations.of(context)!.headphones,
      AppLocalizations.of(context)!.tablets,
      AppLocalizations.of(context)!.watches,
      AppLocalizations.of(context)!.televisions
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.categories,
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
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
