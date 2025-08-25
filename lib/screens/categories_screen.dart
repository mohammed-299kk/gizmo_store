
import 'package:flutter/material.dart';
import 'package:gizmo_store/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Category> categories = const [
    Category(name: 'لابتوبات', imageUrl: 'assets/images/1n5gi5M9kKtF.jpg'),
    Category(name: 'هواتف ذكية', imageUrl: 'assets/images/2NW6vf5DSxvQ.webp'),
    Category(name: 'سماعات', imageUrl: 'assets/images/75Lj48dHxUwP.png'),
    Category(name: 'ساعات ذكية', imageUrl: 'assets/images/8OYsYEhxLUdM.png'),
    Category(name: 'كاميرات', imageUrl: 'assets/images/9kMcFvhwewBw.jpg'),
    Category(name: 'أجهزة لوحية', imageUrl: 'assets/images/a3Y1WRJNpv4O.jpg'),
    Category(name: 'طائرات بدون طيار', imageUrl: 'assets/images/As9HuTC22Qgf.jpg'),
    Category(name: 'ألعاب الفيديو', imageUrl: 'assets/images/bLf4l9Wb4pFL.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفئات'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(
                categories[i].name,
                textAlign: TextAlign.center,
              ),
            ),
            child: Image.asset(
              categories[i].imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
