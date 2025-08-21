import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // السعر الإجمالي لهذا العنصر في السلة
  double get totalPrice => product.price * quantity;

  // تحويل CartItem إلى Map لتخزينه في Firestore أو أي مصدر بيانات
  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // إنشاء CartItem من Map مأخوذة من Firestore أو أي مصدر بيانات
  factory CartItem.fromMap(Map<String, dynamic> map) {
    final product = Product(
      id: map['productId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      // بقية الخصائص خليك تخليها بقيم افتراضية
      image: '',
      images: [],
      rating: 0,
      reviewsCount: 0,
      category: '',
      specifications: [],
      reviews: [],
    );
    return CartItem(product: product, quantity: map['quantity'] ?? 1);
  }
}
