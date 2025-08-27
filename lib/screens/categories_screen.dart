
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gizmo_store/models/category.dart';
import 'package:gizmo_store/screens/category_products_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('order', descending: false)
          .get();

      final List<Category> loadedCategories = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category(
          id: doc.id,
          name: data['name'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          order: data['order'] ?? 0,
          isActive: data['isActive'] ?? true,
        );
      }).where((category) => category.isActive).toList();

      // If no categories found in Firebase, use fallback categories
      if (loadedCategories.isEmpty) {
        loadedCategories.addAll(_getFallbackCategories());
      }

      setState(() {
        categories = loadedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        categories = _getFallbackCategories();
        isLoading = false;
        errorMessage = 'فشل في تحميل الفئات. يتم عرض الفئات الافتراضية.';
      });
    }
  }

  List<Category> _getFallbackCategories() {
    return [
      Category(
        id: '1',
        name: 'هواتف ذكية',
        imageUrl: 'https://via.placeholder.com/300x300?text=Smartphones',
        order: 1,
        isActive: true,
      ),
      Category(
        id: '2',
        name: 'لابتوبات',
        imageUrl: 'https://via.placeholder.com/300x300?text=Laptops',
        order: 2,
        isActive: true,
      ),
      Category(
        id: '3',
        name: 'سماعات',
        imageUrl: 'https://via.placeholder.com/300x300?text=Headphones',
        order: 3,
        isActive: true,
      ),
      Category(
        id: '4',
        name: 'ساعات ذكية',
        imageUrl: 'https://via.placeholder.com/300x300?text=Smartwatches',
        order: 4,
        isActive: true,
      ),
      Category(
        id: '5',
        name: 'أجهزة لوحية',
        imageUrl: 'https://via.placeholder.com/300x300?text=Tablets',
        order: 5,
        isActive: true,
      ),
      Category(
        id: '6',
        name: 'إكسسوارات',
        imageUrl: 'https://via.placeholder.com/300x300?text=Accessories',
        order: 6,
        isActive: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('الفئات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCategories,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFB71C1C),
            ),
            SizedBox(height: 16),
            Text(
              'جاري تحميل الفئات...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد فئات متاحة',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCategories,
      color: const Color(0xFFB71C1C),
      child: Column(
        children: [
          if (errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85, // Increased height for larger images
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (ctx, i) => _buildCategoryCard(categories[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              category: category.name,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2A2A),
              Color(0xFF1F1F1F),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enhanced image with larger size
            Container(
              width: 120, // Increased size for better visibility
              height: 120, // Increased size for better visibility
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB71C1C).withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: category.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFB71C1C),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: Icon(
                      _getCategoryIcon(category.name),
                      size: 50,
                      color: const Color(0xFFB71C1C),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'لابتوبات':
        return Icons.laptop_mac;
      case 'هواتف ذكية':
        return Icons.smartphone;
      case 'سماعات':
        return Icons.headphones;
      case 'ساعات ذكية':
        return Icons.watch;
      case 'أجهزة لوحية':
        return Icons.tablet_mac;
      default:
        return Icons.category;
    }
  }
}
