import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/services/firestore_service.dart';
import 'package:gizmo_store/screens/product/product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Product> categoryProducts = [];
  bool _isLoading = true;

  // دالة مساعدة لتحديد نوع الصورة وعرضها بشكل صحيح
  Widget _buildImageWidget(String? imagePath,
      {double? width, double? height, BoxFit? fit}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // إذا كانت الصورة تبدأ بـ http أو https فهي من الإنترنت
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    } else {
      // إذا لم تبدأ بـ http فهي صورة محلية
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.grey),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      List<Product> products = [];

      // إضافة منتجات حسب التصنيف
      switch (widget.category) {
        case 'الهواتف':
        case 'smartphones':
          products = _getSmartphones();
          break;
        case 'اللوحيات':
        case 'tablets':
          products = _getTablets();
          break;
        case 'السماعات':
        case 'headphones':
          products = _getHeadphones();
          break;
        case 'الساعات':
        case 'watches':
          products = _getWatches();
          break;
        case 'الملحقات':
        case 'accessories':
          products = _getAccessories();
          break;
        default:
          products =
              await _firestoreService.getProductsByCategory(widget.category);
      }

      setState(() {
        categoryProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دوال لإرجاع منتجات كل تصنيف
  List<Product> _getSmartphones() {
    return [
      Product(
        id: '1',
        name: 'iPhone 15 Pro Max',
        description:
            'أحدث هاتف من آبل مع معالج A17 Pro وكاميرا 48 ميجابكسل المتطورة',
        price: 2850000,
        originalPrice: 3200000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-max-naturaltitanium-select?wid=470&hei=556&fmt=png-alpha&.v=1692845702708',
        category: 'الهواتف الذكية',
        featured: true,
        discount: 11,
        rating: 4.9,
        reviewsCount: 1247,
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24 Ultra',
        description:
            'هاتف سامسونج الرائد مع قلم S Pen وكاميرا 200 ميجابكسل وذكاء اصطناعي',
        price: 2450000,
        originalPrice: 2750000,
        image:
            'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bztqmea-thumb-539573043',
        category: 'الهواتف الذكية',
        featured: true,
        discount: 11,
        rating: 4.8,
        reviewsCount: 892,
      ),
      Product(
        id: '3',
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
      ),
      Product(
        id: '4',
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
      ),
      Product(
        id: '5',
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
      ),
      Product(
        id: '15',
        name: 'iPhone 14 Pro',
        description: 'هاتف آيفون 14 برو مع شاشة Dynamic Island',
        price: 2200000,
        originalPrice: 2500000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-14-pro-deep-purple-select?wid=470&hei=556&fmt=png-alpha&.v=1663703841896',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 12,
        rating: 4.7,
        reviewsCount: 892,
      ),
      Product(
        id: '16',
        name: 'Samsung Galaxy S23',
        description: 'هاتف سامسونج جالاكسي S23 مع كاميرا محسنة',
        price: 1800000,
        originalPrice: 2000000,
        image:
            'https://images.samsung.com/is/image/samsung/p6pim/levant/2302/gallery/levant-galaxy-s23-s911-sm-s911bzaamea-thumb-534850043',
        category: 'الهواتف الذكية',
        featured: false,
        discount: 10,
        rating: 4.6,
        reviewsCount: 567,
      ),
    ];
  }

  List<Product> _getTablets() {
    return [
      Product(
        id: '6',
        name: 'iPad Pro 12.9 بوصة M2',
        description: 'جهاز آيباد الاحترافي مع معالج M2 وشاشة Liquid Retina XDR',
        price: 980000,
        originalPrice: 1100000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/ipad-pro-12-select-wifi-spacegray-202210?wid=470&hei=556&fmt=png-alpha&.v=1664411207213',
        category: 'الأجهزة اللوحية',
        featured: true,
        discount: 11,
        rating: 4.8,
        reviewsCount: 156,
      ),
      Product(
        id: '7',
        name: 'Samsung Galaxy Tab S9 Ultra',
        description: 'جهاز لوحي من سامسونج بشاشة كبيرة وقلم S Pen',
        price: 850000,
        originalPrice: 950000,
        image:
            'https://images.samsung.com/is/image/samsung/p6pim/levant/2307/gallery/levant-galaxy-tab-s9-ultra-x910-sm-x910nzeamea-thumb-537185043',
        category: 'الأجهزة اللوحية',
        featured: false,
        discount: 10,
        rating: 4.5,
        reviewsCount: 89,
      ),
      Product(
        id: '17',
        name: 'iPad Air M2',
        description: 'آيباد إير مع معالج M2 وتصميم نحيف',
        price: 650000,
        originalPrice: 750000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/ipad-air-select-wifi-blue-202203?wid=470&hei=556&fmt=png-alpha&.v=1645065732688',
        category: 'الأجهزة اللوحية',
        featured: false,
        discount: 13,
        rating: 4.6,
        reviewsCount: 234,
      ),
    ];
  }

  List<Product> _getHeadphones() {
    return [
      Product(
        id: '8',
        name: 'AirPods Pro 2',
        description: 'سماعات آبل اللاسلكية مع إلغاء الضوضاء النشط',
        price: 180000,
        originalPrice: 220000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQD83?wid=470&hei=556&fmt=png-alpha&.v=1660803972361',
        category: 'السماعات',
        featured: true,
        discount: 18,
        rating: 4.8,
        reviewsCount: 345,
      ),
      Product(
        id: '9',
        name: 'Sony WH-1000XM5',
        description: 'سماعات سوني الاحترافية مع أفضل إلغاء ضوضاء',
        price: 250000,
        originalPrice: 290000,
        image:
            'https://www.sony.com/image/5d02da5df552836db894c9e3e5a9b6e8?fmt=pjpeg&wid=330&bgcolor=FFFFFF&bgc=FFFFFF',
        category: 'السماعات',
        featured: true,
        discount: 14,
        rating: 4.9,
        reviewsCount: 189,
      ),
      Product(
        id: '18',
        name: 'Bose QuietComfort 45',
        description: 'سماعات بوز مع إلغاء ضوضاء متطور',
        price: 220000,
        originalPrice: 260000,
        image:
            'https://assets.bose.com/content/dam/cloudassets/Bose_DAM/Web/consumer_electronics/global/products/headphones/qc45_headphones/product_silo_images/QC45_PDP_Ecom-Gallery-B01.jpg',
        category: 'السماعات',
        featured: false,
        discount: 15,
        rating: 4.7,
        reviewsCount: 167,
      ),
    ];
  }

  List<Product> _getWatches() {
    return [
      Product(
        id: '10',
        name: 'Apple Watch Series 9',
        description: 'ساعة آبل الذكية مع مستشعرات صحية متطورة',
        price: 320000,
        originalPrice: 380000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/watch-s9-45mm-pink-sport-band-pink-pdp-image-position-1__en-us?wid=470&hei=556&fmt=png-alpha&.v=1692720175893',
        category: 'الساعات الذكية',
        featured: true,
        discount: 16,
        rating: 4.7,
        reviewsCount: 234,
      ),
      Product(
        id: '11',
        name: 'Samsung Galaxy Watch 6',
        description: 'ساعة سامسونج الذكية مع تتبع صحي شامل',
        price: 280000,
        originalPrice: 320000,
        image:
            'https://images.samsung.com/is/image/samsung/p6pim/levant/2307/gallery/levant-galaxy-watch6-r930-sm-r930nzsemea-thumb-537185042',
        category: 'الساعات الذكية',
        featured: false,
        discount: 12,
        rating: 4.4,
        reviewsCount: 167,
      ),
      Product(
        id: '19',
        name: 'Garmin Venu 3',
        description: 'ساعة جارمين الرياضية مع GPS',
        price: 350000,
        originalPrice: 400000,
        image:
            'https://static.garmin.com/en/products/010-02784-11/g/cf-lg-bb0c4e0e-4b0e-4b0e-8b0e-4b0e4b0e4b0e.jpg',
        category: 'الساعات الذكية',
        featured: false,
        discount: 12,
        rating: 4.6,
        reviewsCount: 89,
      ),
    ];
  }

  List<Product> _getAccessories() {
    return [
      Product(
        id: '12',
        name: 'كابل USB-C إلى Lightning',
        description: 'كابل شحن أصلي من آبل بطول متر واحد',
        price: 25000,
        originalPrice: 30000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQGH3?wid=470&hei=556&fmt=png-alpha&.v=1661957814710',
        category: 'الملحقات',
        featured: false,
        discount: 17,
        rating: 4.3,
        reviewsCount: 89,
      ),
      Product(
        id: '13',
        name: 'شاحن لاسلكي MagSafe',
        description: 'شاحن لاسلكي أصلي من آبل بقوة 15 واط',
        price: 45000,
        originalPrice: 55000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MHXH3?wid=470&hei=556&fmt=png-alpha&.v=1661957814710',
        category: 'الملحقات',
        featured: false,
        discount: 18,
        rating: 4.6,
        reviewsCount: 156,
      ),
      Product(
        id: '20',
        name: 'حافظة iPhone 15 Pro Max',
        description: 'حافظة جلدية أصلية من آبل',
        price: 35000,
        originalPrice: 42000,
        image:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MT4J3?wid=470&hei=556&fmt=png-alpha&.v=1693594197139',
        category: 'الملحقات',
        featured: false,
        discount: 17,
        rating: 4.4,
        reviewsCount: 234,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('منتجات ${widget.category}'),
        backgroundColor: const Color(0xFFB71C1C),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryProducts.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد منتجات في هذا التصنيف',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: categoryProducts.length,
                  itemBuilder: (context, index) {
                    final product = categoryProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: _buildImageWidget(
                                  product.image,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text('${product.rating}'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Color(0xFFB71C1C),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (product.discount! > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${product.discount}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
