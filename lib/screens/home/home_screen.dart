import 'package:gizmo_store/screens/categories_screen.dart';
import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../models/product.dart';
import '../../models/cart_item.dart';
import '../product/product_detail_screen.dart';
import '../cart/cart_screen.dart';
import '../settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() => _isLoading = true);
      
      final products = await ProductService.getAllProducts();
      final featured = await ProductService.getFeaturedProducts();
      
      setState(() {
        _products = products;
        _featuredProducts = featured;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل المنتجات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Gizmo Store'),
        backgroundColor: const Color(0xFFB71C1C),
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
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              StreamBuilder<int>(
                stream: CartService.cartCountStream,
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  if (count == 0) return const SizedBox.shrink();
                  
                  return Positioned(
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
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: إضافة شاشة البحث
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('البحث ��ريباً!'),
                  backgroundColor: Color(0xFFB71C1C),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF2A2A2A),
        selectedItemColor: const Color(0xFFB71C1C),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'الفئات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب',
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
        return const CategoriesScreen();
      case 2:
        return _buildFavoritesTab();
      case 3:
        return _buildAccountTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB71C1C)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      color: const Color(0xFFB71C1C),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFB71C1C),
                    const Color(0xFFB71C1C).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بك في Gizmo Store!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اكتشف أحدث المنتجات التقنية',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Featured Products
            if (_featuredProducts.isNotEmpty) ...[
              const Text(
                'المنتجات المميزة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredProducts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      child: _buildProductCard(_featuredProducts[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],

            // All Products
            const Text(
              'جميع المنتجات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Products Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_products[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C).withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: product.image != null && product.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Color(0xFFB71C1C),
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.phone_android,
                        size: 60,
                        color: Color(0xFFB71C1C),
                      ),
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
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
                      product.category ?? 'عام',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(0)} ج.س',
                              style: const TextStyle(
                                color: Color(0xFFB71C1C),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (product.originalPrice != null &&
                                product.originalPrice! > product.price)
                              Text(
                                '${product.originalPrice!.toStringAsFixed(0)} ر.س',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _addToCart(product),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB71C1C),
                              borderRadius: BorderRadius.circular(8),
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

  

  Widget _buildFavoritesTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: Colors.white54,
          ),
          SizedBox(height: 20),
          Text(
            'لا توجد منتجات مفضلة بعد',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'اضغط على ♡ لإضافة منتجات للمفضلة',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFB71C1C),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'المستخدم',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          _buildAccountOption(Icons.shopping_bag, 'طلباتي'),
          _buildAccountOption(Icons.location_on, 'العناوين'),
          _buildAccountOption(Icons.payment, 'طرق الدفع'),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFFB71C1C)),
            title: const Text(
              'الإعدادات',
              style: TextStyle(color: Colors.white),
            ),
            trailing:
                const Icon(Icons.arrow_forward_ios, color: Colors.white54),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          _buildAccountOption(Icons.help, 'المس��عدة'),
        ],
      ),
    );
  }

  Widget _buildAccountOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB71C1C)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title قريباً!'),
            backgroundColor: const Color(0xFFB71C1C),
          ),
        );
      },
    );
  }

  void _addToCart(Product product) {
    CartService.addItem(CartItem(product: product, quantity: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('تم إضافة ${product.name} للسلة!'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }
}