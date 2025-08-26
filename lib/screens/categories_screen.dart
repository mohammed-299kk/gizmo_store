
import 'package:flutter/material.dart';
import 'package:gizmo_store/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Category> categories = const [
    Category(name: 'لابتوبات', imageUrl: 'assets/images/1n5gi5M9kKtF.jpg'),
    Category(name: 'هواتف ذكية', imageUrl: 'assets/images/2NW6vf5DSxvQ.webp'),
    Category(name: 'سماعات', imageUrl: 'assets/images/75Lj48dHxUwP.png'),
    Category(name: 'ساعات ذكية', imageUrl: 'assets/images/8OYsYEhxLUdM.png'),
    Category(name: 'أجهزة لوحية', imageUrl: 'assets/images/a3Y1WRJNpv4O.jpg'),
  ];

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2, // Reduced from 3/2 to make icons smaller
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (ctx, i) => _buildCategoryCard(categories[i]),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reduced image size
          Container(
            width: 80, // Reduced from default size
            height: 80, // Reduced from default size
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB71C1C).withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                category.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      _getCategoryIcon(category.name),
                      size: 40,
                      color: const Color(0xFFB71C1C),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            category.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
