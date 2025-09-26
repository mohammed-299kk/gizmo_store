import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../utils/image_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  // دالة للحصول على جميع صور المنتج
  List<String> _getProductImages() {
    final category = widget.product['category'] as String;
    
    // خريطة الصور حسب الفئات
    final Map<String, List<String>> categoryImages = {
      'سماعات': [
        'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61jLBqaAUPL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81Dm7eZw2KL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61EKOWP+AFL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61CBni+XbxL._AC_SL1500_.jpg',
      ],
      'أجهزة كمبيوتر محمولة': [
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81bc8mS3nhL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71CmvZqujCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61Qe0euJJZL._AC_SL1500_.jpg',
      ],
      'هواتف ذكية': [
        'https://m.media-amazon.com/images/I/71xb2xkN5qL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81OS7lnaaIL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71GLMJ7TQiL._AC_SL1500_.jpg',
      ],
      'أجهزة لوحية': [
        'https://m.media-amazon.com/images/I/81NiQ+BrVBL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
      ],
      'ساعات ذكية': [
        'https://m.media-amazon.com/images/I/71u1JbqAojL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BVbdhqzxL._AC_SL1500_.jpg',
      ],
      'أجهزة تلفزيون': [
        'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/nanocell/75nano766qa/75nano766qa-1.jpg',
        'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg',
      ],
      'الأجهزة المنزلية الذكية': [
        'https://m.media-amazon.com/images/I/61ZPOMEZPaL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BVbdhqzxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81OS7lnaaIL._AC_SL1500_.jpg',
      ],
      'الإكسسوارات': [
        'https://m.media-amazon.com/images/I/61CBni+XbxL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71GLMJ7TQiL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61Qe0euJJZL._AC_SL1500_.jpg',
      ],
    };

    return categoryImages[category] ?? [widget.product['image'] ?? 'https://via.placeholder.com/300x300?text=No+Image'];
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _addToCart() {
    try {
      // Create a Product object from the widget.product data
      final product = Product(
        id: widget.product['id'] ?? '',
        name: widget.product['name'] ?? '',
        description: widget.product['description'] ?? '',
        price: (widget.product['price'] ?? 0).toDouble(),
        image: widget.product['image'] ?? '',
        images: widget.product['images'] != null 
          ? List<String>.from(widget.product['images']) 
          : [],
        rating: (widget.product['rating'] ?? 0).toDouble(),
        reviewsCount: widget.product['reviewsCount'] ?? 0,
        category: widget.product['category'] ?? '',
        brand: widget.product['brand'] ?? '',
        specifications: widget.product['specifications'] != null 
          ? List<String>.from(widget.product['specifications']) 
          : [],
        reviews: widget.product['reviews'] != null 
          ? List<Map<String, dynamic>>.from(widget.product['reviews']) 
          : [],
      );

      final cartItem = CartItem(
        product: product,
        quantity: _quantity,
      );

      CartService.addItem(cartItem);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة ${widget.product['name']} إلى السلة'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء إضافة المنتج: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = _getProductImages();
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(widget.product['name']),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معرض الصور
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageHelper.buildCachedImage(
                  imageUrl: images[_selectedImageIndex],
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // صور مصغرة
            if (images.length > 1)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImageIndex == index 
                                ? const Color(0xFFB71C1C) 
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: ImageHelper.buildCachedImage(
                            imageUrl: images[index],
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 24),
            
            // اسم المنتج
            Text(
              widget.product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // التقييم
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < (widget.product['rating'] ?? 0).floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  '(${widget.product['rating'] ?? 0})',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // السعر
            Row(
              children: [
                Text(
                  '${_formatPrice(widget.product['price'])} ${widget.product['currency']}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                if (widget.product['originalPrice'] != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '${_formatPrice(widget.product['originalPrice'])} ${widget.product['currency']}',
                      style: const TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
            
            if (widget.product['discount'] != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'خصم ${widget.product['discount']}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // الوصف
            const Text(
              'الوصف',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product['description'] ?? 'لا يوجد وصف متاح',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // معلومات إضافية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الفئة:', style: TextStyle(color: Colors.grey)),
                      Text(
                        widget.product['category'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('المخزون:', style: TextStyle(color: Colors.grey)),
                      Text(
                        '${widget.product['stock'] ?? 0} قطعة',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الموقع:', style: TextStyle(color: Colors.grey)),
                      Text(
                        widget.product['location'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // اختيار الكمية
            Row(
              children: [
                const Text(
                  'الكمية:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1 ? () {
                          setState(() {
                            _quantity--;
                          });
                        } : null,
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _quantity < (widget.product['stock'] ?? 1) ? () {
                          setState(() {
                            _quantity++;
                          });
                        } : null,
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: (widget.product['stock'] ?? 0) > 0 ? _addToCart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              (widget.product['stock'] ?? 0) > 0 
                  ? 'إضافة إلى السلة - ${_formatPrice(widget.product['price'] * _quantity)} ${widget.product['currency']}'
                  : 'غير متوفر',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
