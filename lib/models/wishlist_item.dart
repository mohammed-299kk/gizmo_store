// lib/models/wishlist_item.dart
import 'product.dart';

class WishlistItem {
  final String id;
  final Product product;
  final DateTime dateAdded;

  WishlistItem({
    required this.id,
    required this.product,
    required this.dateAdded,
  });

  // تحويل إلى Map للحفظ في Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': product.id,
      'productData': product.toMap(), // حفظ بيانات المنتج كاملة
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // إنشاء من Map
  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    // إنشاء المنتج من البيانات المحفوظة
    final productData = map['productData'] as Map<String, dynamic>? ?? {};
    final product = Product.fromMap(productData, map['productId'] ?? '');
    
    return WishlistItem(
      id: map['id'] ?? '',
      product: product,
      dateAdded: DateTime.parse(map['dateAdded'] ?? DateTime.now().toIso8601String()),
    );
  }
}
